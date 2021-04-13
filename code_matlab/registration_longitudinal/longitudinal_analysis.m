function [SEL,CC_SEL] = longitudinal_analysis(lesion_baseline_img,nak_detJ_1_img,nak_detJ_2_img,nak_detJ_3_img)

voxel = find(lesion_baseline_img);

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

%% Dilation 

SE = strel('sphere',2);
dilate_coeff_ang = imdilate(immagine_coeff_ang_th,SE);

% nuovo fit 
voxel_dilate = find(dilate_coeff_ang);

y_dilate = [nak_detJ_1_img(voxel_dilate)' ; nak_detJ_2_img(voxel_dilate)' ; nak_detJ_3_img(voxel_dilate)'];
x = [1 2 3]';

G = [x ones(3,1)];


for i = 1:length(voxel_dilate)
    p_est = ((G'*G)^(-1))*G'*y_dilate(:,i);
    m(i) = p_est(1);
    q(i) = p_est(2);
end

immagine_coeff_ang_dilate = zeros(180,240,240);

for i=1:length(voxel_dilate)
    immagine_coeff_ang_dilate(voxel_dilate(i)) = m(i);
end



%% Operazione
EJ2 = 0.04;

jacobian_mask_EJ2 = immagine_coeff_ang_dilate >= EJ2;


prev_dilate_mask = immagine_coeff_ang_th ; 

while (~isequal(dilate_coeff_ang,prev_dilate_mask)) % condizione: ~isequal = 1 se le due matrici sono diverse 
    prev_dilate_mask = dilate_coeff_ang;   % quando le matrici dilatate allo step i e i+1 sono uguali esce dal ciclo
    
    
    jacobian_lesions_mask_EJ2 = and(jacobian_mask_EJ2,dilate_coeff_ang);
    jacobian_lesions_mask_EJ2 = and(lesion_baseline_img,jacobian_lesions_mask_EJ2);
    
    dilate_coeff_ang = imdilate(jacobian_lesions_mask_EJ2,SE); 
    
    voxel_dilate_2 = find(dilate_coeff_ang);

    y_new_dilate = [nak_detJ_1_img(voxel_dilate_2)' ; nak_detJ_2_img(voxel_dilate_2)' ; nak_detJ_3_img(voxel_dilate_2)'];

for i = 1:length(voxel_dilate_2)
    p_est = ((G'*G)^(-1))*G'*y_new_dilate(:,i);
    m(i) = p_est(1);
    q(i) = p_est(2);
end

    dilate_coeff_ang = zeros(180,240,240);

    for i=1:length(voxel_dilate_2)
     dilate_coeff_ang(voxel_dilate_2(i)) = m(i);
    end

    
    dilate_coeff_ang = and(jacobian_mask_EJ2,dilate_coeff_ang);
    dilate_coeff_ang = and(lesion_baseline_img,dilate_coeff_ang);
end



CC_dilate_coeff_ang = bwconncomp(dilate_coeff_ang,18);

num_CC = CC_dilate_coeff_ang.NumObjects;
num_minimo_voxel = 30;

% Creo la matrice che successivamente conterrà i candidati SEL finali 
SEL = dilate_coeff_ang;

for i = 1:num_CC
    % Determino la dimensione di ogni singola componente
    dim_CC = size(CC_dilate_coeff_ang.PixelIdxList{1,i});
    dim_CC = dim_CC(1);
    if (dim_CC < num_minimo_voxel) % (1)
        for j = 1:dim_CC
            SEL(CC_dilate_coeff_ang.PixelIdxList{1,i}(j)) = 0;
        end
    end
end

% Infine determino quelle che sono le componenti rimanenti che
% corrispondono ai SEL candidati
CC_SEL = bwconncomp(SEL,18);
num_CC_SEL = CC_SEL.NumObjects;

CC_baseline = bwconncomp(lesion_baseline_img,18);
num_CC_baseline = CC_baseline.NumObjects;

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

%% Calcolo del cv con sd = 1

sd_cost=1;

% Create SigmaV
var=sd_cost^2*ones(3,1);
Sigmav=diag(var);

cv = zeros(2,length(voxel_dilate_2));

for i = 1:length(voxel_dilate_2)
    p_est=inv(G'*Sigmav^-1*G)*G'*y_new_dilate(:,i);
    Sigmap_est=(G'*Sigmav^-1*G)^-1;
    sd_p_est=sqrt(diag(Sigmap_est));
    cv_p_est=(sd_p_est./abs(p_est))*100;
    cv(1,i) = cv_p_est(1);
    cv(2,i) = cv_p_est(2);
    y_pred(:,i)=G*p_est;
end

res=y_new_dilate-y_pred;


end