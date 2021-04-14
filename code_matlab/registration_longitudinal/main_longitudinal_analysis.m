clear all 
close all
clc

lesion_baseline = load_untouch_nii('F:\Utente\TESI\output_longitudinal_4\000030\20140707_20180102\registration_longitudinal\T2_T1\Jacobian\lesion_mask_1_halfway_ANTs.nii.gz');
nak_detJ_1 = load_untouch_nii('F:\Utente\TESI\output_longitudinal_4\000030\20140707_20180102\registration_longitudinal\T2_T1\Jacobian\nak_detJ_1.nii.gz');
nak_detJ_2 = load_untouch_nii('F:\Utente\TESI\output_longitudinal_4\000030\20140707_20180102\registration_longitudinal\T2_T1\Jacobian\nak_detJ_2_to_1.nii.gz');
nak_detJ_3 = load_untouch_nii('F:\Utente\TESI\output_longitudinal_4\000030\20140707_20180102\registration_longitudinal\T2_T1\Jacobian\nak_detJ_3_to_1.nii.gz');

lesion_baseline_img = lesion_baseline.img > 0.5;
nak_detJ_1_img = nak_detJ_1.img;
nak_detJ_2_img = nak_detJ_2.img;
nak_detJ_3_img = nak_detJ_3.img;

voxel = find(lesion_baseline_img);
CC_baseline = bwconncomp(lesion_baseline_img,18);
num_CC_baseline = CC_baseline.NumObjects;

