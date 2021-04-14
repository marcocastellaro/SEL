clear all
close all
clc

%base_directory = '/nfsd/biopetmri/BACKUP/Users/Marco/3T_Verona/SEL_candidates';
base_directory = 'F:\Utente\TESI';

output_path_4=fullfile(base_directory,'output');

output_summury=fullfile(base_directory,'output_summary');

list_output_4=dir(output_path_4);
dim=length(list_output_4)-2;

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
CC_SEL_sienapd_FLAIR = load(fullfile(subj_path_output,subj_output_list_4(3).name,'registration_sienapd','FLAIR_T1','Jacobian','num_CC_SEL_FLAIR.mat'));
volume_1_FLAIR = load(fullfile(subj_path_output,subj_output_list_4(3).name,'registration_sienapd','FLAIR_T1','Jacobian','volume.mat'));
catch
    CC_SEL_sienapd_FLAIR.num_CC_SEL_FLAIR = NaN;
    volume_1_FLAIR.volume = NaN;
end
sienapd_FLAIR(1,k) = CC_SEL_sienapd_FLAIR.num_CC_SEL_FLAIR;
volume_sienapd_FLAIR(1,k) = volume_1_FLAIR.volume;

try
CC_SEL_sienapd_T2 = load(fullfile(subj_path_output_4,subj_output_list_4(3).name,'registration_sienapd','T2_T1','Jacobian','num_CC_SEL_T2.mat'));
volume_SEL_sienapd_T2 = load(fullfile(subj_path_output_4,subj_output_list_4(3).name,'registration_sienapd','T2_T1','Jacobian','volume.mat'));
catch
    CC_SEL_sienapd_T2.num_CC_SEL_T2 = NaN;
    volume_SEL_sienapd_T2.volume = NaN;
end
sienapd_T2(1,k) = CC_SEL_sienapd_T2.num_CC_SEL_T2;
volume_sienapd_T2(1,k) = volume_SEL_sienapd_T2.volume;

try
    
CC_SEL_robust_FLAIR = load(fullfile(subj_path_output_4,subj_output_list_4(3).name,'registration_robust_template','FLAIR_T1','Jacobian','num_CC_SEL_FLAIR.mat'));
volume_SEL_robust_FLAIR = load(fullfile(subj_path_output_4,subj_output_list_4(3).name,'registration_robust_template','FLAIR_T1','Jacobian','volume.mat'));
catch
    CC_SEL_robust_FLAIR.num_CC_SEL_FLAIR = NaN;
    volume_SEL_robust_FLAIR.volume = NaN;
end

robust_FLAIR(1,k) = CC_SEL_robust_FLAIR.num_CC_SEL_FLAIR;
volume_robust_FLAIR(1,k) = volume_SEL_robust_FLAIR.volume;

try
CC_SEL_robust_T2 = load(fullfile(subj_path_output_4,subj_output_list_4(3).name,'registration_robust_template','T2_T1','Jacobian','num_CC_SEL_T2.mat'));
volume_SEL_robust_T2 = load(fullfile(subj_path_output_4,subj_output_list_4(3).name,'registration_robust_template','T2_T1','Jacobian','volume.mat'));
catch

    CC_SEL_robust_T2.num_CC_SEL_T2 = NaN;
    volume_SEL_robust_T2.volume = NaN;
end

robust_T2(1,k) = CC_SEL_robust_T2.num_CC_SEL_T2;
volume_robust_T2(1,k) = volume_SEL_robust_T2.volume;

try
CC_SEL_resampled_FLAIR = load(fullfile(subj_path_output_4,subj_output_list_4(3).name,'registration_resampled','FLAIR_T1','Jacobian','num_CC_SEL_FLAIR.mat'));
volume_SEL_resampled_FLAIR = load(fullfile(subj_path_output_4,subj_output_list_4(3).name,'registration_resampled','FLAIR_T1','Jacobian','volume.mat'));
catch
    CC_SEL_resampled_FLAIR.num_CC_SEL_FLAIR = NaN;
    volume_SEL_resampled_FLAIR.volume = NaN;    
end
resampled_FLAIR(1,k) = CC_SEL_resampled_FLAIR.num_CC_SEL_FLAIR;
volume_resampled_FLAIR(1,k) = volume_SEL_resampled_FLAIR.volume*3;

