clear all
close all
clc

%base_directory = '/nfsd/biopetmri/BACKUP/Users/Marco/3T_Verona/SEL_candidates';
base_directory = 'F:\Utente\TESI';

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

result_sienapd = zeros(4,dim);
result_robust = zeros(4,dim);
result_resampled_FLAIR = zeros(4,dim);
result_resampled_T2 = zeros(4,dim);

k = 1;

for t=3:1:length(list_output)

subjID_output = list_output(t).name;
subj_path_output= fullfile(output_path, subjID_output);
subj_output_list=dir(subj_path_output);

try
CC_SEL_sienapd_FLAIR = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_sienapd','FLAIR_T1','Jacobian','num_CC_SEL_FLAIR.mat'));
volume_1 = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_sienapd','FLAIR_T1','Jacobian','volume.mat'));
catch
    CC_SEL_sienapd_FLAIR.num_CC_SEL_FLAIR = NaN;
    volume_1.volume = NaN;
end
sienapd_FLAIR(1,k) = CC_SEL_sienapd_FLAIR.num_CC_SEL_FLAIR;
volume_sienapd_FLAIR(1,k) = volume_1.volume;

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

%% Analisi longitudinale

output_path=fullfile(base_directory,'output_longitudinal');
list_output=dir(output_path);
dim=length(list_output)-2;

longitudinal_FLAIR_SEL = zeros(3,dim);
longitudinal_T2_SEL = zeros(3,dim);

longitudinal_FLAIR_volume = zeros(3,dim);
longitudinal_T2_volume = zeros(3,dim);

for t=3:1:length(list_output)

subjID_output = list_output(t).name;
subj_path_output= fullfile(output_path, subjID_output);
subj_output_list=dir(subj_path_output);

try
CC_SEL_1 = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','FLAIR_T1','Jacobian','num_CC_SEL_1.mat'));
volume_1 = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','FLAIR_T1','Jacobian','volume_1.mat'));
CC_SEL_2 = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','FLAIR_T1','Jacobian','num_CC_SEL_2.mat'));
volume_2 = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','FLAIR_T1','Jacobian','volume_2.mat'));
CC_SEL_3 = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','FLAIR_T1','Jacobian','num_CC_SEL_3.mat'));
volume_3 = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','FLAIR_T1','Jacobian','volume_3.mat'));

catch
    CC_SEL_1.num_CC_SEL_1 = NaN;
    volume_1.volume_1 = NaN;
    CC_SEL_2.num_CC_SEL_2 = NaN;
    volume_2.volume_2 = NaN;
    CC_SEL_3.num_CC_SEL_3 = NaN;
    volume_3.volume_3 = NaN;
end

longitudinal_FLAIR_SEL(1,k) = CC_SEL_1.num_CC_SEL_1;
longitudinal_FLAIR_SEL(2,k) = CC_SEL_2.num_CC_SEL_2;
longitudinal_FLAIR_SEL(3,k) = CC_SEL_3.num_CC_SEL_3;

longitudinal_FLAIR_volume(1,k) = volume_1.volume_1;
longitudinal_FLAIR_volume(2,k) = volume_2.volume_2;
longitudinal_FLAIR_volume(3,k) = volume_3.volume_3;


try
CC_SEL_1 = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','num_CC_SEL_1.mat'));
volume_1 = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','volume_1.mat'));
CC_SEL_2 = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','num_CC_SEL_2.mat'));
volume_2 = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','volume_2.mat'));
CC_SEL_3 = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','num_CC_SEL_3.mat'));
volume_3 = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','volume_3.mat'));

catch
    CC_SEL_1.num_CC_SEL_1 = NaN;
    volume_1.volume_1 = NaN;
    CC_SEL_2.num_CC_SEL_2 = NaN;
    volume_2.volume_2 = NaN;
    CC_SEL_3.num_CC_SEL_3 = NaN;
    volume_3.volume_3 = NaN;
end

longitudinal_T2_SEL(1,k) = CC_SEL_1.num_CC_SEL_1;
longitudinal_T2_SEL(2,k) = CC_SEL_2.num_CC_SEL_2;
longitudinal_T2_SEL(3,k) = CC_SEL_3.num_CC_SEL_3;

longitudinal_T2_volume(1,k) = volume_1.volume_1;
longitudinal_T2_volume(2,k) = volume_2.volume_2;
longitudinal_T2_volume(3,k) = volume_3.volume_3;

k = k+1;
end

%% RISULTATI FINALI: boxplot

%FreeSurfer
image = char('FLAIR','T2-w');
figure
boxplot([result_robust(1,:)' result_robust(3,:)'],image)
ylabel('numero SEL identificate','FontSize',18,'Interpreter','latex')

%Siena
figure
boxplot([result_sienapd(1,:)' result_sienapd(3,:)'],image)
ylabel('numero SEL identificate','FontSize',18,'Interpreter','latex')

%Ricampionamento FLAIR
nomi = char('1x1x1 mm','1x1x3 mm');
figure
boxplot([result_resampled_FLAIR(1,:)' result_resampled_FLAIR(3,:)'],nomi)
ylabel('numero SEL identificate','FontSize',14,'Interpreter','latex')

