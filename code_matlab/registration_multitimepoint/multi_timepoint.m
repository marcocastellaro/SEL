%% Analisi dello Jacobiano considerando più timepoint
% pz 000018
% I timepoint -> 20140609
% II timepoint -> 20150603
% III timepoint -> 20190325

clear all 
close all
clc 

%% Carico i determinanti dello Jacobiano calcolati precedentemente tra i timepoint
nak_detJ_I_II = load_untouch_nii('F:\Utente\TESI\000018\da_provare\Jacobian\nak_detJ_I.nii.gz');
nak_detJ_II_III = load_untouch_nii('F:\Utente\TESI\000018\da_provare\Jacobian\nak_detJ_II_to_halfway.nii.gz');
lesion_mask_halfway = load_untouch_nii('F:\Utente\TESI\000018\da_provare\Jacobian\lesion_mask_2014_halfway_ANTs.nii.gz');
nak_detJ_I_III = load_untouch_nii('F:\Utente\TESI\000018\da_provare\Jacobian\nak_detJ_I_III.nii.gz');

nak_detJ_I_III_img = nak_detJ_I_III.img;
nak_detJ_I_II_norm = nak_detJ_I_II.img;
nak_detJ_II_III_norm = nak_detJ_II_III.img;
lesion_mask_halfway_img = lesion_mask_halfway.img > 0.5;

I = '09-Jun-2014';
II = '08-Jun-2015';
III = '25-Mar-2019';

%% determino separatamente i candidati sel dai due determinanti 
[SEL_I_II, CC_SEL_I_II] = sel_candidates(nak_detJ_I_II_norm,lesion_mask_halfway_img,I,II);

nifti_I_II = lesion_mask_halfway;
nifti_I_II.img = SEL_I_II;
save_untouch_nii(nifti_I_II,'F:\Utente\Tesi\000018\da_provare\Jacobian\SEL_I_II.nii');

[SEL_II_III, CC_SEL_II_III] = sel_candidates(nak_detJ_II_III_norm,lesion_mask_halfway_img,II,III);

nifti_II_III = lesion_mask_halfway;
nifti_II_III.img = SEL_II_III;
save_untouch_nii(nifti_II_III,'F:\Utente\Tesi\000018\da_provare\Jacobian\SEL_II_III.nii');

%% Moltiplico i due SEL candidates ottenuti 
SEL_post_and = and(SEL_I_II,SEL_II_III);

nifti_product = lesion_mask_halfway;
nifti_product.img = SEL_post_and;
save_untouch_nii(nifti_product,'F:\Utente\Tesi\000018\da_provare\Jacobian\SEL_post_and.nii');

%% Moltiplico i due determinanti prima in modo da ottenere solo quei voxel che realmente sono caratterizzati da espansione

date_baseline = datenum(I); 
date_follow = datenum(II);
diff = date_follow - date_baseline;
y1 = diff/365.2425;

date_baseline = datenum(II); 
date_follow = datenum(III);
diff = date_follow - date_baseline;
y2 = diff/365.2425;

%normalizzo i due determinanti
nak_detJ_I_II_norm = nak_detJ_I_II.img./y1;
nak_detJ_II_III_norm = nak_detJ_II_III.img./y2;

% Soglio EJ1 = 0.125
nak_detJ_I_II_norm_th1 = nak_detJ_I_II_norm >= 0.125;
nak_detJ_II_III_norm_th1 = nak_detJ_II_III_norm >= 0.125;

% Ottengo solo i voxel che in entrambi i determinanti presentano espansione
% maggiore o uguale alla soglia EJ1
nak_detJ_expansion_th1 = and(nak_detJ_I_II_norm_th1,nak_detJ_II_III_norm_th1);

% Soglio con EJ2 = 0.04 (in modo da utilizzare il risultato per effettuare la dilatazione)
nak_detJ_I_II_norm_th2 = nak_detJ_I_II_norm >= 0.04;
nak_detJ_II_III_norm_th2 = nak_detJ_II_III_norm >= 0.04;

% Ottengo solo i voxel che in entrambi i determinanti presentano espansione
% maggiore o uguale alla soglia EJ2
nak_detJ_expansion_th2 = and(nak_detJ_I_II_norm_th2,nak_detJ_II_III_norm_th2);

nifti_th2 = lesion_mask_halfway;
nifti_th2.img = nak_detJ_expansion_th2;
save_untouch_nii(nifti_th2,'F:\Utente\TESI\000018\da_provare\Jacobian\nak_detJ_expansion_th2.nii');

% Calcolo i candidati SEL 
[SEL_pre_and, CC_SEL_pre_and,jacobian_lesions_mask_EJ1_base] = sel_candidates_th(nak_detJ_expansion_th1,nak_detJ_expansion_th2,lesion_mask_halfway_img);

nifti_pre_dil = lesion_mask_halfway;
nifti_pre_dil.img = jacobian_lesions_mask_EJ1_base;
save_untouch_nii(nifti_pre_dil,'F:\Utente\TESI\000018\da_provare\Jacobian\jacobian_lesions_mask_EJ1_base.nii');

nifti_pre = lesion_mask_halfway;
nifti_pre.img = SEL_pre_and;
save_untouch_nii(nifti_pre,'F:\Utente\TESI\000018\da_provare\Jacobian\SEL_pre_and.nii');

%% Determino i candidati SEL considerando solo i due timepoint I e III 

[SEL_I_III,CC_SEL_I_III] = sel_candidates(nak_detJ_I_III_img,lesion_mask_halfway_img,I,III);

nifti_gesu = lesion_mask_halfway;
nifti_gesu.img = SEL_I_III;
save_untouch_nii(nifti_gesu,'F:\Utente\TESI\000018\da_provare\Jacobian\SEL_I_III.nii');





