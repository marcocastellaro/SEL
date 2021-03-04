clear all 
close all
clc

% Gestione deelle differenti piattaforme da cui si chiama il codice

%base_directory = '/nfsd/biopetmri3/biopetmri_tesi/PalombaGianmarco_2020';
% ALTERNATIVA PC LOCALE 
base_directory = 'F:\Utente\TESI\';

data_path=fullfile(base_directory,'Dati');
output_path=fullfile(base_directory,'Output');

% elenco soggetti
list=dir(data_path);

jobdir=fullfile(base_directory,'Code','Jobs');
if not(exist(jobdir,'dir'))
    mkdir(jobdir)
end
filename_qsub=fullfile(base_directory,'Code','Jobs',['LesionsMask_sbatch_4_slurm_' datestr(now,30) '.txt']);
ID_file_recap=fopen(filename_qsub,'w');

jobdir=fullfile(base_directory,'Code','Jobs','Exex_slurm_LesionsMask');
if not(exist(jobdir,'dir'))
    mkdir(jobdir)
end
fprintf(ID_file_recap,['cd ' jobdir ' \n']);


for k=3:length(list)
    
    subjID = list(k).name;
    subj_path=fullfile(data_path, subjID);

    subj_data_list=dir(subj_path);
    
    baseline = subj_data_list(3).name;
    FormatIn = 'yyyymmdd';
    baseline_day = datenum(baseline,FormatIn);
    
    for d=3:length(subj_data_list)
        % trovare baseline e followup (almeno 3 anni di differenza )
        followup = subj_data_list(d).name;
        followup_day = datenum(followup,FormatIn);
        diff = (followup_day - baseline_day)/365.2425;
        
        if (diff > 3)
            break
        end
        followup = [];
    end


    % baseline
    % followup
    if (~isempty(followup))
                % creo file job
                exam=subj_data_list(d).name;
                jobName=['JD' num2str(str2num( subjID)) '_' baseline '_' followup '.job'];
                 
                ID_file=fopen(fullfile(jobdir, jobName),'wt');

                fprintf(ID_file,['#!/bin/bash\n'...
                    '#SBATCH --output ' jobName '.o%%j.txt\n'...
                    '#SBATCH --error ' jobName '.e%%j.txt\n'...
                    '#SBATCH --mail-user palombagia@dei.unipd.it\n'...
                    '#SBATCH --mail-type ALL\n'...
                    '#SBATCH --time 100:00:00\n'...
                    '#SBATCH --ntasks 1\n'...
                    '#SBATCH -c 4\n'...
                    '#SBATCH --exclude=gpu1,gpu2,runner-07,runner-08,runner-13,runner-14,runner-15,runner-16,runner-17,runner-18,runner-19\n'... 
                    '#SBATCH --partition allgroups\n'...
                    '#SBATCH --mem 16G\n'...
                    '\n'...
                    'export OMP_NUM_THREADS=4\n'...
                    'source /nfsd/opt/FSL/fsl603_env.sh\n'...
                    'export ANTSDIR=/nfsd/biopetmri3/biopetmri_tesi/PalombaGianmarco_2020/Code/ANTs\n'...
                    'export PATH=$PATH:$ANTSDIR\n' ...
                    'export PATH=$PATH:/nfsd/biopetmri3/biopetmri_tesi/PalombaGianmarco_2020/Code\n'...
                    'export PATH=$PATH:/nfsd/biopetmri3/biopetmri_tesi/PalombaGianmarco_2020/Code/c3d\n'...
                    'export PATH=$PATH:/nfsd/biopetmri3/biopetmri_tesi/PalombaGianmarco_2020/Code/SEL/code_shell\n'...
                    '\n'...
                    '\n'...
                    'lesion_mask1=' fullfile(subj_path,baseline,'nicMS_Lesion','lesions_prob.nii.gz') '\n'...
                    'lesion_mask2=' fullfile(subj_path,followup,'nicMS_Lesion','lesions_prob.nii.gz') '\n'...
                    'output=' fullfile(output_path,subjID,[baseline '_' followup]) '\n'...
                    'srun ./registration_mask $lesion_mask1 $lesion_mask2 $output\n'...
                    '\n\n']);
                
               fclose(ID_file);
                
               fprintf(ID_file_recap,['sbatch ' fullfile(jobdir, jobName) '\n']);
    end
            
end

fclose(ID_file_recap);
