clear all 
close all 
clc

% GIANMARCO PALOMBA mat. 1185274
% TESI: IMAGING FOR NEUROSCIENCE
% ARGOMENTO: SLOWLY EXPANDING/EVOLVING LESIONS
%            MULTIPLE SCLEROSIS


%%%%%%%%%%%%%%%%%%%%%%%%%% MAIN SCRIPT %%%%%%%%%%%%%%%%%%%%%%%%%%


% SEL CANDIDATES REGISTRATION WITH SIENAPD


%% FLAIR, T1
% LOADING DATA
nak_detJ_FLAIR = load_untouch_nii('F:\Utente\TESI\Output\001142\20150411_20190429\registration_sienapd\FLAIR_T1\Jacobian\nak_detJ_FLAIR.nii.gz');
lesions_prob_base_halfway = load_untouch_nii('F:\Utente\TESI\Output\001142\20150411_20190429\registration_sienapd\FLAIR_T1\Jacobian\lesion_prob_base_halfway_ANTs.nii.gz');
lesions_prob_foll_halfway = load_untouch_nii('F:\Utente\TESI\Output\001142\20150411_20190429\registration_sienapd\FLAIR_T1\Jacobian\lesion_prob_foll_halfway_ANTs.nii.gz');

nak_detJ_FLAIR = nak_detJ_FLAIR.img;
lesions_prob_base_img = lesions_prob_base_halfway.img > 0.5;
lesions_prob_foll_img = lesions_prob_foll_halfway.img > 0.5;

baseline_date = '11-Apr-2015';
followup_date = '29-Apr-2019';

[SEL_1142_FLAIR, CC_1142_FLAIR, jacobian_mask_EJ1] = sel_candidates(nak_detJ_FLAIR,lesions_prob_base_img,lesions_prob_foll_img,baseline_date,followup_date);

nifti_1142 = lesions_prob_base_halfway;
nifti_1142.img = jacobian_mask_EJ1;
save_untouch_nii(nifti_1142,'F:\Utente\TESI\Output\001142\20150411_20190429\registration_sienapd\FLAIR_T1\Jacobian\SEL_EJ1.nii');

%% T2, T1

nak_detJ_T2 = load_untouch_nii('F:\Utente\TESI\Output\001142\20150411_20190429\registration_sienapd\T2_T1\Jacobian\nak_detJ_T2.nii.gz');
lesions_prob_base_halfway = load_untouch_nii('F:\Utente\TESI\Output\001142\20150411_20190429\registration_sienapd\T2_T1\Jacobian\lesion_prob_base_halfway_ANTs.nii.gz');
lesions_prob_foll_halfway = load_untouch_nii('F:\Utente\TESI\Output\001142\20150411_20190429\registration_sienapd\T2_T1\Jacobian\lesion_prob_foll_halfway_ANTs.nii.gz');

nak_detJ_T2 = nak_detJ_T2.img;

[SEL_1142_T2, CC_1142_T2] = sel_candidates(nak_detJ_T2,lesions_prob_base_img,lesions_prob_foll_img,baseline_date,followup_date);

nifti_1142 = lesions_prob_base_halfway;
nifti_1142.img = SEL_1142_T2;
save_untouch_nii(nifti_1142,'F:\Utente\TESI\Output\001142\20150411_20190429\registration_sienapd\T2_T1\Jacobian\SEL_1142_T2.nii');
