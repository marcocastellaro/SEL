clear all 
close all
clc

% Gestione deelle differenti piattaforme da cui si chiama il codice

base_directory = '/nfsd/biopetmri/BACKUP/Users/Marco/3T_Verona/SEL_candidates';
% ALTERNATIVA PC LOCALE 
%base_directory = 'F:\Utente\TESI\';

jobdir=fullfile(base_directory,'code','Jobs');
if not(exist(jobdir,'dir'))
    mkdir(jobdir)
end
filename_qsub=fullfile(base_directory,'code','Jobs',['Results_' datestr(now,30) '.txt']);
ID_file_recap=fopen(filename_qsub,'w');

jobdir=fullfile(base_directory,'code','Jobs','Results');
if not(exist(jobdir,'dir'))
    mkdir(jobdir)
end
fprintf(ID_file_recap,['cd ' strrep(jobdir,'\','/') ' \n']);

output_path=fullfile(base_directory,'output');
output_summury=fullfile(base_directory,'output_summary');

% elenco soggetti
list_output=dir(output_path);

jobMatlabName=['M_SEL_JD_' num2str(str2double(subjID_output)) '.m'];
                 
ID_file=fopen(fullfile(jobdir, jobMatlabName),'wt');

fprintf(ID_file,['sienapd_FLAIR = zeros(1,' length(list_output) ');\n' ...
'sienapd_T2 = zeros(1,' length(list_output) ');\n' ...
'robust_FLAIR = zeros(1,' length(list_output) ');\n' ...
'robust_T2 = zeros(1,' length(list_output) ');\n' ...
'resampled = zeros(1,' length(list_output) ');\n' ...
'volume_sienapd_FLAIR = zeros(1,' length(list_output) ');\n' ...
'volume_sienapd_T2 = zeros(1,' length(list_output) ');\n' ...
'volume_robust_FLAIR = zeros(1,' length(list_output) ');\n' ...
'volume_robust_T2 = zeros(1,' length(list_output) ');\n' ...
'volume_resampled = zeros(1,' length(list_output) ');\n' ...
'k = 1\n;' ...
'result_sienapd = zeros(4,' length(list_output) ');\n' ...
'result_robust = zeros(4,' length(list_output) ');\n' ...
'result_resampled = zeros(4,' length(list_output) ');\n' ...
'\n' ...
'for t=3:1:' length(list_output) '\n' ...
        '\n' ...
        subjID_output = list_output(t).name;
        subj_path_output=fullfile(output_path, subjID_output);
        subj_output_list=dir(subj_path_output);
        
        % sienapd_FLAIR
        
        CC_SEL_sienapd_FLAIR = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_sienapd','FLAIR_T1','Jacobian','num_CC_SEL_FLAIR.mat'));                 
        volume_SEL_sienapd_FLAIR = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_sienapd','FLAIR_T1','Jacobian','volume.mat'));
        
        sienapd_FLAIR(1,k) = CC_SEL_sienapd_FLAIR.num_CC_SEL_FLAIR;
        volume_sienapd_FLAIR(1,k) = volume_SEL_sienapd_FLAIR.volume;
                
       % sienapd_T2
       
        CC_SEL_sienapd_T2 = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_sienapd','T2_T1','Jacobian','num_CC_SEL_T2.mat'));                 
        volume_SEL_sienapd_T2 = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_sienapd','T2_T1','Jacobian','volume.mat'));                 

        sienapd_T2(1,k) = CC_SEL_sienapd_T2.num_CC_SEL_T2;
        volume_sienapd_T2(1,k) = volume_SEL_sienapd_T2.volume;
 
        % robust_FLAIR
        
        CC_SEL_robust_FLAIR = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_robust_template','FLAIR_T1','Jacobian','num_CC_SEL_FLAIR.mat'));                 
        volume_SEL_robust_FLAIR = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_robust_template','FLAIR_T1','Jacobian','volume.mat'));                 

        
        robust_FLAIR(1,k) = CC_SEL_robust_FLAIR.num_CC_SEL_FLAIR;
        volume_robust_FLAIR(1,k) = volume_SEL_robust_FLAIR.volume;
        
        % robust_T2
        
        CC_SEL_robust_T2 = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_robust_template','T2_T1','Jacobian','num_CC_SEL_T2.mat'));                 
        volume_SEL_robust_T2 = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_robust_template','T2_T1','Jacobian','volume.mat'));                 
       
        robust_T2(1,k) = CC_SEL_robust_T2.num_CC_SEL_T2;
        volume_robust_T2(1,k) = volume_SEL_robust_T2.volume;
        
        % resampled
        CC_SEL = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_robust_template','T2_T1','Jacobian','num_CC_SEL.mat'));                 
        volume_SEL = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_robust_template','T2_T1','Jacobian','volume.mat'));                 
       
        resampled(1,k) = CC_SEL.num_CC_SEL;
        volume_resampled(1,k) = volume_SEL.volume;
         
        k = k+1;  
end

result_sienapd = [sienapd_FLAIR ; volume_sienapd_FLAIR ; sienapd_T2 ; volume_sienapd_T2];
result_robust = [robust_FLAIR ; volume_robust_FLAIR ; robust_T2 ; volume_robust_T2]; 
result_resampled = [robust_FLAIR ; volume_robust_FLAIR ; resampled ; volume_resampled];

save(fullfile(output_summary,'result_sienapd'),'result_sienapd');
save(fullfile(output_summary,'result_robust'),'result_robust');
save(fullfile(output_summary,'result_resampled'),'result_resampled'); ]);
