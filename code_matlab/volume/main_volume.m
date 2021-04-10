clear all
close all
clc

lesion_prob_base = load_untouch_nii('F:\Utente\TESI\output\000538\20150914_20180917\volume\lesion_mask_baseline.nii.gz');
lesion_prob_foll = load_untouch_nii('F:\Utente\TESI\output\000538\20150914_20180917\volume\lesion_mask_follow_reg.nii.gz');
SEL_1 = load_untouch_nii('F:\Utente\TESI\output\000538\20150914_20180917\volume\SEL_to_baseline_1.nii.gz');
SEL_2 = load_untouch_nii('F:\Utente\TESI\output\000538\20150914_20180917\volume\SEL_to_baseline_2.nii.gz');
SEL_3 = load_untouch_nii('F:\Utente\TESI\output\000538\20150914_20180917\volume\SEL_to_baseline_3.nii.gz');
SEL_4 = load_untouch_nii('F:\Utente\TESI\output\000538\20150914_20180917\volume\SEL_to_baseline_4.nii.gz');

SEL_1 = SEL_1.img;
SEL_2 = SEL_2.img;
SEL_3 = SEL_3.img;
SEL_4 = SEL_4.img;

lesion_prob_base_img = lesion_prob_base.img > 0.5;
lesion_prob_foll_img = lesion_prob_foll.img > 0.5;

[volume_baseline,volume_follow] = volume_sel(lesion_prob_base_img,lesion_prob_foll_img,SEL_1,SEL_2,SEL_3,SEL_4);

save('F:\Utente\TESI\output\000538\20150914_20180917\volume\volume_baseline','volume_baseline');
save('F:\Utente\TESI\output\000538\20150914_20180917\volume\volume_follow','volume_follow');
