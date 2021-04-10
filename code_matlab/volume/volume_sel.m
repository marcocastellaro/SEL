clear all
close all
clc

lesion_prob_base = load_untouch_nii('F:\Utente\TESI\output\000538\20150914_20180917\volume\lesion_mask_baseline.nii.gz');
lesion_prob_foll = load_untouch_nii('F:\Utente\TESI\output\000538\20150914_20180917\volume\lesion_mask_follow_reg.nii.gz');
SEL = load_untouch_nii('F:\Utente\TESI\output\000538\20150914_20180917\registration_robust_template\FLAIR_T1\Jacobian\SEL_to_baseline.nii.gz');

SEL = SEL.img;
lesions_prob_base_img = lesion_prob_base.img > 0.5;
lesions_prob_foll_img = lesion_prob_foll.img > 0.5;

%% Step 1

lesions_prob_base_img = im2double(lesions_prob_base_img);
CC_baseline = bwconncomp(lesions_prob_base_img,18);
S_baseline = regionprops(CC_baseline,'Centroid');

% Assegno ad ogni componente connessa della maschera baseline un colore
% differente (Label matrix)
L_baseline = labelmatrix(CC_baseline);

% Componenti connesse e centroidi follow-up
lesions_prob_foll_img = im2double(lesions_prob_foll_img);
CC_follow = bwconncomp(lesions_prob_foll_img,18);
S_follow = regionprops(CC_follow,'Centroid');

% Assegno ad ogni componente connessa della maschera follow-up un colore
% differente (Label matrix)
L_follow = labelmatrix(CC_follow);

% Stessa cosa per la SEL
CC_SEL = bwconncomp(SEL,18);
S_baseline = regionprops(CC_baseline,'Centroid');

L_SEL = labelmatrix(CC_SEL);

% Definisco il numero di componenti connesse delle maschere 
num_CC_baseline = CC_baseline.NumObjects;
num_CC_follow = CC_follow.NumObjects;
num_CC_SEL = CC_SEL.NumObjects;

% Determino la posizione di tutti i voxel delle lesioni nella maschera
% follow-up che appartengono alle componenti connesse (non considero il background)
ind_voxel_CC_baseline = find(lesions_prob_base_img);
ind_voxel_CC_follow = find(lesions_prob_foll_img);
ind_voxel_CC_SEL = find(SEL);

num_voxel_CC_baseline = size(ind_voxel_CC_baseline);
num_voxel_CC_baseline = num_voxel_CC_baseline(1);
num_voxel_CC_follow = size(ind_voxel_CC_follow);
num_voxel_CC_follow = num_voxel_CC_follow(1);
num_voxel_CC_SEL = size(ind_voxel_CC_SEL);
num_voxel_CC_SEL = num_voxel_CC_SEL(1);




%% Elimino le CC con un numero inferiore a 30 voxel
for i = 1:num_CC_baseline
    % Determino la dimensione di ogni singola componente
    dim_CC = size(CC_dilate_mask.PixelIdxList{1,i});
    dim_CC = dim_CC(1);
    if (dim_CC < num_minimo_voxel) % (1)
        for j = 1:dim_CC
            SEL(CC_dilate_mask.PixelIdxList{1,i}(j)) = 0;
        end
    end
end

%% Step 2: COrrispondenza SEL-BASELINE

perc_voxel_baseline_within_SEL = zeros(num_CC_baseline,1);

for i=1:num_CC_baseline
        vet_diff = setdiff(ind_voxel_CC_SEL,CC_baseline.PixelIdxList{1,i});
        dim = size(ind_voxel_CC_SEL);    
        dim = dim(1);
        vet_diff =  dim - length(vet_diff);
        perc_voxel_baseline_within_SEL(i,1) = (vet_diff/dim)*100;
end
   
    
CC_baseline_SEL_useful = find(perc_voxel_baseline_within_SEL);

SEL_baseline = lesions_prob_base_img;

for i = 1:num_CC_baseline
    % Determino la dimensione di ogni singola componente
    dim_CC = size(CC_baseline.PixelIdxList{1,i});
    dim_CC = dim_CC(1);
    if (perc_voxel_baseline_within_SEL(i,1) == 0) % (1)
        for j = 1:dim_CC
            SEL_baseline(CC_baseline.PixelIdxList{1,i}(j)) = 0;
        end
    end
end

ind_volume = find(SEL_baseline);

volume_baseline_sel = size(ind_volume);
volume_baseline_sel = volume_baseline_sel(1);

%% Step 3 Corrispondenza SEL-follow

perc_voxel_follow_within_SEL = zeros(num_CC_follow,1);

for i=1:num_CC_follow
        vet_diff = setdiff(ind_voxel_CC_SEL,CC_follow.PixelIdxList{1,i});
        dim = size(ind_voxel_CC_SEL);    
        dim = dim(1);
        vet_diff =  dim - length(vet_diff);
        perc_voxel_follow_within_SEL(i,1) = (vet_diff/dim)*100;
end
   
    
CC_follow_SEL_useful = find(perc_voxel_follow_within_SEL);

SEL_follow = lesions_prob_foll_img;

for i = 1:num_CC_follow
    % Determino la dimensione di ogni singola componente
    dim_CC = size(CC_follow.PixelIdxList{1,i});
    dim_CC = dim_CC(1);
    if (perc_voxel_follow_within_SEL(i,1) == 0) % (1)
        for j = 1:dim_CC
            SEL_follow(CC_follow.PixelIdxList{1,i}(j)) = 0;
        end
    end
end

ind_volume = find(SEL_follow);

volume_follow_sel = size(ind_volume);
volume_follow_sel = volume_follow_sel(1);