try
CC_SEL_resampled_T2 = load(fullfile(subj_path_output_4,subj_output_list_4(3).name,'registration_resampled','T2_T1','Jacobian','num_CC_SEL_T2.mat'));
volume_SEL_resampled_T2 = load(fullfile(subj_path_output_4,subj_output_list_4(3).name,'registration_resampled','T2_T1','Jacobian','volume.mat'));
catch
    CC_SEL_resampled_T2.num_CC_SEL_T2 = NaN;
    volume_SEL_resampled_T2.volume = NaN;    
end
resampled_T2(1,k) = CC_SEL_resampled_T2.num_CC_SEL_T2;
volume_resampled_T2(1,k) = volume_SEL_resampled_T2.volume*3;

k = k+1;
end

result_sienapd = [sienapd_FLAIR ; volume_sienapd_FLAIR ; sienapd_T2 ; volume_sienapd_T2];
result_robust = [robust_FLAIR ; volume_robust_FLAIR ; robust_T2 ; volume_robust_T2];
result_resampled_FLAIR = [robust_FLAIR ; volume_robust_FLAIR ; resampled_FLAIR ; volume_resampled_FLAIR];
result_resampled_T2 = [robust_T2 ; volume_robust_T2 ; resampled_T2 ; volume_resampled_T2];

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


%% Analisi longitudinale
base_directory = 'F:\Utente\TESI';

output_path=fullfile(base_directory,'output_longitudinal_4');
list_output=dir(output_path);
dim=length(list_output)-2;

longitudinal_FLAIR_SEL = zeros(3,dim);
longitudinal_T2_SEL = zeros(3,dim);

