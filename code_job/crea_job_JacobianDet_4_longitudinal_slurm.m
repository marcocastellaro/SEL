clear all 
close all
clc

% Gestione deelle differenti piattaforme da cui si chiama il codice

base_directory = '/nfsd/biopetmri/BACKUP/Users/Marco/3T_Verona/SEL_candidates/';
% ALTERNATIVA PC LOCALE 
%base_directory = 'F:\Utente\TESI\';

data_path=fullfile(base_directory,'data_longitudinal');
output_path=fullfile(base_directory,'output_longitudinal');

% elenco soggetti
list_data=dir(data_path);
list_output=dir(output_path);

jobdir=fullfile(base_directory,'code','Jobs');
if not(exist(jobdir,'dir'))
    mkdir(jobdir)
end
filename_qsub=fullfile(base_directory,'code','Jobs',['JacDet_sbatch_4_longitudinal_slurm_' datestr(now,30) '.txt']);
ID_file_recap=fopen(filename_qsub,'w');

jobdir=fullfile(base_directory,'code','Jobs','Exex_slurm_longitudinal');
if not(exist(jobdir,'dir'))
    mkdir(jobdir)
end
fprintf(ID_file_recap,['cd ' strrep(jobdir,'\','/') ' \n']);

d = 2;
for k=3:4:length(list_data)
    d = d + 1;
    subjID_1 = list_data(k).name;
    subjID_2 = list_data(k+1).name;
    subjID_3 = list_data(k+2).name;
    subjID_4 = list_data(k+3).name;

    subjID = list_output(d).name;    
    
    subj_path_1=fullfile(data_path, subjID_1);
    subj_path_2=fullfile(data_path, subjID_2);
    subj_path_3=fullfile(data_path, subjID_3);
    subj_path_4=fullfile(data_path, subjID_4);

    subj_data_list_1=dir(subj_path_1);
    subj_data_list_2=dir(subj_path_2);
    subj_data_list_3=dir(subj_path_3);
    subj_data_list_4=dir(subj_path_4);

    date1 = subj_data_list_1(3).name;
    date2 = subj_data_list_2(3).name;
    date3 = subj_data_list_3(3).name;
    date4 = subj_data_list_4(3).name;  % aggiungere ad ogni time point nei la cartella con la data

    
    % creo file job
                jobName=['JD_' num2str(str2num(subjID)) '.job'];
                 
                ID_file=fopen(fullfile(jobdir, jobName),'wt');
                
               
                fprintf(ID_file,['#!/bin/bash\n'...
                    '#SBATCH --output ' jobName '.o%%j.txt\n'...
                    '#SBATCH --error ' jobName '.e%%j.txt\n'...
                    '#SBATCH --mail-user palombagia@dei.unipd.it\n'...
                    '#SBATCH --mail-type ALL\n'...
                    '#SBATCH --ntasks 1\n'...
                    '#SBATCH -c 4\n'...
                    '#SBATCH --exclude=gpu1,gpu2,runner-07,runner-08,runner-13,runner-14,runner-15,runner-16,runner-17,runner-18,runner-19\n'... 
                    '#SBATCH --partition allgroups\n'...
                    '#SBATCH --mem 16G\n'...
                    '\n'...
                    'export OMP_NUM_THREADS=4\n'...
                    'source /nfsd/opt/FSL/fsl603_env.sh\n'...
                    'export ANTSDIR=/nfsd/biopetmri/BACKUP/DB_Neuro/Software/ANTs/bin_20160226\n' ...
                    'export PATH=$ANTSDIR:$PATH\n' ...
                    'export PATH=$PATH:/nfsd/biopetmri/BACKUP/Users/Marco/3T_Verona/SEL_candidates/code\n'...
                    'export PATH=$PATH:/nfsd/biopetmri/BACKUP/Users/Marco/3T_Verona/SEL_candidates/code/c3d\n'...
                    'export PATH=$PATH:/nfsd/biopetmri/BACKUP/Users/Marco/3T_Verona/SEL_candidates/SEL/code_shell\n'...
                    'export PATH=$PATH:/nfsd/biopetmri/BACKUP/Users/Marco/3T_Verona/SEL_candidates/SEL/code_shell/registration_longitudinal\n'...
                    '\n'...
                    '\n'...
                    'T1_1=' strrep(fullfile(subj_path_1,'T1.nii.gz'),'\','/') '\n'...
                    'T1_2=' strrep(fullfile(subj_path_2,'T1.nii.gz'),'\','/') '\n'...
                    'T1_3=' strrep(fullfile(subj_path_3,'T1.nii.gz'),'\','/') '\n'...
                    'T1_4=' strrep(fullfile(subj_path_4,'T1.nii.gz'),'\','/') '\n'...
                    '\n' ...
                    'T2_1=' strrep(fullfile(subj_path_1,'T2_to_T1.nii.gz'),'\','/') '\n'...
                    'T2_2=' strrep(fullfile(subj_path_2,'T2_to_T1.nii.gz'),'\','/') '\n'...
                    'T2_3=' strrep(fullfile(subj_path_3,'T2_to_T1.nii.gz'),'\','/') '\n'...
                    'T2_4=' strrep(fullfile(subj_path_4,'T2_to_T1.nii.gz'),'\','/') '\n'...
                    '\n' ...
                    'FLAIR_1=' strrep(fullfile(subj_path_1,'FLAIR_to_T1.nii.gz'),'\','/') '\n'...
                    'FLAIR_2=' strrep(fullfile(subj_path_2,'FLAIR_to_T1.nii.gz'),'\','/') '\n'...
                    'FLAIR_3=' strrep(fullfile(subj_path_3,'FLAIR_to_T1.nii.gz'),'\','/') '\n'...
                    'FLAIR_4=' strrep(fullfile(subj_path_4,'FLAIR_to_T1.nii.gz'),'\','/') '\n'...
                    '\n' ...
                    'T1_brain_1=' strrep(fullfile(subj_path_1,'T1_brain.nii.gz'),'\','/') '\n'...
                    'T1_brain_2=' strrep(fullfile(subj_path_2,'T1_brain.nii.gz'),'\','/') '\n'...
                    'T1_brain_3=' strrep(fullfile(subj_path_3,'T1_brain.nii.gz'),'\','/') '\n'...                 
                    'T1_brain_4=' strrep(fullfile(subj_path_4,'T1_brain.nii.gz'),'\','/') '\n'...                 
                    '\n' ...
                    'T2_brain_1=' strrep(fullfile(subj_path_1,'T2_to_T1_brain.nii.gz'),'\','/') '\n'...
                    'T2_brain_2=' strrep(fullfile(subj_path_2,'T2_to_T1_brain.nii.gz'),'\','/') '\n'...
                    'T2_brain_3=' strrep(fullfile(subj_path_3,'T2_to_T1_brain.nii.gz'),'\','/') '\n'...                 
                    'T2_brain_4=' strrep(fullfile(subj_path_4,'T2_to_T1_brain.nii.gz'),'\','/') '\n'...                 
                    '\n' ...
                    'FLAIR_brain_1=' strrep(fullfile(subj_path_1,'FLAIR_to_T1_brain.nii.gz'),'\','/') '\n'...
                    'FLAIR_brain_2=' strrep(fullfile(subj_path_2,'FLAIR_to_T1_brain.nii.gz'),'\','/') '\n'...
                    'FLAIR_brain_3=' strrep(fullfile(subj_path_3,'FLAIR_to_T1_brain.nii.gz'),'\','/') '\n'...
                    'FLAIR_brain_4=' strrep(fullfile(subj_path_4,'FLAIR_to_T1_brain.nii.gz'),'\','/') '\n'...
                    '\n' ...
                    'lesion_mask_1=' strrep(fullfile(subj_path_1,'baseline_2ch','baseline_2ch_prob_1.nii.gz'),'\','/') '\n'...
                    'lesion_mask_2=' strrep(fullfile(subj_path_2,'baseline_2ch','baseline_2ch_prob_1.nii.gz'),'\','/') '\n'...
                    'lesion_mask_3=' strrep(fullfile(subj_path_3,'baseline_2ch','baseline_2ch_prob_1.nii.gz'),'\','/') '\n'...
                    'lesion_mask_4=' strrep(fullfile(subj_path_4,'baseline_2ch','baseline_2ch_prob_1.nii.gz'),'\','/') '\n'...
                    'output=' strrep(fullfile(output_path,subjID,[date1 '_' date4]),'\','/') '\n'...
                    'registration_longitudinal_FLAIR $T1_1 $T1_2 $T1_3 $T1_4 $FLAIR_1 $FLAIR_2 $FLAIR_3 $FLAIR_4 $output -t1_brain_1 $T1_brain_1 -t1_brain_2 $T1_brain_2 -t1_brain_3 $T1_brain_3 -t1_brain_4 $T1_brain_4 -flair_brain_1 $FLAIR_brain_1 -flair_brain_2 $FLAIR_brain_2 -flair_brain_3 $FLAIR_brain_3 -flair_brain_4 $FLAIR_brain_4 -lesion_1 $lesion_mask_1 -lesion_2 $lesion_mask_2 -lesion_3 $lesion_mask_3 -lesion_4 $lesion_mask_4' ]);
                    % ... 'registration_longitudinal_T2 $T1_1 $T1_2 $T1_3 $T1_4 $T2_1 $T2_2 $T2_3 $T2_4 $output -t1_brain_1 $T1_brain_1 -t1_brain_2 $T1_brain_2 -t1_brain_3 $T1_brain_3 -t1_brain_4 $T1_brain_4 -t2_brain_1 $T2_brain_1 -t2_brain_2 $T2_brain_2 -t2_brain_3 $T2_brain_3 -t2_brain_4 $T2_brain_4 -lesion_1 $lesion_mask_1 -lesion_2 $lesion_mask_2 -lesion_3 $lesion_mask_3 -lesion_4 $lesion_mask_4' ]);
                    
                
               fclose(ID_file);
                
               fprintf(ID_file_recap,['sbatch ' strrep(fullfile(jobdir, jobName),'\','/') '\n']);
end
            
              

fclose(ID_file_recap);