%fit dello Jacobiano di questi voxel
y = [nak_detJ_1_img(voxel)' ; nak_detJ_2_img(voxel)' ; nak_detJ_3_img(voxel)'];
x = [1 2 3]';


G = [x ones(3,1)];


for i = 1:length(voxel)
    p_est = ((G'*G)^(-1))*G'*y(:,i);
    m(i) = p_est(1);
    q(i) = p_est(2);
end

immagine_coeff_ang = zeros(180,240,240);

for i=1:length(voxel)
    immagine_coeff_ang(voxel(i)) = m(i);
end


%soglio l'immagine coeff_ang
EJ1 = 0.125;
% Soglio il determinante dello Jacobiano 
immagine_coeff_ang_th = immagine_coeff_ang > EJ1;

CC_coeff_ang = bwconncomp(immagine_coeff_ang_th,18);
% %% Dilation 
% 
% SE = strel('sphere',2);
% dilate_coeff_ang = imdilate(immagine_coeff_ang_th,SE);
% 
% 
% % nuovo fit 
% voxel_dilate = find(dilate_coeff_ang);
% 
% y_dilate = [nak_detJ_1_img(voxel_dilate)' ; nak_detJ_2_img(voxel_dilate)' ; nak_detJ_3_img(voxel_dilate)'];
% x = [1 2 3]';
% 
% G = [x ones(3,1)];
% 
% 
% for i = 1:length(voxel_dilate)
%     p_est = ((G'*G)^(-1))*G'*y_dilate(:,i);
%     m(i) = p_est(1);
%     q(i) = p_est(2);
% end
% 
% immagine_coeff_ang_dilate = zeros(180,240,240);
% 
% for i=1:length(voxel_dilate)
%     immagine_coeff_ang_dilate(voxel_dilate(i)) = m(i);
% end
% 
% %% Operazione
% EJ2 = 0.04;
% 
% jacobian_mask_EJ2 = immagine_coeff_ang_dilate >= EJ2;
% 
% 
% prev_dilate_mask = immagine_coeff_ang_th ; 
% 
% while (~isequal(dilate_coeff_ang,prev_dilate_mask)) % condizione: ~isequal = 1 se le due matrici sono diverse 
%     prev_dilate_mask = dilate_coeff_ang;   % quando le matrici dilatate allo step i e i+1 sono uguali esce dal ciclo
%     
%     
%     jacobian_lesions_mask_EJ2 = and(jacobian_mask_EJ2,dilate_coeff_ang);
%     jacobian_lesions_mask_EJ2 = and(lesion_baseline_img,jacobian_lesions_mask_EJ2);
%     
%     dilate_coeff_ang = imdilate(jacobian_lesions_mask_EJ2,SE); 
%     
%     voxel_dilate_2 = find(dilate_coeff_ang);
% 
%     y_new_dilate = [nak_detJ_1_img(voxel_dilate_2)' ; nak_detJ_2_img(voxel_dilate_2)' ; nak_detJ_3_img(voxel_dilate_2)'];
% 
%     sd_cost=1;
% 
%     % Create SigmaV
%   
% for i = 1:length(voxel_dilate_2)
%     p_est = ((G'*G)^(-1))*G'*y_new_dilate(:,i);
%     m(i) = p_est(1);
%     q(i) = p_est(2);
%     Sigmap_est=(G'*G)^-1;
%     sd_p_est=sqrt(diag(Sigmap_est));
%     cv_p_est=(sd_p_est./abs(p_est))*100;
%     cv(1,i) = cv_p_est(1);
%     cv(2,i) = cv_p_est(2);
% end
% 
%     dilate_coeff_ang = zeros(180,240,240);
%     cv_image = zeros(180,240,240);
%     for i=1:length(voxel_dilate_2)
%      dilate_coeff_ang(voxel_dilate_2(i)) = m(i);
%      cv_image(voxel_dilate_2(i)) = cv(1,i);
%     end
% 
%     dilate_coeff_ang_img = dilate_coeff_ang;
% 
%     
%     dilate_coeff_ang = and(jacobian_mask_EJ2,dilate_coeff_ang);
%     dilate_coeff_ang = and(lesion_baseline_img,dilate_coeff_ang);
% end
% 
% % nifti = lesion_baseline;
% % nifti.img = dilate_coeff_ang_img;
% % save_untouch_nii(nifti,'F:\Utente\TESI\output_longitudinal_4\000030\20140707_20180102\registration_longitudinal\T2_T1\Jacobian\dilate_coeff_ang_img.nii.gz')
% % 
% % nifti = lesion_baseline;
% % nifti.img = cv_image;
% % save_untouch_nii(nifti,'F:\Utente\TESI\output_longitudinal_4\000030\20140707_20180102\registration_longitudinal\T2_T1\Jacobian\immagine_cv.nii.gz')
% good_cv = and(dilate_coeff_ang,and(cv_image>0,cv_image<200));
% 
% CC_dilate_coeff_ang = bwconncomp(good_cv,18);
% 
% num_CC = CC_dilate_coeff_ang.NumObjects;

% % Creo la matrice che successivamente conterrà i candidati SEL finali 
% SEL = good_cv;
num_minimo_voxel = 30;
num_CC = CC_coeff_ang.NumObjects;
SEL = immagine_coeff_ang_th;

for i = 1:num_CC
    % Determino la dimensione di ogni singola componente
    dim_CC = size(CC_coeff_ang.PixelIdxList{1,i});
    dim_CC = dim_CC(1);
    if (dim_CC < num_minimo_voxel) % (1)
        for j = 1:dim_CC
            SEL(CC_coeff_ang.PixelIdxList{1,i}(j)) = 0;
        end
    end
end

CC_SEL = bwconncomp(SEL,18);
num_CC_SEL = CC_SEL.NumObjects;

perc_voxel = zeros(num_CC_baseline,num_CC_SEL);

for i=1:num_CC_baseline
    for j = 1:num_CC_SEL
        vet_diff = setdiff(CC_SEL.PixelIdxList{1,j},CC_baseline.PixelIdxList{1,i});
        dim = size(CC_SEL.PixelIdxList{1,j});    
        dim = dim(1);
        vet_diff =  dim - length(vet_diff);
        perc_voxel(i,j) = (vet_diff/dim)*100;
    end
end

perc_voxel = perc_voxel > 80;
SEL_finale = zeros(180,240,240);
pos = 0;

for i = 1:num_CC_SEL
            pos = find(perc_voxel(:,i));
            SEL_finale(CC_baseline.PixelIdxList{1,pos}) = 1;
            pos = 0;
   
end

CC_SEL_finale = bwconncomp(SEL_finale,18);