longitudinal_FLAIR_volume = zeros(3,dim);
longitudinal_T2_volume = zeros(3,dim);
k = 1;
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
CC_SEL_1_FLAIR = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','num_CC_SEL_1.mat'));
volume_1_FLAIR = load(fullfile(subj_path_output_4,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','volume_1.mat'));
CC_SEL_2_FLAIR = load(fullfile(subj_path_output_4,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','num_CC_SEL_2.mat'));
volume_2_FLAIR = load(fullfile(subj_path_output_4,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','volume_2.mat'));
CC_SEL_3 = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','num_CC_SEL_3.mat'));
volume_3 = load(fullfile(subj_path_output,subj_output_list(3).name,'registration_longitudinal','T2_T1','Jacobian','volume_3.mat'));

catch
    CC_SEL_1_FLAIR.num_CC_SEL_1 = NaN;
    volume_1_FLAIR.volume_1 = NaN;
    CC_SEL_2_FLAIR.num_CC_SEL_2 = NaN;
    volume_2_FLAIR.volume_2 = NaN;
    CC_SEL_3.num_CC_SEL_3 = NaN;
    volume_3.volume_3 = NaN;
end

longitudinal_T2_SEL(1,k) = CC_SEL_1_FLAIR.num_CC_SEL_1;
longitudinal_T2_SEL(2,k) = CC_SEL_2_FLAIR.num_CC_SEL_2;
longitudinal_T2_SEL(3,k) = CC_SEL_3.num_CC_SEL_3;

longitudinal_T2_volume(1,k) = volume_1_FLAIR.volume_1;
longitudinal_T2_volume(2,k) = volume_2_FLAIR.volume_2;
longitudinal_T2_volume(3,k) = volume_3.volume_3;

k = k+1;
end

%save(fullfile(output_summury,'result_sienapd'), 'result_sienapd');
%save(fullfile(output_summury,'result_robust'), 'result_robust');
%save(fullfile(output_summury,'result_resampled'), 'result_resampled');
nomi_2 = char('baseline-I','I-II','II-followup');
figure
boxplot([longitudinal_FLAIR_volume(1,:)' longitudinal_FLAIR_volume(2,:)' longitudinal_FLAIR_volume(3,:)'],nomi_2)
ylabel('volume SEL identificate','FontSize',18,'Interpreter','latex')

nomi_2 = char('baseline-I','I-II','II-followup');
figure
boxplot([longitudinal_FLAIR_SEL(1,:)' longitudinal_FLAIR_SEL(2,:)' longitudinal_FLAIR_SEL(3,:)'],nomi_2)
ylabel('numero SEL identificate','FontSize',18,'Interpreter','latex')


%% RISULTATI SIENA
%Siena
image = char('FLAIR','T2-w');

figure
boxplot([result_sienapd(1,:)' result_sienapd(3,:)'],image)
ylabel('numero SEL identificate','FontSize',18,'Interpreter','latex')
ylim([0 15])

figure
boxplot([result_sienapd(2,:)' result_sienapd(4,:)'],image)
ylabel('volume SEL identificate','FontSize',18,'Interpreter','latex')

% Correlazione di Spearman e p-value
siena_correlazione = [result_sienapd(1,:)' result_sienapd(3,:)'];
[R_siena,coeff_p_value_siena] = corr(siena_correlazione,'Type','Spearman');

G = [result_sienapd(1,:)'];
p_est = ((G'*G)^(-1))*G'*result_sienapd(3,:)';
m = p_est(1);

figure1 = figure;
axes1 = axes('Parent',figure1);
hold(axes1,'on');
plot(result_sienapd(1,:)',m*result_sienapd(1,:),'DisplayName','retta di regressione','Color',[1 0 0]);
scatter(result_sienapd(1,:)', result_sienapd(3,:)','b','DisplayName','soggetto')
ylabel('T2-w','FontSize',16,'Interpreter','latex','Rotation',0);
xlabel('FLAIR','FontSize',16,'Interpreter','latex');
xlim(axes1,[0 15]);
ylim(axes1,[0 15]);
grid(axes1,'on');
hold(axes1,'off');
set(axes1,'FontSize',12,'TickLabelInterpreter','latex','XMinorTick','on',...
    'YMinorTick','on');
legend1 = legend(axes1,'show');
set(legend1,'Location','southeast','Interpreter','latex','FontSize',12);



x = [1];
vals1 = [dim1; dim2];

figure1 = figure;
axes1 = axes('Parent',figure1);
hold(axes1,'on');
bar1 = bar(x,vals1,'LineWidth',1);
set(bar1(2),'DisplayName','T2-w');
set(bar1(1),'DisplayName','FLAIR');
text('Parent',axes1,'VerticalAlignment','bottom',...
    'HorizontalAlignment','center',...
    'String','25',...
    'Position',[0.857142857142857 25 0], ...
    'Interpreter','latex');
text('Parent',axes1,'VerticalAlignment','bottom',...
    'HorizontalAlignment','center',...
    'String','29',...
    'Position',[1.14285714285714 29 0], ...
    'Interpreter','latex');
ylabel('Soggetti','FontSize',18,'Interpreter','latex');
box(axes1,'on');
grid(axes1,'on');
hold(axes1,'off');
set(axes1,'XTick',1,'XTickLabel',...
    {'SIENA','FontSize',18,'Interpreter','latex'});
legend1 = legend(axes1,'show');
set(legend1,'Location','northwest','Interpreter','latex','FontSize',12);
ylim([0 43])

%% Risultati FreeSurfer
image = char('FLAIR','T2-w');

figure
boxplot([result_robust(1,:)' result_robust(3,:)'],image)
ylabel('numero SEL identificate','FontSize',18,'Interpreter','latex')
ylim([0 15])

figure
boxplot([result_robust(2,:)' result_robust(4,:)'],image)
ylabel('volume SEL identificate','FontSize',18,'Interpreter','latex')

% Correlazione di Pearson e p-value
robust_correlazione = [result_robust(1,:)' result_robust(3,:)'];
[R_robust,coeff_p_value_robust] = corr(robust_correlazione,'Type','Spearman');

G = [result_robust(1,:)'];
p_est = ((G'*G)^(-1))*G'*result_robust(3,:)';
m = p_est(1);


figure1 = figure;
axes1 = axes('Parent',figure1);
hold(axes1,'on');
plot(result_robust(1,:)',m*result_robust(1,:),'DisplayName','retta di regressione','Color',[1 0 0]);
scatter(result_robust(1,:)', result_robust(3,:)','b','DisplayName','soggetto')
ylabel('T2-w','FontSize',16,'Interpreter','latex','Rotation',0);
xlabel('FLAIR','FontSize',16,'Interpreter','latex');
xlim(axes1,[0 15]);
ylim(axes1,[0 15]);
grid(axes1,'on');
hold(axes1,'off');
set(axes1,'FontSize',12,'TickLabelInterpreter','latex','XMinorTick','on',...
    'YMinorTick','on');
legend1 = legend(axes1,'show');
set(legend1,'Location','southeast','Interpreter','latex','FontSize',12);



x = [1];
vals1 = [dim3; dim4];

figure1 = figure;
axes1 = axes('Parent',figure1);
hold(axes1,'on');
bar1 = bar(x,vals1,'LineWidth',1);
set(bar1(2),'DisplayName','T2-w');
set(bar1(1),'DisplayName','FLAIR');
text('Parent',axes1,'VerticalAlignment','bottom',...
    'HorizontalAlignment','center',...
    'String','27',...
    'Position',[0.857142857142857 27 0], ...
    'Interpreter','latex');
text('Parent',axes1,'VerticalAlignment','bottom',...
    'HorizontalAlignment','center',...
    'String','31',...
    'Position',[1.14285714285714 31 0], ...
    'Interpreter','latex');
ylabel('Soggetti','FontSize',18,'Interpreter','latex');
box(axes1,'on');
grid(axes1,'on');
hold(axes1,'off');
set(axes1,'XTick',1,'XTickLabel',...
    {'FreeSurfer','FontSize',18,'Interpreter','latex'});
legend1 = legend(axes1,'show');
set(legend1,'Location','northwest','Interpreter','latex','FontSize',12);
ylim([0 43])

%% Resampled T2

image = char('1x1x1 mm','1x1x3 mm');

figure
boxplot([result_resampled_T2(1,:)' result_resampled_T2(3,:)'],image)
ylabel('numero SEL identificate','FontSize',18,'Interpreter','latex')
ylim([0 15])

figure
boxplot([result_resampled_T2(2,:)' result_resampled_T2(4,:)'],image)
ylabel('volume SEL identificate','FontSize',18,'Interpreter','latex')

% Correlazione di Pearson e p-value
resampled_T2_correlazione = [result_resampled_T2(1,:)' result_resampled_T2(3,:)'];
[R_res_T2,coeff_p_value_res_T2] = corr(resampled_T2_correlazione,'Type','Spearman');

G = result_resampled_T2(1,:)';
p_est = ((G'*G)^(-1))*G'*result_resampled_T2(3,:)';
m = p_est(1);

figure1 = figure;
axes1 = axes('Parent',figure1);
hold(axes1,'on');
plot(result_resampled_T2(1,:)',m*result_resampled_T2(1,:),'DisplayName','retta di regressione','Color',[1 0 0]);
scatter(result_resampled_T2(1,:)', result_resampled_T2(3,:)','b','DisplayName','soggetto')
ylabel('1x1x3 mm','FontSize',16,'Interpreter','latex','Rotation',90);
xlabel('1x1x1 mm','FontSize',16,'Interpreter','latex');
xlim(axes1,[0 15]);
ylim(axes1,[0 15]);
grid(axes1,'on');
hold(axes1,'off');
set(axes1,'FontSize',12,'TickLabelInterpreter','latex','XMinorTick','on',...
    'YMinorTick','on');
legend1 = legend(axes1,'show');
set(legend1,'Location','northeast','Interpreter','latex','FontSize',12);



x = [1];
vals1 = [dim4; dim6];

figure1 = figure;
axes1 = axes('Parent',figure1);
hold(axes1,'on');
bar1 = bar(x,vals1,'LineWidth',1);
set(bar1(2),'DisplayName','1x1x3 mm');
set(bar1(1),'DisplayName','1x1x1 mm');
text('Parent',axes1,'VerticalAlignment','bottom',...
    'HorizontalAlignment','center',...
    'String','31',...
    'Position',[0.857142857142857 31 0], ...
    'Interpreter','latex');
text('Parent',axes1,'VerticalAlignment','bottom',...
    'HorizontalAlignment','center',...
    'String','27',...
    'Position',[1.14285714285714 27 0], ...
    'Interpreter','latex');
ylabel('Soggetti','FontSize',18,'Interpreter','latex');
box(axes1,'on');
grid(axes1,'on');
hold(axes1,'off');
set(axes1,'XTick',1,'XTickLabel',...
    {'T2-w','FontSize',18,'Interpreter','latex'});
legend1 = legend(axes1,'show');
set(legend1,'Location','northwest','Interpreter','latex','FontSize',12);
ylim([0 43])

%% Resampled FLAIR
resampled_FLAIR_copia = resampled_FLAIR;
resampled_FLAIR_copia(22:10:32) = [];
volume_resampled_FLAIR_copia = volume_resampled_FLAIR;
volume_resampled_FLAIR_copia(22:10:32) = [];
robust_FLAIR_copia = robust_FLAIR;
robust_FLAIR_copia(22:10:32) = [];
volume_robust_FLAIR_copia = volume_robust_FLAIR;
volume_robust_FLAIR_copia(22:10:32) = [];
result_resampled_FLAIR_copia = [robust_FLAIR_copia ; volume_robust_FLAIR_copia ; resampled_FLAIR_copia ; volume_resampled_FLAIR_copia];
 

image = char('1x1x1 mm','1x1x3 mm');
figure
boxplot([result_resampled_FLAIR_copia(1,:)' result_resampled_FLAIR_copia(3,:)'],image)
ylabel('numero SEL identificate','FontSize',18,'Interpreter','latex')
ylim([0 15])

figure
boxplot([result_resampled_FLAIR_copia(2,:)' result_resampled_FLAIR_copia(4,:)'],image)
ylabel('volume SEL identificate','FontSize',18,'Interpreter','latex')

% Correlazione di Pearson e p-value
resampled_FLAIR_correlazione = [result_resampled_FLAIR_copia(1,:)' result_resampled_FLAIR_copia(3,:)'];
[R_res_FLAIR,coeff_p_value_res_FLAIR] = corr(resampled_FLAIR_correlazione);

G = result_resampled_FLAIR_copia(1,:)';
p_est = ((G'*G)^(-1))*G'*result_resampled_FLAIR_copia(3,:)';
m = p_est(1);

figure1 = figure;
axes1 = axes('Parent',figure1);
hold(axes1,'on');
plot(result_resampled_FLAIR_copia(1,:)',m*result_resampled_FLAIR_copia(1,:),'DisplayName','retta di regressione','Color',[1 0 0]);
scatter(result_resampled_FLAIR_copia(1,:)', result_resampled_FLAIR_copia(3,:)','b','DisplayName','soggetto')
ylabel('1x1x3 mm','FontSize',16,'Interpreter','latex','Rotation',90);
xlabel('1x1x1 mm','FontSize',16,'Interpreter','latex');
xlim(axes1,[0 15]);
ylim(axes1,[0 15]);
grid(axes1,'on');
hold(axes1,'off');
set(axes1,'FontSize',12,'TickLabelInterpreter','latex','XMinorTick','on',...
    'YMinorTick','on');
legend1 = legend(axes1,'show');
set(legend1,'Location','northeast','Interpreter','latex','FontSize',12);


subj_with_SEL_robust_FLAIR_copia = find(robust_FLAIR_copia);
dim3_copia = size(subj_with_SEL_robust_FLAIR_copia);
dim3_copia = dim3_copia(2);

subj_with_SEL_resampled_FLAIR_copia = find(resampled_FLAIR_copia);
dim5_copia = size(subj_with_SEL_resampled_FLAIR_copia);
dim5_copia = dim5_copia(2);


x = [1];
vals1 = [dim3_copia; dim5_copia];

figure1 = figure;
axes1 = axes('Parent',figure1);
hold(axes1,'on');
bar1 = bar(x,vals1,'LineWidth',1);
set(bar1(2),'DisplayName','1x1x3 mm');
set(bar1(1),'DisplayName','1x1x1 mm');
text('Parent',axes1,'VerticalAlignment','bottom',...
    'HorizontalAlignment','center',...
    'String','25',...
    'Position',[0.857142857142857 25 0], ...
    'Interpreter','latex');
text('Parent',axes1,'VerticalAlignment','bottom',...
    'HorizontalAlignment','center',...
    'String','20',...
    'Position',[1.14285714285714 20 0], ...
    'Interpreter','latex');
ylabel('Soggetti','FontSize',18,'Interpreter','latex');
box(axes1,'on');
grid(axes1,'on');
hold(axes1,'off');
set(axes1,'XTick',1,'XTickLabel',...
    {'FLAIR','FontSize',18,'Interpreter','latex'});
legend1 = legend(axes1,'show');
set(legend1,'Location','northwest','Interpreter','latex','FontSize',12);
ylim([0 41])

%% Combinazione risultati

nomi_2 = char('FLAIR 1x1x1 mm','T2-w 1x1x1 mm','FLAIR 1x1x3 mm','T2-w 1x1x3 mm');
figure
boxplot([result_resampled_FLAIR(1,:)' result_resampled_T2(1,:)' result_resampled_FLAIR(3,:)' result_resampled_T2(3,:)'],nomi_2)
ylabel('numero SEL identificate','FontSize',18,'Interpreter','latex')
ylim([0 15])

figure
boxplot([result_resampled_FLAIR(2,:)' result_resampled_T2(2,:)' result_resampled_FLAIR(4,:)' result_resampled_T2(4,:)'],nomi_2)
ylabel('volume SEL identificate','FontSize',18,'Interpreter','latex')

x = [1 2]
vals2 = [dim1; dim3; dim5; dim1; dim3; dim5 ];
% Confronto FLAIR/T2 per ogni metodo

figure
b = bar(x,vals2);
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center','VerticalAlignment','bottom','Interpreter','latex')
xtips2 = b(2).XEndPoints;
ytips2 = b(2).YEndPoints;
labels2 = string(b(2).YData);
text(xtips2,ytips2,labels2,'HorizontalAlignment','center','VerticalAlignment','bottom','Interpreter','latex')
grid on
ylabel('numero soggetti con SEL','FontSize',16,'Interpreter','latex')
legend({'FLAIR','T2-w'},'Location','northwest','interpreter','latex','FontSize',12)
ylim([0 43])
ax = gca;
ax.XTick = [1 2 3]; 
ax.XTickLabels = {'SIENA','FreeSurfer','1x1x3 mm','FontSize',16,'Interpreter','latex'};
ax.XTickLabelRotation = 0;

x = [1];
vals1 = [dim3_copia; dim5_copia];

%% longitudinal analysis
clear all
close all
clc

%base_directory = '/nfsd/biopetmri/BACKUP/Users/Marco/3T_Verona/SEL_candidates';
base_directory = 'F:\Utente\TESI';

output_path_4=fullfile(base_directory,'output_longitudinal_4');
output_path_2=fullfile(base_directory,'output_longitudinal_2');

list_output_4=dir(output_path_4);
dim=length(list_output_4)-2;

list_output_2=dir(output_path_4);
dim=length(list_output_2)-2;


longitudinal_FLAIR = zeros(4,dim);
longitudinal_T2 = zeros(4,dim);

k = 1;
for t=3:1:length(list_output_4)

subjID_output_4 = list_output_4(t).name;
subj_path_output_4= fullfile(output_path_4, subjID_output_4);
subj_output_list_4=dir(subj_path_output_4);

subjID_output_2 = list_output_2(t).name;
subj_path_output_2= fullfile(output_path_2, subjID_output_4);
subj_output_list_2=dir(subj_path_output_2);



try
CC_SEL_1_FLAIR = load(fullfile(subj_path_output_4,subj_output_list_4(3).name,'registration_longitudinal','FLAIR_T1','Jacobian','num_CC_SEL_FLAIR.mat'));
volume_1_FLAIR = load(fullfile(subj_path_output_4,subj_output_list_4(3).name,'registration_longitudinal','FLAIR_T1','Jacobian','volume_SEL_FLAIR.mat'));
CC_SEL_2_FLAIR = load(fullfile(subj_path_output_2,subj_output_list_2(3).name,'registration_robust_template','FLAIR_T1','Jacobian','num_CC_SEL_FLAIR.mat'));
volume_2_FLAIR = load(fullfile(subj_path_output_2,subj_output_list_2(3).name,'registration_robust_template','FLAIR_T1','Jacobian','volume.mat'));

catch
   CC_SEL_1_FLAIR.num_CC_SEL_FLAIR = NaN;
   volume_1_FLAIR.volume_SEL_FLAIR = NaN;
   CC_SEL_2_FLAIR.num_CC_SEL_FLAIR = NaN;
   volume_2_FLAIR.volume = NaN;
   
   
end

longitudinal_FLAIR(1,k) = CC_SEL_1_FLAIR.num_CC_SEL_FLAIR;
longitudinal_FLAIR(2,k) = volume_1_FLAIR.volume_SEL_FLAIR;
longitudinal_FLAIR(3,k) = CC_SEL_2_FLAIR.num_CC_SEL_FLAIR;
longitudinal_FLAIR(4,k) = volume_2_FLAIR.volume;

try
CC_SEL_1_T2 = load(fullfile(subj_path_output_4,subj_output_list_4(3).name,'registration_longitudinal','T2_T1','Jacobian','num_CC_SEL_T2.mat'));
volume_1_T2 = load(fullfile(subj_path_output_4,subj_output_list_4(3).name,'registration_longitudinal','T2_T1','Jacobian','volume_SEL_T2.mat'));
CC_SEL_2_T2 = load(fullfile(subj_path_output_2,subj_output_list_2(3).name,'registration_robust_template','T2_T1','Jacobian','num_CC_SEL_T2.mat'));
volume_2_T2 = load(fullfile(subj_path_output_2,subj_output_list_2(3).name,'registration_robust_template','T2_T1','Jacobian','volume.mat'));

catch
    CC_SEL_1_T2.num_CC_SEL_T2 = NaN;
    volume_1_T2.volume_SEL_T2 = NaN;
    CC_SEL_2_T2.num_CC_SEL_T2 = NaN;
    volume_2_T2.volume = NaN;
end

longitudinal_T2(1,k) = CC_SEL_1_T2.num_CC_SEL_T2;
longitudinal_T2(2,k) = volume_1_T2.volume_SEL_T2;
longitudinal_T2(3,k) = CC_SEL_2_T2.num_CC_SEL_T2;
longitudinal_T2(4,k) = volume_2_T2.volume;

k = k+1;
end

%% FLAIR

nomi_3 = char('2-timepoint','4-timepoint');
figure
boxplot([longitudinal_FLAIR(3,:)' longitudinal_FLAIR(1,:)'],nomi_3)
ylabel('numero SEL identificate','FontSize',18,'Interpreter','latex')
ylim([0 15])

long_T2_correlazione = [longitudinal_FLAIR(3,:)' longitudinal_FLAIR(1,:)'];
[R_long_T2,coeff_p_value_long_T2] = corr(long_T2_correlazione,'Type','Spearman');

G = longitudinal_FLAIR(1,:)';
p_est = ((G'*G)^(-1))*G'*longitudinal_FLAIR(3,:)';
m = p_est(1);

figure1 = figure;
axes1 = axes('Parent',figure1);
hold(axes1,'on');
plot(longitudinal_FLAIR(1,:)',m*longitudinal_FLAIR(1,:)','DisplayName','retta di regressione','Color',[1 0 0]);
scatter(longitudinal_FLAIR(1,:)', longitudinal_FLAIR(3,:)','b','DisplayName','soggetto')
ylabel('2-timepoint','FontSize',16,'Interpreter','latex','Rotation',90);
xlabel('4-timepoint','FontSize',16,'Interpreter','latex');
xlim(axes1,[0 15]);
ylim(axes1,[0 15]);
grid(axes1,'on');
hold(axes1,'off');
set(axes1,'FontSize',12,'TickLabelInterpreter','latex','XMinorTick','on',...
    'YMinorTick','on');
legend1 = legend(axes1,'show');
set(legend1,'Location','northeast','Interpreter','latex','FontSize',12);






%% T2

nomi_3 = char('2-timepoint','4-timepoint');
figure
boxplot([longitudinal_T2(3,:)' longitudinal_T2(1,:)'],nomi_3)
ylabel('numero SEL identificate','FontSize',18,'Interpreter','latex')
ylim([0 15])

long_T2_correlazione = [longitudinal_T2(3,:)' longitudinal_T2(1,:)'];
[R_long_T2,coeff_p_value_long_T2] = corr(long_T2_correlazione,'Type','Spearman');

G = longitudinal_T2(1,:)';
p_est = ((G'*G)^(-1))*G'*longitudinal_T2(3,:)';
m = p_est(1);

figure1 = figure;
axes1 = axes('Parent',figure1);
hold(axes1,'on');
plot(longitudinal_T2(1,:)',m*longitudinal_T2(1,:)','DisplayName','retta di regressione','Color',[1 0 0]);
scatter(longitudinal_T2(1,:)', longitudinal_T2(3,:)','b','DisplayName','soggetto')
ylabel('2-timepoint','FontSize',16,'Interpreter','latex','Rotation',90);
xlabel('4-timepoint','FontSize',16,'Interpreter','latex');
xlim(axes1,[0 15]);
ylim(axes1,[0 15]);
grid(axes1,'on');
hold(axes1,'off');
set(axes1,'FontSize',12,'TickLabelInterpreter','latex','XMinorTick','on',...
    'YMinorTick','on');
legend1 = legend(axes1,'show');
set(legend1,'Location','northeast','Interpreter','latex','FontSize',12);



