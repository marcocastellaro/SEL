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


%% Risultati

SEL = or(SEL_1,SEL_2);
SEL = or(SEL,SEL_3);
SEL = or(SEL,SEL_4);

lesion_prob_base_img = im2double(lesion_prob_base_img);
CC_baseline = bwconncomp(lesion_prob_base_img,18);
S_baseline = regionprops(CC_baseline,'Centroid');

% Assegno ad ogni componente connessa della maschera baseline un colore
% differente (Label matrix)
L_baseline = labelmatrix(CC_baseline);

% Componenti connesse e centroidi follow-up
lesion_prob_foll_img = im2double(lesion_prob_foll_img);
CC_follow = bwconncomp(lesion_prob_foll_img,18);
S_follow = regionprops(CC_follow,'Centroid');

% Assegno ad ogni componente connessa della maschera follow-up un colore
% differente (Label matrix)
L_follow = labelmatrix(CC_follow);

% Stessa cosa per la SEL
CC_SEL = bwconncomp(SEL,18);
S_SEL = regionprops(CC_SEL,'Centroid');

L_SEL = labelmatrix(CC_SEL);

% Definisco il numero di componenti connesse delle maschere 
num_CC_baseline = CC_baseline.NumObjects;
num_CC_follow = CC_follow.NumObjects;
num_CC_SEL = CC_SEL.NumObjects;

% Determino la posizione di tutti i voxel delle lesioni nella maschera
% follow-up che appartengono alle componenti connesse (non considero il background)
ind_voxel_CC_baseline = find(lesion_prob_base_img);
ind_voxel_CC_follow = find(lesion_prob_foll_img);
ind_voxel_CC_SEL = find(SEL);

num_voxel_CC_baseline = size(ind_voxel_CC_baseline);
num_voxel_CC_baseline = num_voxel_CC_baseline(1);
num_voxel_CC_follow = size(ind_voxel_CC_follow);
num_voxel_CC_follow = num_voxel_CC_follow(1);
num_voxel_CC_SEL = size(ind_voxel_CC_SEL);
num_voxel_CC_SEL = num_voxel_CC_SEL(1);

CC_SEL_1 = bwconncomp(SEL_1,18);
S_SEL_1 = regionprops(CC_SEL_1,'Centroid');
num_CC_SEL_1 = CC_SEL_1.NumObjects;
ind_voxel_CC_SEL_1 = find(SEL_1);
num_voxel_CC_SEL_1 = size(ind_voxel_CC_SEL_1);
num_voxel_CC_SEL_1 = num_voxel_CC_SEL_1(1);


%% Step 2: COrrispondenza SEL-BASELINE

perc_voxel_baseline_within_SEL = zeros(num_CC_baseline,num_CC_SEL);

for i=1:num_CC_baseline
    for j = 1:num_CC_SEL
        vet_diff = setdiff(CC_SEL.PixelIdxList{1,j},CC_baseline.PixelIdxList{1,i});
        dim = size(CC_SEL.PixelIdxList{1,j});    
        dim = dim(1);
        vet_diff =  dim - length(vet_diff);
        perc_voxel_baseline_within_SEL(i,j) = (vet_diff/dim)*100;
    end
end  

volume_CC_baseline = zeros(num_CC_SEL,1);
clear CC_baseline_SEL_useful

for i = 1:num_CC_SEL
        CC_baseline_SEL_useful{i,1} = perc_voxel_baseline_within_SEL(:,i)>0;
        for j = 1:num_CC_baseline
            if (CC_baseline_SEL_useful{i,1}(j))
                volume_CC_baseline(i) = volume_CC_baseline(i) + length(CC_baseline.PixelIdxList{1,j});
            end
        end
end


%% Step 3 Corrispondenza SEL-follow

perc_voxel_follow_within_SEL = zeros(num_CC_follow,num_CC_SEL);

for i=1:num_CC_follow
    for j = 1:num_CC_SEL
        vet_diff = setdiff(CC_SEL.PixelIdxList{1,j},CC_follow.PixelIdxList{1,i});
        dim = size(CC_SEL.PixelIdxList{1,j});    
        dim = dim(1);
        vet_diff =  dim - length(vet_diff);
        perc_voxel_follow_within_SEL(i,j) = (vet_diff/dim)*100;
        
    end
end  

volume_CC_follow = zeros(num_CC_SEL,1);
clear CC_follow_SEL_useful

for i = 1:num_CC_SEL
        CC_follow_SEL_useful{i,1} = perc_voxel_follow_within_SEL(:,i)>0;
        for j = 1:num_CC_follow
            if (CC_follow_SEL_useful{i,1}(j))
                volume_CC_follow(i) = volume_CC_follow(i) + length(CC_follow.PixelIdxList{1,j});
            end
        end
end