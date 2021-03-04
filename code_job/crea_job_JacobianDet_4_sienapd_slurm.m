clear all 
close all
clc

% Gestione deelle differenti piattaforme da cui si chiama il codice

base_directory = '/nfsd/biopetmri/BACKUP/Users/Marco/3T_Verona/SEL_candidates/';
% ALTERNATIVA PC LOCALE 
%base_directory = 'F:\Utente\TESI\';

data_path=fullfile(base_directory,'data');
output_path=fullfile(base_directory,'output');

% elenco soggetti
list_data=dir(data_path);
list_output=dir(output_path);

jobdir=fullfile(base_directory,'code','Jobs');
if not(exist(jobdir,'dir'))
    mkdir(jobdir)
end
filename_qsub=fullfile(base_directory,'code','Jobs',['JacDet_sbatch_4_sienapd_slurm_' datestr(now,30) '.txt']);
ID_file_recap=fopen(filename_qsub,'w');

jobdir=fullfile(base_directory,'code','Jobs','Exex_slurm_sienapd');
if not(exist(jobdir,'dir'))
    mkdir(jobdir)
end
fprintf(ID_file_recap,['cd ' strrep(jobdir,'\','/') ' \n']);

d = 2;
for k=3:2:length(list_data)
    d = d + 1;
    subjID_baseline = list_data(k).name;
    subjID_follow = list_data(k+1).name;
    subjID = list_output(d).name;    
    
    subj_path_baseline=fullfile(data_path, subjID_baseline);
    subj_path_follow=fullfile(data_path, subjID_follow);

    subj_data_list_baseline=dir(subj_path_baseline);
    subj_data_list_follow=dir(subj_path_follow);

    baseline = subj_data_list_baseline(3).name;
    followup = subj_data_list_follow(3).name;
   
    
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
                    'export ANTSDIR=/nfsd/biopetmri/BACKUP/Users/Marco/3T_Verona/SEL_candidates/code/ANTs\n'...
                    'export PATH=$PATH:$ANTSDIR\n' ...
                    'export PATH=$PATH:/nfsd/biopetmri/BACKUP/Users/Marco/3T_Verona/SEL_candidates/code\n'...
                    'export PATH=$PATH:/nfsd/biopetmri/BACKUP/Users/Marco/3T_Verona/SEL_candidates/code/c3d\n'...
                    'export PATH=$PATH:/nfsd/biopetmri/BACKUP/Users/Marco/3T_Verona/SEL_candidates/SEL/code_shell\n'...
                    'export PATH=$PATH:/nfsd/biopetmri/BACKUP/Users/Marco/3T_Verona/SEL_candidates/SEL/code_shell/registration_sienapd\n'...
                    '\n'...
                    '\n'...
                    'T1_baseline=' strrep(fullfile(subj_path_baseline,'T1.nii.gz'),'\','/') '\n'...
                    'T1_follow=' strrep(fullfile(subj_path_follow,'T1.nii.gz'),'\','/') '\n'...
                    'T2_baseline=' strrep(fullfile(subj_path_baseline,'T2_to_T1.nii.gz'),'\','/') '\n'...
                    'T2_follow=' strrep(fullfile(subj_path_follow,'T2_to_T1.nii.gz'),'\','/') '\n'...
                    'T2_brain_baseline=' strrep(fullfile(subj_path_baseline,'T2_to_T1_brain.nii.gz'),'\','/') '\n'...
                    'T2_brain_follow=' strrep(fullfile(subj_path_follow,'T2_to_T1_brain.nii.gz'),'\','/') '\n'...                 
                    'FLAIR_brain_baseline=' strrep(fullfile(subj_path_baseline,'FLAIR_to_T1_brain.nii.gz'),'\','/') '\n'...
                    'FLAIR_brain_follow=' strrep(fullfile(subj_path_follow,'FLAIR_to_T1_brain.nii.gz'),'\','/') '\n'...
                    'mask_baseline=' strrep(fullfile(subj_path_baseline,'CT','BrainExtractionMask.nii.gz'),'\','/') '\n'...
                    'mask_follow=' strrep(fullfile(subj_path_follow,'CT','BrainExtractionMask.nii.gz'),'\','/') '\n'...
                    'output=' strrep(fullfile(output_path,subjID,[baseline '_' followup]),'\','/') '\n'...
                    'registration_sienapd  $T1_baseline $T1_follow $FLAIR_brain_baseline $FLAIR_brain_follow $T2_baseline $T2_follow $T2_brain_baseline $T2_brain_follow $output -m1 $mask_baseline -m2 $mask_follow' '\n']);
                    
                
               fclose(ID_file);
                
               fprintf(ID_file_recap,['sbatch ' strrep(fullfile(jobdir, jobName),'\','/') '\n']);
end
            
              

fclose(ID_file_recap);
