
% Gestione deelle differenti piattaforme da cui si chiama il codice

base_directory = '/nfsd/biopetmri3/biopetmri_tesi/PalombaGianmarco_2020';
% ALTERNATIVA PC LOCALE 
% base_directory = '/mnt/f/utente/tesi

data_path=fullfile(base_directory,'Dati');
output_path=fullfile(base_directory,'Output');

% elenco soggetti
list=dir(data_path);

jobdir=fullfile(base_directory,'Code','Jobs');
if not(exist(jobdir,'dir'))
    mkdir(jobdir)
end
filename_qsub=fullfile(base_directory,'Code','Jobs',['JacDet_sbatch_4_slurm_' datestr(now,30) '.txt']);
ID_file_recap=fopen(filename_qsub,'w');

jobdir=fullfile(base_directory,'Code','Jobs','Exex_slurm');
if not(exist(jobdir,'dir'))
    mkdir(jobdir)
end
fprintf(ID_file_recap,['cd ' jobdir ' \n']);


for k=3:length(list)
    
    subjID = list(k).name;
    subj_path=fullfile(data_path, subjID);

    subj_data_list=dir(subj_path);

    for d=3:length(subj_data_list)
        % trovare baseline e followup (almeno 3 anni di differenza )
    end

    % baseline
    % followup

                % creo file job
                exam=subj_data_list(d).name;
                jobName=['JD' num2str(str2num( subjID)) '_' baseline '_' followup '.job'];
                 
                ID_file=fopen(fullfile(jobdir, jobName),'w');

                fprintf(ID_file,['#!/bin/bash \n'...
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
                    'export ANTSDIR=/nfsd/biopetmri3/biopetmri_tesi/PalombaGianmarco_2020/Code/ANTs\n' ...
                    'export PATH=$PATH:$ANTSDIR\n' ...
                    'export PATH=$PATH:/nfsd/biopetmri3/biopetmri_tesi/PalombaGianmarco_2020/Code\n' ...
                    'export PATH=$PATH:/nfsd/biopetmri3/biopetmri_tesi/PalombaGianmarco_2020/Code/c3d\n' ...
                    'export PATH=$PATH:/nfsd/biopetmri3/biopetmri_tesi/PalombaGianmarco_2020/Code/SEL/code_shell\n' ...
                    '\n'...
                    'TARGET=' data_processed_path ' \n'...
                    '\n'...
                    'input1_T1=' fullfile(subj_path,baseline,'T13DTFE_N4.nii.gz') '\n'...
                    'input1_T1=' fullfile(subj_path,followup,'T13DTFE_N4.nii.gz') '\n'...
                    input1_FLAIR=/mnt/f/utente/tesi/dati_sel/000004/20150413/3DFLAIR_N4.nii.gz
                    input2_FLAIR=/mnt/f/utente/tesi/dati_sel/000004/20190304/3DFLAIR_N4.nii.gz
                    mask1=/mnt/f/utente/tesi/dati_sel/000004/20150413/ct/BrainExtractionMask.nii.gz
                    mask2=/mnt/f/utente/tesi/dati_sel/000004/20190304/ct/BrainExtractionMask.nii.gz
                    lesion_mask1=/mnt/f/utente/tesi/dati_sel/000004/20150413/baseline_2ch_hard_seg.nii.gz
                    lesion_mask2=/mnt/f/utente/tesi/dati_sel/000004/20190304/baseline_2ch_hard_seg.nii.gz
                    'output=' fullfile(output_path,subjID,[baseline '_' followup]) '\n'...
                    'mkdir -p $output\n'
                    'srun registration  $input1_T1 $input2_T1 $input1_FLAIR $input2_FLAIR $mask1 $mask2 $lesion_mask1 $lesion_mask2 $output '
                    '\n\n']);
                
                fclose(ID_file);
                
                fprintf(ID_file_recap,['sbatch ' fullfile(jobdir, jobName) ' \n']);
            
            
end

fclose(ID_file_recap);
