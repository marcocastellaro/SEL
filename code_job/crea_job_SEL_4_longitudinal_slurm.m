clear all 
close all
clc

% Gestione deelle differenti piattaforme da cui si chiama il codice

base_directory = '/nfsd/biopetmri/BACKUP/Users/Marco/3T_Verona/SEL_candidates';
% ALTERNATIVA PC LOCALE 
%base_directory = 'F:\Utente\TESI\';

data_path=fullfile(base_directory,'data_longitudinal');
output_path=fullfile(base_directory,'output_longitudinal');

% elenco soggetti
list_output=dir(output_path);
list_data=dir(data_path);

jobdir=fullfile(base_directory,'code','Jobs');
if not(exist(jobdir,'dir'))
    mkdir(jobdir)
end
filename_qsub=fullfile(base_directory,'code','Jobs',['SEL_sbatch_4_longitudinal_slurm_' datestr(now,30) '.txt']);
ID_file_recap=fopen(filename_qsub,'w');

jobdir=fullfile(base_directory,'code','Jobs','Exex_slurm_longitudinal_SEL');
if not(exist(jobdir,'dir'))
    mkdir(jobdir)
end
fprintf(ID_file_recap,['cd ' strrep(jobdir,'\','/') ' \n']);


diff_1 = zeros(1,(length(list_output)-3));
t = 2;

for d=3:4:length(list_data)
subjID_data_1 = list_data(d).name;
subjID_data_2 = list_data(d+1).name;
subjID_data_3 = list_data(d+2).name;
subjID_data_4 = list_data(d+3).name;


    subj_path_data_1=fullfile(data_path, subjID_data_1);
    subj_path_data_2=fullfile(data_path, subjID_data_2);
    subj_path_data_3=fullfile(data_path, subjID_data_3);
    subj_path_data_4=fullfile(data_path, subjID_data_4);

    
    subj_data_list_1=dir(subj_path_data_1);
    subj_data_list_2=dir(subj_path_data_2);
    subj_data_list_3=dir(subj_path_data_3);
    subj_data_list_2=dir(subj_path_data_4);

        I = subj_data_list_1(3).name;
        FormatIn = 'yyyymmdd';
        I_day = datenum(I,FormatIn);
    
        II = subj_data_list_2(3).name;
        FormatIn = 'yyyymmdd';
        II_day = datenum(II,FormatIn);
        
        II = subj_data_list_2(3).name;
        FormatIn = 'yyyymmdd';
        II_day = datenum(II,FormatIn);
        
        III = subj_data_list_3(3).name;
        FormatIn = 'yyyymmdd';
        III_day = datenum(III,FormatIn);
        
        IV = subj_data_list_4(3).name;
        FormatIn = 'yyyymmdd';
        IV_day = datenum(IV,FormatIn);
        
        diff_1 = (II_day-I_day)/365.4252;
        years_1 = num2str(diff_1);

        diff_2 = (III_day-II_day)/365.4252;
        years_2 = num2str(diff_2);
        
        diff_3 = (IV_day-III_day)/365.4252;
        years_3 = num2str(diff_3);
        
        t = t+1;
        
        subjID_output = list_output(t).name;
        subj_path_output=fullfile(output_path, subjID_output);
        subj_output_list=dir(subj_path_output);
        
                jobMatlabName=['M_SEL_JD_' num2str(str2double(subjID_output)) '.m'];
                 
                ID_file=fopen(fullfile(jobdir, jobMatlabName),'wt');
                
                fprintf(ID_file,['addpath(''/nfsd/biopetmri/BACKUP/Users/Marco/3T_Verona/SEL_candidates/code/NIFTI_toolbox/'')\n'...
                                'addpath(''/nfsd/biopetmri/BACKUP/Users/Marco/3T_Verona/SEL_candidates/SEL/code_matlab/registration_longitudinal'')\n'...
                    'nak_detJ_1 = load_untouch_nii(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','FLAIR_T1','Jacobian','nak_detJ_1.nii.gz'),'\','/') ''')' ';' '\n'...
                    'lesions_prob_base_halfway = load_untouch_nii(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','FLAIR_T1','Jacobian','lesion_mask_1_halfway_ANTs.nii.gz'),'\','/') ''')' ';' '\n'...
                    'lesions_prob_foll_halfway = load_untouch_nii(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','FLAIR_T1','Jacobian','lesion_mask_2_halfway_ANTs.nii.gz'),'\','/') ''')' ';' '\n'...
                    'nak_detJ_1_img = nak_detJ_1.img;' '\n'...
                    'lesions_mask_base_img = lesions_prob_base_halfway.img > 0.5;' '\n'...                   
                    'lesions_mask_foll_img = lesions_prob_foll_halfway.img > 0.5;' '\n'...
                    'years_1 = ' years_1 ';' '\n'...
                    '\n'...
                    '\n'...
                    '[SEL_' num2str(str2double(subjID_output)) ',' 'CC_SEL_' num2str(str2double(subjID_output)) '] = sel_candidates(nak_detJ_1_img,lesions_mask_base_img,lesions_mask_foll_img,years_1);' '\n'...
                    'nifti_SEL_' num2str(str2double(subjID_output)) ' = lesions_prob_base_halfway;' '\n'...
                    'nifti_SEL_' num2str(str2double(subjID_output)) '.img = SEL_' num2str(str2double(subjID_output)) ';' '\n'...
                    'save_untouch_nii(nifti_SEL_' num2str(str2double(subjID_output)) ',''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','FLAIR_T1','Jacobian','SEL_1.nii.gz'),'\','/') ''')' ';' '\n'...
                    'num_CC_SEL_1 = CC_SEL_' num2str(str2double(subjID_output)) '.NumObjects;' '\n' ...
                    'save(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','FLAIR_T1','Jacobian','num_CC_SEL_1'),'\','/') ''', ''num_CC_SEL_1'');' '\n' ...
                    'voxel_SEL_1 = [];' '\n' ...
                    'for i=1:num_CC_SEL_1' '\n' ...
                    '    ind = size(CC_SEL_' num2str(str2double(subjID_output)) '.PixelIdxList{1,i});' '\n' ...
                    '    voxel_SEL_1(i) = ind(1);' '\n' ...
                    'end' '\n' ...
                    '\n' ...
                    'volume_1 = sum(voxel_SEL_1);' '\n' ...
                    'save(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','FLAIR_T1','Jacobian','volume_1'),'\','/') ''', ''volume_1'');' '\n' ...
                    '\n'...
                    'nak_detJ_2 = load_untouch_nii(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','FLAIR_T1','Jacobian','nak_detJ_2_to_1.nii.gz'),'\','/') ''')' ';' '\n'...
                    'lesions_prob_base_halfway = load_untouch_nii(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','FLAIR_T1','Jacobian','lesion_mask_2_halfway_ANTs.nii.gz'),'\','/') ''')' ';' '\n'...
                    'lesions_prob_foll_halfway = load_untouch_nii(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','FLAIR_T1','Jacobian','lesion_mask_3_halfway_ANTs.nii.gz'),'\','/') ''')' ';' '\n'...
                    'nak_detJ_2_img = nak_detJ_2.img;' '\n'...
                    'lesions_mask_base_img = lesions_prob_base_halfway.img > 0.5;' '\n'...                   
                    'lesions_mask_foll_img = lesions_prob_foll_halfway.img > 0.5;' '\n'...
                    'years_2 = ' years_2 ';' '\n'...
                    '\n'...
                    '\n'...
                    '[SEL_' num2str(str2double(subjID_output)) ',' 'CC_SEL_' num2str(str2double(subjID_output)) '] = sel_candidates(nak_detJ_2_img,lesions_mask_base_img,lesions_mask_foll_img,years_2);' '\n'...
                    'nifti_SEL_' num2str(str2double(subjID_output)) ' = lesions_prob_base_halfway;' '\n'...
                    'nifti_SEL_' num2str(str2double(subjID_output)) '.img = SEL_' num2str(str2double(subjID_output)) ';' '\n'...
                    'save_untouch_nii(nifti_SEL_' num2str(str2double(subjID_output)) ',''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','FLAIR_T1','Jacobian','SEL_2.nii.gz'),'\','/') ''')' ';' '\n'...
                    'num_CC_SEL_2 = CC_SEL_' num2str(str2double(subjID_output)) '.NumObjects;' '\n' ...
                    'save(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','FLAIR_T1','Jacobian','num_CC_SEL_2'),'\','/') ''', ''num_CC_SEL_2'');' '\n' ...
                    'voxel_SEL_2 = [];' '\n' ...
                    'for i=1:num_CC_SEL_2' '\n' ...
                    '    ind = size(CC_SEL_' num2str(str2double(subjID_output)) '.PixelIdxList{1,i});' '\n' ...
                    '    voxel_SEL_2(i) = ind(1);' '\n' ...
                    'end' '\n' ...
                    '\n' ...
                    'volume_2 = sum(voxel_SEL_2);' '\n' ...
                    'save(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','FLAIR_T1','Jacobian','volume_2'),'\','/') ''', ''volume_2'');' '\n' ...
                    '\n' ...
                    'nak_detJ_3 = load_untouch_nii(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','FLAIR_T1','Jacobian','nak_detJ_3_to_1.nii.gz'),'\','/') ''')' ';' '\n'...
                    'lesions_prob_base_halfway = load_untouch_nii(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','FLAIR_T1','Jacobian','lesion_mask_3_halfway_ANTs.nii.gz'),'\','/') ''')' ';' '\n'...
                    'lesions_prob_foll_halfway = load_untouch_nii(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','FLAIR_T1','Jacobian','lesion_mask_4_halfway_ANTs.nii.gz'),'\','/') ''')' ';' '\n'...
                    'nak_detJ_3_img = nak_detJ_3.img;' '\n'...
                    'lesions_mask_base_img = lesions_prob_base_halfway.img > 0.5;' '\n'...                   
                    'lesions_mask_foll_img = lesions_prob_foll_halfway.img > 0.5;' '\n'...
                    'years_3 = ' years_3 ';' '\n'...
                    '\n'...
                    '\n'...
                    '[SEL_' num2str(str2double(subjID_output)) ',' 'CC_SEL_' num2str(str2double(subjID_output)) '] = sel_candidates(nak_detJ_3_img,lesions_mask_base_img,lesions_mask_foll_img,years_3);' '\n'...
                    'nifti_SEL_' num2str(str2double(subjID_output)) ' = lesions_prob_base_halfway;' '\n'...
                    'nifti_SEL_' num2str(str2double(subjID_output)) '.img = SEL_' num2str(str2double(subjID_output)) ';' '\n'...
                    'save_untouch_nii(nifti_SEL_' num2str(str2double(subjID_output)) ',''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','FLAIR_T1','Jacobian','SEL_3.nii.gz'),'\','/') ''')' ';' '\n'...
                    'num_CC_SEL_3 = CC_SEL_' num2str(str2double(subjID_output)) '.NumObjects;' '\n' ...
                    'save(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','FLAIR_T1','Jacobian','num_CC_SEL_3'),'\','/') ''', ''num_CC_SEL_3'');' '\n' ...
                    'voxel_SEL_3 = [];' '\n' ...
                    'for i=1:num_CC_SEL_3' '\n' ...
                    '    ind = size(CC_SEL_' num2str(str2double(subjID_output)) '.PixelIdxList{1,i});' '\n' ...
                    '    voxel_SEL_3(i) = ind(1);' '\n' ...
                    'end' '\n' ...
                    '\n' ...
                    'volume_3 = sum(voxel_SEL_3);' '\n' ...
                    'save(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','FLAIR_T1','Jacobian','volume_3'),'\','/') ''', ''volume_3'');' '\n' ...
                    '\n' ...
                    'nak_detJ_1 = load_untouch_nii(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','nak_detJ_1.nii.gz'),'\','/') ''')' ';' '\n'...
                    'lesions_prob_base_halfway = load_untouch_nii(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','lesion_mask_1_halfway_ANTs.nii.gz'),'\','/') ''')' ';' '\n'...
                    'lesions_prob_foll_halfway = load_untouch_nii(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','lesion_mask_2_halfway_ANTs.nii.gz'),'\','/') ''')' ';' '\n'...
                    'nak_detJ_1_img = nak_detJ_1.img;' '\n'...
                    'lesions_mask_base_img = lesions_prob_base_halfway.img > 0.5;' '\n'...                   
                    'lesions_mask_foll_img = lesions_prob_foll_halfway.img > 0.5;' '\n'...
                    'years_1 = ' years_1 ';' '\n'...
                    '\n'...
                    '\n'...
                    '[SEL_' num2str(str2double(subjID_output)) ',' 'CC_SEL_' num2str(str2double(subjID_output)) '] = sel_candidates(nak_detJ_1_img,lesions_mask_base_img,lesions_mask_foll_img,years_1);' '\n'...
                    'nifti_SEL_' num2str(str2double(subjID_output)) ' = lesions_prob_base_halfway;' '\n'...
                    'nifti_SEL_' num2str(str2double(subjID_output)) '.img = SEL_' num2str(str2double(subjID_output)) ';' '\n'...
                    'save_untouch_nii(nifti_SEL_' num2str(str2double(subjID_output)) ',''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','SEL_1.nii.gz'),'\','/') ''')' ';' '\n'...
                    'num_CC_SEL_1 = CC_SEL_' num2str(str2double(subjID_output)) '.NumObjects;' '\n' ...
                    'save(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','num_CC_SEL_1'),'\','/') ''', ''num_CC_SEL_1'');' '\n' ...
                    'voxel_SEL_1 = [];' '\n' ...
                    'for i=1:num_CC_SEL_1' '\n' ...
                    '    ind = size(CC_SEL_' num2str(str2double(subjID_output)) '.PixelIdxList{1,i});' '\n' ...
                    '    voxel_SEL_1(i) = ind(1);' '\n' ...
                    'end' '\n' ...
                    '\n' ...
                    'volume_1 = sum(voxel_SEL_1);' '\n' ...
                    'save(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','volume_1'),'\','/') ''', ''volume_1'');' '\n' ...
                    '\n' ...
                    'nak_detJ_2 = load_untouch_nii(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','nak_detJ_2_to_1.nii.gz'),'\','/') ''')' ';' '\n'...
                    'lesions_prob_base_halfway = load_untouch_nii(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','lesion_mask_2_halfway_ANTs.nii.gz'),'\','/') ''')' ';' '\n'...
                    'lesions_prob_foll_halfway = load_untouch_nii(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','lesion_mask_3_halfway_ANTs.nii.gz'),'\','/') ''')' ';' '\n'...
                    'nak_detJ_2_img = nak_detJ_2.img;' '\n'...
                    'lesions_mask_base_img = lesions_prob_base_halfway.img > 0.5;' '\n'...                   
                    'lesions_mask_foll_img = lesions_prob_foll_halfway.img > 0.5;' '\n'...
                    'years_2 = ' years_2 ';' '\n'...
                    '\n'...
                    '\n'...
                    '[SEL_' num2str(str2double(subjID_output)) ',' 'CC_SEL_' num2str(str2double(subjID_output)) '] = sel_candidates(nak_detJ_2_img,lesions_mask_base_img,lesions_mask_foll_img,years_2);' '\n'...
                    'nifti_SEL_' num2str(str2double(subjID_output)) ' = lesions_prob_base_halfway;' '\n'...
                    'nifti_SEL_' num2str(str2double(subjID_output)) '.img = SEL_' num2str(str2double(subjID_output)) ';' '\n'...
                    'save_untouch_nii(nifti_SEL_' num2str(str2double(subjID_output)) ',''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','SEL_2.nii.gz'),'\','/') ''')' ';' '\n'...
                    'num_CC_SEL_2 = CC_SEL_' num2str(str2double(subjID_output)) '.NumObjects;' '\n' ...
                    'save(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','num_CC_SEL_2'),'\','/') ''', ''num_CC_SEL_2'');' '\n' ...
                    'voxel_SEL_2 = [];' '\n' ...
                    'for i=1:num_CC_SEL_2' '\n' ...
                    '    ind = size(CC_SEL_' num2str(str2double(subjID_output)) '.PixelIdxList{1,i});' '\n' ...
                    '    voxel_SEL_2(i) = ind(1);' '\n' ...
                    'end' '\n' ...
                    '\n' ...
                    'volume_2 = sum(voxel_SEL_2);' '\n' ...
                    'save(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','volume_2'),'\','/') ''', ''volume_2'');' '\n' ...
                    '\n' ...
                    'nak_detJ_3 = load_untouch_nii(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','nak_detJ_3_to_1.nii.gz'),'\','/') ''')' ';' '\n'...
                    'lesions_prob_base_halfway = load_untouch_nii(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','lesion_mask_3_halfway_ANTs.nii.gz'),'\','/') ''')' ';' '\n'...
                    'lesions_prob_foll_halfway = load_untouch_nii(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','lesion_mask_4_halfway_ANTs.nii.gz'),'\','/') ''')' ';' '\n'...
                    'nak_detJ_3_img = nak_detJ_3.img;' '\n'...
                    'lesions_mask_base_img = lesions_prob_base_halfway.img > 0.5;' '\n'...                   
                    'lesions_mask_foll_img = lesions_prob_foll_halfway.img > 0.5;' '\n'...
                    'years_3 = ' years_3 ';' '\n'...
                    '\n'...
                    '\n'...
                    '[SEL_' num2str(str2double(subjID_output)) ',' 'CC_SEL_' num2str(str2double(subjID_output)) '] = sel_candidates(nak_detJ_3_img,lesions_mask_base_img,lesions_mask_foll_img,years_3);' '\n'...
                    'nifti_SEL_' num2str(str2double(subjID_output)) ' = lesions_prob_base_halfway;' '\n'...
                    'nifti_SEL_' num2str(str2double(subjID_output)) '.img = SEL_' num2str(str2double(subjID_output)) ';' '\n'...
                    'save_untouch_nii(nifti_SEL_' num2str(str2double(subjID_output)) ',''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','SEL_3.nii.gz'),'\','/') ''')' ';' '\n'...
                    'num_CC_SEL_3 = CC_SEL_' num2str(str2double(subjID_output)) '.NumObjects;' '\n' ...
                    'save(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','num_CC_SEL_3'),'\','/') ''', ''num_CC_SEL_3'');' '\n' ...
                    'voxel_SEL_3 = [];' '\n' ...
                    'for i=1:num_CC_SEL_3' '\n' ...
                    '    ind = size(CC_SEL_' num2str(str2double(subjID_output)) '.PixelIdxList{1,i});' '\n' ...
                    '    voxel_SEL_3(i) = ind(1);' '\n' ...
                    'end' '\n' ...
                    '\n' ...
                    'volume_3 = sum(voxel_SEL_3);' '\n' ...
                    'save(''' strrep(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','volume_3'),'\','/') ''', ''volume_3'');' ]);
                    
                fclose(ID_file);
                
                jobName=['JD_' num2str(str2double(subjID_output)) '.job'];
                 
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
                    '\n' ...
                    'pushd ' strrep(fullfile(jobdir),'\','/') '\n' ...
                    'matlab -nodisplay -nosplash -r "' strrep(jobMatlabName,'.m','')  ';exit" ']);
                
                fclose(ID_file);

                fprintf(ID_file_recap,['sbatch ' strrep(fullfile(jobdir,jobName),'\','/') '\n']);
              
                
       
end


  
  fclose(ID_file_recap)
        