clear all 
close all 
clc

% GIANMARCO PALOMBA mat. 1185274
% TESI: IMAGING FOR NEUROSCIENCE
% ARGOMENTO: SLOWLY EXPANDING/EVOLVING LESIONS
%            MULTIPLE SCLEROSIS


%%%%%%%%%%%%%%%%%%%%%%%%%% MAIN SCRIPT %%%%%%%%%%%%%%%%%%%%%%%%%%


%  RESAMPLED IMAGES REGISTRATION SEL CANDIDATES

%% FLAIR, T1

% LOADING DATA
nak_detJ = load_untouch_nii('F:\Utente\TESI\Output\001142\20150411_20190429\registration_resampled\Jacobian\nak_detJ.nii.gz');
lesions_prob_base_halfway = load_untouch_nii('F:\Utente\TESI\Output\001142\20150411_20190429\registration_resampled\Jacobian\lesion_prob_base_halfway_ANTs.nii.gz');
lesions_prob_foll_halfway = load_untouch_nii('F:\Utente\TESI\Output\001142\20150411_20190429\registration_resampled\Jacobian\lesion_prob_foll_halfway_ANTs.nii.gz');

nak_detJ = nak_detJ.img;
lesions_prob_base_img = lesions_prob_base_halfway.img > 0.5;
lesions_prob_foll_img = lesions_prob_foll_halfway.img > 0.5;

baseline_date = '11-Apr-2015';
followup_date = '29-Apr-2019';

[SEL_1142, CC_1142] = sel_candidates(nak_detJ,lesions_prob_base_img,lesions_prob_foll_img,baseline_date,followup_date);

nifti_1142 = lesions_prob_base_halfway;
nifti_1142.img = SEL_1142;
save_untouch_nii(nifti_1142,'F:\Utente\TESI\Output\001142\20150411_20190429\registration_resampled\Jacobian\SEL_1142.nii');

%copyfile('F:\Utente\TESI\Output\001142\20150411_20190429\registration_robust_template\FLAIR_T1\Jacobian\SEL_1142_FLAIR.nii','F:\Utente\TESI\Output\001142\20150411_20190429\registration_resampled\Jacobian\SEL_1142_FLAIR.nii','f');
%copyfile('F:\Utente\TESI\Output\001142\20150411_20190429\registration_robust_template\FLAIR_T1\Jacobian\nak_detJ_FLAIR.nii.gz','F:\Utente\TESI\Output\001142\20150411_20190429\registration_resampled\Jacobian\nak_detJ_FLAIR.nii.gz','f');
