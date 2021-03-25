clear all 
close all
clc

% Gestione deelle differenti piattaforme da cui si chiama il codice

%base_directory = '/nfsd/biopetmri/BACKUP/Users/Marco/3T_Verona/SEL_candidates';
% ALTERNATIVA PC LOCALE 
base_directory = 'F:\Utente\TESI\';

output_path=fullfile(base_directory,'output');

% elenco soggetti
list_output=dir(output_path);

sienapd_FLAIR = zeros(1,length(list_output));
sienapd_T2 = zeros(1,length(list_output));
robust_FLAIR = zeros(1,length(list_output));
robust_T2 = zeros(1,length(list_output));


k = 1;

%% Prima prova
result_sienapd = zeros(2,length(list_output));
result_robust = zeros(2,length(list_output));

for t=3:1:length(list_output)
    
        subjID_output = list_output(t).name;
        subj_path_output=fullfile(output_path, subjID_output);
        subj_output_list=dir(subj_path_output);
        
        % sienapd_FLAIR
        
        SEL_sienapd_FLAIR = load_untouch_nii(fullfile(subj_path_output,subj_output_list(3).name,'registration_sienapd','FLAIR_T1','Jacobian','SEL.nii.gz'));                 
        SEL_sienapd_FLAIR_img = SEL_sienapd_FLAIR.img;
        CC_SEL_sienapd_FLAIR = bwconncomp(SEL_sienapd_FLAIR_img,18);
        CC_SEL_sienapd_FLAIR = CC_SEL_sienapd_FLAIR.NumObjects;
        sienapd_FLAIR(1,k) = CC_SEL_sienapd_FLAIR;
        
        save(fullfile(subj_path_output,subj_output_list(3).name,'registration_sienapd','FLAIR_T1','Jacobian','num_CC_SEL_sienapd_FLAIR'),'num_CC_SEL_sienapd_FLAIR');
        
       % sienapd_T2
       
        SEL_sienapd_T2 = load_untouch_nii(fullfile(subj_path_output,subj_output_list(3).name,'registration_sienapd','T2_T1','Jacobian','SEL.nii.gz'));                 
        SEL_sienapd_T2_img = SEL_sienapd_T2.img;
        CC_SEL_sienapd_T2 = bwconncomp(SEL_sienapd_T2_img,18);
        num_CC_SEL_sienapd_T2 = CC_SEL_sienapd_T2.NumObjects;
        sienapd_T2(1,k) = num_CC_SEL_sienapd_T2;
        
        save(fullfile(subj_path_output,subj_output_list(3).name,'registration_sienapd','T2_T1','Jacobian','num_CC_SEL_sienapd_T2'),'num_CC_SEL_sienapd_T2');
        
        % robust_FLAIR
        
        SEL_robust_FLAIR = load_untouch_nii(fullfile(subj_path_output,subj_output_list(3).name,'registration_robust_template','FLAIR_T1','Jacobian','SEL.nii.gz'));                 
        SEL_robust_FLAIR_img = SEL_robust_FLAIR.img;
        CC_SEL_robust_FLAIR = bwconncomp(SEL_sienapd_FLAIR_img,18);
        num_CC_SEL_robust_FLAIR = CC_SEL_robust_FLAIR.NumObjects;
        robust_FLAIR(1,k) = num_CC_SEL_robust_FLAIR;
        
        save(fullfile(subj_path_output,subj_output_list(3).name,'registration_robust_template','FLAIR_T1','Jacobian','num_CC_SEL_robust_FLAIR'),'num_CC_SEL_robust_FLAIR');

        % robust_T2
        
        SEL_robust_T2 = load_untouch_nii(fullfile(subj_path_output,subj_output_list(3).name,'registration_robust_template','T2_T1','Jacobian','SEL.nii.gz'));                 
        SEL_robust_T2_img = SEL_robust_T2.img;
        CC_SEL_robust_T2 = bwconncomp(SEL_robust_T2_img,18);
        num_CC_SEL_robust_T2 = CC_SEL_robust_T2.NumObjects;
        robust_T2(1,k) = num_CC_SEL_robust_T2;
        
        save(fullfile(subj_path_output,subj_output_list(3).name,'registration_robust_template','T2_T1','Jacobian','num_CC_SEL_robust_T2'),'num_CC_SEL_robust_T2');
        
        k = k+1;  
end

result_sienapd = [sienapd_FLAIR ; sienapd_T2];
result_robust = [robust_FLAIR ; robust_T2]; 

%% Provo a fare lo stesso caricando i file .mat che contengono il numero di SEL identificate
result_sienapd_prova = zeros(2,length(list_output));
result_robust_prova = zeros(2,length(list_output));
result_resampled_prova = zeros(2,length(list_output));

for t=3:1:length(list_output)
    
        subjID_output = list_output(t).name;
        subj_path_output=fullfile(output_path, subjID_output);
        subj_output_list=dir(subj_path_output);
        
        % sienapd_FLAIR
        
        CC_SEL_sienapd_FLAIR = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_sienapd','FLAIR_T1','Jacobian','num_CC_SEL_FLAIR.mat'));                 
        
        sienapd_FLAIR(1,k) = CC_SEL_sienapd_FLAIR.num_CC_SEL_FLAIR;
                
       % sienapd_T2
       
        CC_SEL_sienapd_T2 = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_sienapd','T2_T1','Jacobian','num_CC_SEL_T2.mat'));                 
        
        sienapd_T2(1,k) = CC_SEL_sienapd_T2.num_CC_SEL_T2;
                
        % robust_FLAIR
        
        CC_SEL_robust_FLAIR = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_robust_template','FLAIR_T1','Jacobian','num_CC_SEL_FLAIR.mat'));                 
        
        robust_FLAIR(1,k) = CC_SEL_robust_FLAIR.num_CC_SEL_FLAIR;
        
        % robust_T2
        
        CC_SEL_robust_T2 = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_robust_template','T2_T1','Jacobian','num_CC_SEL_T2.mat'));                 
       
        robust_T2(1,k) = CC_SEL_robust_T2.num_CC_SEL_T2;
              
        % resampled
        CC_SEL = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_robust_template','T2_T1','Jacobian','num_CC_SEL.mat'));                 
       
        resampled(1,k) = CC_SEL.num_CC_SEL;
         
        k = k+1;  
end

result_sienapd_prova = [sienapd_FLAIR ; sienapd_T2];
result_robust_prova = [robust_FLAIR ; robust_T2]; 
result_resampled_prova = [robust_FLAIR ; resampled];