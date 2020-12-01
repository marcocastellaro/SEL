clear all 
close all 
clc

% GIANMARCO PALOMBA mat. 1185274
% TESI: IMAGING FOR NEUROSCIENCE
% ARGOMENTO: SLOWLY EXPANDING/EVOLVING LESIONS
%            MULTIPLE SCLEROSIS


%%%%%%%%%%%%%%%%%%%%%%%%%% MAIN SCRIPT %%%%%%%%%%%%%%%%%%%%%%%%%%

% SEL CANDIDATES

% 1) FIND COMMON LESIONS IN BASELINE AND FOLLOW-UP MASKS LESIONS

%%  pz n.000004 
% baseline 20150413
% follow up 20190304

% LOADING DATA
log_detJ = load_untouch_nii('F:\Utente\TESI\Registrazione_SEL\000004\test\Jacobian_output\log_detJ.nii.gz');
lesions_mask_base_halfway = load_untouch_nii('F:\Utente\TESI\Registrazione_SEL\000004\test\Jacobian_output\lesion_mask_base_halfway_ANTs.nii.gz');
lesions_mask_foll_halfway = load_untouch_nii('F:\Utente\TESI\Registrazione_SEL\000004\test\Jacobian_output\lesion_mask_foll_halfway_ANTs.nii.gz');

log_detJ_img = log_detJ.img;
lesions_mask_base_img = lesions_mask_base_halfway.img;
lesions_mask_foll_img = lesions_mask_foll_halfway.img;

baseline_date = '13-Apr-2015';
followup_date = '04-Mar-2019';

[SEL_4, CC_SEL_4, J_mask_4] = sel_candidates(log_detJ_img,lesions_mask_base_img,lesions_mask_foll_img,baseline_date,followup_date);

% nifti_J_mask = lesions_mask_base_halfway;
% nifti_J_mask.img = J_mask_4;
% save_untouch_nii(nifti_J_mask,'F:\Utente\TESI\Candidati_SEL\000004\J_mask.nii');

%% pz n. 000027
% baseline 20140630
% follow up 20190715

% LOADING DATA
log_detJ = load_untouch_nii('F:\Utente\TESI\Registrazione_SEL\000027\test\Jacobian_output\log_detJ.nii.gz');
lesions_mask_base_halfway = load_untouch_nii('F:\Utente\TESI\Registrazione_SEL\000027\test\Jacobian_output\lesion_mask_base_halfway_ANTs.nii.gz');
lesions_mask_foll_halfway = load_untouch_nii('F:\Utente\TESI\Registrazione_SEL\000027\test\Jacobian_output\lesion_mask_foll_halfway_ANTs.nii.gz');

log_detJ_img = log_detJ.img;
lesions_mask_base_img = lesions_mask_base_halfway.img;
lesions_mask_foll_img = lesions_mask_foll_halfway.img;

baseline_date = '30-Jun-2014';
followup_date = '15-Jul-2019';

[SEL_27, CC_SEL_27, J_mask_27] = sel_candidates(log_detJ_img,lesions_mask_base_img,lesions_mask_foll_img,baseline_date,followup_date);

% nifti_J_mask = lesions_mask_base_halfway;
% nifti_J_mask.img = J_mask_27;
% save_untouch_nii(nifti_J_mask,'F:\Utente\TESI\Candidati_SEL\000027\J_mask.nii');

%% pz n. 000128 
% baseline 20170623
% follow up 20200120

% LOADING DATA
log_detJ = load_untouch_nii('F:\Utente\TESI\Registrazione_SEL\000128\test\Jacobian_output\log_detJ.nii.gz');
lesions_mask_base_halfway = load_untouch_nii('F:\Utente\TESI\Registrazione_SEL\000128\test\Jacobian_output\lesion_mask_base_halfway_ANTs.nii.gz');
lesions_mask_foll_halfway = load_untouch_nii('F:\Utente\TESI\Registrazione_SEL\000128\test\Jacobian_output\lesion_mask_foll_halfway_ANTs.nii.gz');

log_detJ_img = log_detJ.img;
lesions_mask_base_img = lesions_mask_base_halfway.img;
lesions_mask_foll_img = lesions_mask_foll_halfway.img;

baseline_date = '23-Jun-2017';
followup_date = '20-Gen-2020';

[SEL_128, CC_SEL_128, J_mask_128] = sel_candidates(log_detJ_img,lesions_mask_base_img,lesions_mask_foll_img,baseline_date,followup_date);

% nifti_J_mask = lesions_mask_base_halfway;
% nifti_J_mask.img = J_mask_128;
% save_untouch_nii(nifti_J_mask,'F:\Utente\TESI\Candidati_SEL\000128\J_mask.nii');

%% pz n. 000298
% baseline 20161121 
% follow-up 20190930

% LOADING DATA
log_detJ = load_untouch_nii('F:\Utente\TESI\Registrazione_SEL\000298\test\Jacobian_output\log_detJ.nii.gz');
lesions_mask_base_halfway = load_untouch_nii('F:\Utente\TESI\Registrazione_SEL\000298\test\Jacobian_output\lesion_mask_base_halfway_ANTs.nii.gz');
lesions_mask_foll_halfway = load_untouch_nii('F:\Utente\TESI\Registrazione_SEL\000298\test\Jacobian_output\lesion_mask_foll_halfway_ANTs.nii.gz');

log_detJ_img = log_detJ.img;
lesions_mask_base_img = lesions_mask_base_halfway.img;
lesions_mask_foll_img = lesions_mask_foll_halfway.img;

baseline_date = '21-Nov-2016';
followup_date = '30-Sep-2019';

[SEL_298, CC_SEL_298, J_mask_298] = sel_candidates(log_detJ_img,lesions_mask_base_img,lesions_mask_foll_img,baseline_date,followup_date);

% nifti_J_mask = lesions_mask_base_halfway;
% nifti_J_mask.img = J_mask_298;
% save_untouch_nii(nifti_J_mask,'F:\Utente\TESI\Candidati_SEL\000298\J_mask.nii');
