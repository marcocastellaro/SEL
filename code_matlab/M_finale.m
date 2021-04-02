clear all
close all
clc

base_directory = '/nfsd/biopetmri/BACKUP/Users/Marco/3T_Verona/SEL_candidates';

output_path=fullfile(base_directory,'output');

output_summury=fullfile(base_directory,'output_summary');

list_output=dir(output_path);
dim=length(list_output)-2;

sienapd_FLAIR = zeros(1,dim);
sienapd_T2 = zeros(1,dim);
robust_FLAIR = zeros(1,dim);
robust_T2 = zeros(1,dim);
resampled_FLAIR = zeros(1,dim);
resampled_T2 = zeros(1,dim);

volume_sienapd_FLAIR = zeros(1,dim);
volume_sienapd_T2 = zeros(1,dim);
volume_robust_FLAIR = zeros(1,dim);
volume_robust_T2 = zeros(1,dim);
volume_resampled_FLAIR = zeros(1,dim);
volume_resampled_T2 = zeros(1,dim);

k = 1;

result_sienapd = zeros(4,dim);
result_robust = zeros(4,dim);
result_resampled_FLAIR = zeros(4,dim);
result_resampled_T2 = zeros(4,dim);


for t=3:1:length(list_output)

subjID_output = list_output(t).name;
subj_path_output= fullfile(output_path, subjID_output);
subj_output_list=dir(subj_path_output);

try
CC_SEL_sienapd_FLAIR = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_sienapd','FLAIR_T1','Jacobian','num_CC_SEL_FLAIR.mat'));
volume_SEL_sienapd_FLAIR = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_sienapd','FLAIR_T1','Jacobian','volume.mat'));
catch
    CC_SEL_sienapd_FLAIR.num_CC_SEL_FLAIR = NaN;
    volume_SEL_sienapd_FLAIR.volume = NaN;
end
sienapd_FLAIR(1,k) = CC_SEL_sienapd_FLAIR.num_CC_SEL_FLAIR;
volume_sienapd_FLAIR(1,k) = volume_SEL_sienapd_FLAIR.volume;

try
CC_SEL_sienapd_T2 = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_sienapd','T2_T1','Jacobian','num_CC_SEL_T2.mat'));
volume_SEL_sienapd_T2 = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_sienapd','T2_T1','Jacobian','volume.mat'));
catch
    CC_SEL_sienapd_T2.num_CC_SEL_T2 = NaN;
    volume_SEL_sienapd_T2.volume = NaN;
end
sienapd_T2(1,k) = CC_SEL_sienapd_T2.num_CC_SEL_T2;
volume_sienapd_T2(1,k) = volume_SEL_sienapd_T2.volume;

try
    
CC_SEL_robust_FLAIR = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_robust_template','FLAIR_T1','Jacobian','num_CC_SEL_FLAIR.mat'));
volume_SEL_robust_FLAIR = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_robust_template','FLAIR_T1','Jacobian','volume.mat'));
catch
    CC_SEL_robust_FLAIR.num_CC_SEL_FLAIR = NaN;
    volume_SEL_robust_FLAIR.volume = NaN;
end

robust_FLAIR(1,k) = CC_SEL_robust_FLAIR.num_CC_SEL_FLAIR;
volume_robust_FLAIR(1,k) = volume_SEL_robust_FLAIR.volume;

try
CC_SEL_robust_T2 = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_robust_template','T2_T1','Jacobian','num_CC_SEL_T2.mat'));
volume_SEL_robust_T2 = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_robust_template','T2_T1','Jacobian','volume.mat'));
catch

    CC_SEL_robust_T2.num_CC_SEL_T2 = NaN;
    volume_SEL_robust_T2.volume = NaN;
end

robust_T2(1,k) = CC_SEL_robust_T2.num_CC_SEL_T2;
volume_robust_T2(1,k) = volume_SEL_robust_T2.volume;

try
CC_SEL_resampled_FLAIR = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_resampled','FLAIR_T1','Jacobian','num_CC_SEL_FLAIR.mat'));
volume_SEL_resampled_FLAIR = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_resampled','FLAIR_T1','Jacobian','volume.mat'));
catch
    CC_SEL_resampled_FLAIR.num_CC_SEL_FLAIR = NaN;
    volume_SEL_resampled_FLAIR.volume = NaN;    
end
resampled_FLAIR(1,k) = CC_SEL_resampled_FLAIR.num_CC_SEL_FLAIR;
volume_resampled_FLAIR(1,k) = volume_SEL_resampled_FLAIR.volume;

try
CC_SEL_resampled_T2 = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_resampled','T2_T1','Jacobian','num_CC_SEL_T2.mat'));
volume_SEL_resampled_T2 = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_resampled','T2_T1','Jacobian','volume.mat'));
catch
    CC_SEL_resampled_T2.num_CC_SEL_T2 = NaN;
    volume_SEL_resampled_T2.volume = NaN;    
end
resampled_T2(1,k) = CC_SEL_resampled_T2.num_CC_SEL_T2;
volume_resampled_T2(1,k) = volume_SEL_resampled_T2.volume;

k = k+1;
end

result_sienapd = [sienapd_FLAIR ; volume_sienapd_FLAIR ; sienapd_T2 ; volume_sienapd_T2];
result_robust = [robust_FLAIR ; volume_robust_FLAIR ; robust_T2 ; volume_robust_T2];
result_resampled_FLAIR = [robust_FLAIR ; volume_robust_FLAIR ; resampled_FLAIR ; volume_resampled_FLAIR];
result_resampled_T2 = [robust_T2 ; volume_robust_T2 ; resampled_T2 ; volume_resampled_T2];



%save(fullfile(output_summury,'result_sienapd'), 'result_sienapd');
%save(fullfile(output_summury,'result_robust'), 'result_robust');
%save(fullfile(output_summury,'result_resampled'), 'result_resampled');