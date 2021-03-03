clear all 
close all
clc

% Gestione deelle differenti piattaforme da cui si chiama il codice

%base_directory = '/nfsd/biopetmri/BACKUP/Users/Marco/3T_Verona/SEL_candidates';
% ALTERNATIVA PC LOCALE 
base_directory = 'F:\Utente\TESI\';

data_path=fullfile(base_directory,'dati');
output_path=fullfile(base_directory,'output');

% elenco soggetti
list_output=dir(output_path);
list_data=dir(data_path);

jobdir=fullfile(base_directory,'code','Jobs');
if not(exist(jobdir,'dir'))
    mkdir(jobdir)
end
filename_qsub=fullfile(base_directory,'code','Jobs',['SEL_sbatch_4_resampled_slurm_' datestr(now,30) '.txt']);
ID_file_recap=fopen(filename_qsub,'w');

jobdir=fullfile(base_directory,'code','Jobs','Exex_slurm_resampled_SEL');
if not(exist(jobdir,'dir'))
    mkdir(jobdir)
end
fprintf(ID_file_recap,['cd ' strrep(jobdir,'\','/') ' \n']);


diff = zeros(1,(length(list_output)-3));
t = 2;

for d=3:2:length(list_data)
subjID_data_baseline = list_data(d).name;
subjID_data_follow = list_data(d+1).name;


    subj_path_data_baseline=fullfile(data_path, subjID_data_baseline);
    subj_path_data_follow=fullfile(data_path, subjID_data_follow);

    
    subj_data_list_baseline=dir(subj_path_data_baseline);
    subj_data_list_follow=dir(subj_path_data_follow);
    
        baseline = subj_data_list_baseline(3).name;
        FormatIn = 'yyyymmdd';
        baseline_day = datenum(baseline,FormatIn);
    
        followup = subj_data_list_follow(3).name;
        FormatIn = 'yyyymmdd';
        followup_day = datenum(followup,FormatIn);
        
        diff = (followup_day-baseline_day)/365.4252;
        years = num2str(diff);

        t = t+1;
        
        subjID_output = list_output(t).name;
        subj_path_output=fullfile(output_path, subjID_output);
        subj_output_list=dir(subj_path_output);
        
   
                jobName=['JD_' num2str(str2double(subjID_output)) '.job'];
                 
                ID_file=fopen(fullfile(jobdir, jobName),'wt');
                
                fprintf(ID_file,[%'addpath /nfsd/biopetmri/BACKUP/Users/Marco/3T_Verona/SEL_candidates/software/NIfTI_20140122/'
                    %'addpath /nfsd/biopetmri/BACKUP/Users/Marco/3T_Verona/SEL_candidates/SEL/code_matlab/registration_robust_template'
                    'nak_detJ_FLAIR = load_untouch_nii(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_resampled','Jacobian','nak_detJ.nii.gz'),'\','/') ''')' ';' '\n'...
                    'lesions_prob_base_halfway = load_untouch_nii(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_resampled','Jacobian','lesion_prob_base_halfway_ANTs.nii.gz'),'\','/') ''')' ';' '\n'...
                    'lesions_prob_foll_halfway = load_untouch_nii(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_resampled','Jacobian','lesion_prob_foll_halfway_ANTs.nii.gz'),'\','/') ''')' ';' '\n'...
                    'nak_detJ = nak_detJ_FLAIR.img;' '\n'...
                    'lesions_mask_base_img = lesions_prob_base_halfway.img > 0.5;' '\n'...                   
                    'lesions_mask_foll_img = lesions_prob_foll_halfway.img > 0.5;' '\n'...
                    'years = ' years ';' '\n'...
                    '\n'...
                    '\n'...
                    '[SEL_' num2str(str2double(subjID_output)) ',' 'CC_SEL_' num2str(str2double(subjID_output)) '] = sel_candidates(nak_detJ,lesions_mask_base_img,lesions_mask_foll_img,years);' '\n'...
                    'nifti_SEL_' num2str(str2double(subjID_output)) ' = lesions_prob_base_halfway;' '\n'...
                    'nifti_SEL_' num2str(str2double(subjID_output)) '.img = SEL_' num2str(str2double(subjID_output)) ';' '\n'...
                    'save_untouch_nii(nifti_SEL_' num2str(str2double(subjID_output)) ',''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_resampled','Jacobian','SEL.nii'),'\','/') ''')' ';' '\n'...
                    '\n'...
                    '\n'...
                    'copyfile(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_robust_template','FLAIR_T1','Jacobian','SEL.nii'),'\','/') ',''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_resampled','Jacobian','SEL_robust_template.nii'),'\','/') ''')' ';' '\n'...
                    'copyfile(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_robust_template','FLAIR_T1','Jacobian','nak_detJ_FLAIR.nii'),'\','/') ',''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_resampled','Jacobian','nak_detJ_robust_template.nii'),'\','/') ''')' ';' '\n' ]);
   
                    
                fclose(ID_file);
                
                fprintf(ID_file_recap,['sbatch' strrep(fullfile(jobdir,jobName),'\','/') '\n']);
                
       
end


  
  fclose(ID_file_recap)
        