%Ricampionamento T2
figure
boxplot([result_resampled_T2(1,:)' result_resampled_T2(3,:)'],nomi)
ylabel('numero SEL identificate','FontSize',14,'Interpreter','latex')

% tutti i resampled insieme
nomi_2 = char('FLAIR 1x1x1 mm','T2-w 1x1x1 mm','FLAIR 1x1x3 mm','T2-w 1x1x3 mm');
figure
boxplot([result_resampled_FLAIR(1,:)' result_resampled_T2(1,:)' result_resampled_FLAIR(3,:)' result_resampled_T2(3,:)'],nomi_2)
ylabel('numero SEL identificate','FontSize',14,'Interpreter','latex')

%% RISULTATI FINALI: Scatter plot
figure
scatter(result_robust(1,:)', result_robust(3,:)','b')
xlabel('FLAIR','FontSize',14,'Interpreter','latex')
ylabel('T2-w','FontSize',14,'Interpreter','latex')
legend('soggetto','FontSize',10,'Location','SouthEast','Interpreter','latex');
xlim([0 15])
ylim([0 15])
grid on

figure
scatter(result_sienapd(1,:)', result_sienapd(3,:)')
xlabel('FLAIR','FontSize',14,'Interpreter','latex')
ylabel('T2-w','FontSize',14,'Interpreter','latex')
title('numero SEL identificate: SIENA','FontSize',20,'Interpreter','latex')
legend('soggetto','Interpreter','latex','FontSize',10,'Location','SouthEast');
xlim([0 14])
ylim([0 14])
grid on

figure
scatter(result_resampled_FLAIR(1,:)', result_resampled_FLAIR(3,:)')
xlabel('1x1x1 mmm','FontSize',14,'Interpreter','latex')
ylabel('1x1x3 mmm','FontSize',14,'Interpreter','latex')
legend('soggetto','Interpreter','latex','FontSize',10,'Location','SouthEast');
xlim([0 9])
ylim([0 9])
grid on

figure
scatter(result_resampled_T2(1,:)', result_resampled_T2(3,:)')
xlabel('1x1x1 mmm','FontSize',14,'Interpreter','latex')
ylabel('1x1x3 mmm','FontSize',14,'Interpreter','latex')
legend('soggetto','Interpreter','latex','FontSize',10,'Location','SouthEast');
xlim([0 14])
ylim([0 14])
grid on


%% RISULTATI FINALI: Istogramma a barre per determinare il numero di soggetti che presentano SEL
subj_with_SEL_sienapd_FLAIR = find(sienapd_FLAIR);
dim1 = size(subj_with_SEL_sienapd_FLAIR);
dim1 = dim1(2);

subj_with_SEL_sienapd_T2 = find(sienapd_T2);
dim2 = size(subj_with_SEL_sienapd_T2);
dim2 = dim2(2);

subj_with_SEL_robust_FLAIR = find(robust_FLAIR);
dim3 = size(subj_with_SEL_robust_FLAIR);
dim3 = dim3(2);

subj_with_SEL_robust_T2 = find(robust_T2);
dim4 = size(subj_with_SEL_robust_T2);
dim4 = dim4(2);

subj_with_SEL_resampled_FLAIR = find(resampled_FLAIR);
dim5 = size(subj_with_SEL_resampled_FLAIR);
dim5 = dim5(2);

subj_with_SEL_resampled_T2 = find(resampled_T2);
dim6 = size(subj_with_SEL_resampled_T2);
dim6 = dim6(2);


x = [1];
vals1 = [dim3; dim4];

figure
b = bar(x,vals1);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center','VerticalAlignment','bottom')
xtips2 = b(2).XEndPoints;
ytips2 = b(2).YEndPoints;
labels2 = string(b(2).YData);
text(xtips2,ytips2,labels2,'HorizontalAlignment','center','VerticalAlignment','bottom')
grid on
ylabel('Soggetti','FontSize',14,'Interpreter','latex')
legend({'FLAIR','T2-w'},'Location','northwest')
ylim([0 43])
ax = gca;
ax.XTick = [1]; 
ax.XTickLabels = {'FreeSurfer','FontSize',10,'Interpreter','latex'};
ax.XTickLabelRotation = 0;

vals2 = [dim3 dim5; dim4 dim6];

figure
b = bar(x,vals2);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center','VerticalAlignment','bottom')
xtips2 = b(2).XEndPoints;
ytips2 = b(2).YEndPoints;
labels2 = string(b(2).YData);
text(xtips2,ytips2,labels2,'HorizontalAlignment','center','VerticalAlignment','bottom')
grid on
ylabel('numero soggetti con SEL','FontSize',14,'Interpreter','latex')
legend({'1x1x1 mm','1x1x3 mm'},'Location','northwest')
ylim([0 43])
ax = gca;
ax.XTick = [1 2]; 
ax.XTickLabels = {'FLAIR','T2-w','FontSize',12,'Interpreter','latex'};
ax.XTickLabelRotation = 0;



%save(fullfile(output_summury,'result_sienapd'), 'result_sienapd');
%save(fullfile(output_summury,'result_robust'), 'result_robust');
%save(fullfile(output_summury,'result_resampled'), 'result_resampled');