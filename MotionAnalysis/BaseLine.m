%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Main code for motion analysis.
%
% 11/08/2016 Wenyan Bi wrote it.

%==================== Initialization =====================================%
clc;clear all;
path=pwd;
addpath(path);
addpath(fullfile([path,'/yael_v438/matlab']));
run('vlfeat-0.9.20/toolbox/vl_setup');

trainvidN=66;
testvidN=66;
parameterN=11;

% 1. train gmm and get parameters
gmm=pretrain(trainvidN,256);
cd(path);

% 2. get fisher vecotrs for train videos
compute_fv('train',trainvidN);
cd(path);

% 3. get fisher vectors for test videos
compute_fv('test',testvidN);


%% creating labels: Y_Test (SILK)
clear silk_old_test silk_new_test
silk_old_test(1,:)=[0.11608345 0.00000000 0.007009173 0.05823825 0.2998117 0.5355441 0.7530146 0.6622004 0.7341844 0.6977236 1.0000000 0.7469739 0.7086805];
silk_old_test(2,:)=[0.00000000 0.16908009 0.071790532 0.15915754 0.3809989 0.5102330 0.7087143 0.7064424 0.7242941 0.7096673 1.0000000 0.9166018 0.8409515];
silk_old_test(3,:)=[0.00000000 0.04474190 0.040657886 0.14945605 0.5787906 0.6427037 0.8600574 0.9282904 0.9916141 1.0000000 0.9827338 0.9835664 0.8932265];
silk_old_test(4,:)=[0.04630758 0.00000000 0.013926910 0.22921527 0.5284890 0.6136571 0.8056437 0.7640462 0.8400824 0.8066325 0.9268898 1.0000000 0.9659406];
silk_old_test(5,:)=[0.11450121 0.09250751 0.000000000 0.25084860 0.5230090 0.7105730 0.8716477 0.7873085 0.8857489 0.9192812 1.0000000 0.9401923 0.9460716];

silk_old_test = [silk_old_test(:,1:2) silk_old_test(:,4:9) silk_old_test(:,11:13)];
silk_old_test = mean(silk_old_test);


% Get Y_Test
test_label = [silk_old_test silk_old_test silk_old_test silk_old_test silk_old_test silk_old_test];



%% creating labels: Y_Train (COTTON)
clear perc_old perc_new
perc_old(1,:)=[0.1382760 0.08633956 0.0000000 0.2994853 0.5326147 0.6405014 0.7867547 0.8759516 0.9565701 0.8708165 0.9304497 0.9753816 1.0000000];
perc_old(2,:)=[0.1188757 0.02886914 0.0000000 0.1819496 0.5284265 0.6446310 0.8428525 0.9525544 0.8613035 0.9502185 0.9569334 1.0000000 0.8850137];
perc_old(3,:)=[0.0000000 0.28443267 0.2042094 0.3598806 0.6796125 0.8239442 0.9616558 0.9241230 0.9518599 0.9700364 1.0000000 0.9518029 0.9847509]; 
perc_old(4,:)=[0.1176820 0.00000000 0.1435935 0.1807870 0.4982301 0.5447084 0.7011844 0.8291285 0.8468473 0.8257487 0.8616830 1.0000000 0.9139643];
perc_old(5,:)=[0.0000000 0.18547887 0.2516067 0.3183688 0.6175903 0.6201042 0.7292720 0.8960828 0.8263858 0.8782165 0.9836605 1.0000000 0.9810782];

perc_old = [perc_old(:,1:2) perc_old(:,4:9) perc_old(:,11:13)];
mean_perc_old=mean(perc_old);


% Get Y_Train
train_label=[mean_perc_old mean_perc_old mean_perc_old mean_perc_old mean_perc_old mean_perc_old];
%% Get X_Train
res_tra=[];
res_hog=[];
res_hof=[];
res_x=[];
res_y=[];

cd('train/FV');
for i=1:trainvidN
    fisher=load(['Fisher',int2str(i),'.mat']);
    fisher=fisher.res;
    
    res_tra(:,i)=fisher.fvt{1};
    res_hog(:,i)=fisher.fvt{2};
    res_hof(:,i)=fisher.fvt{3};
    res_x(:,i)=fisher.fvt{4};
    res_y(:,i)=fisher.fvt{5};
end
    
Allfeatures=[res_tra;res_hog;res_hof;res_x;res_y];


cd(path);

%% Train model
% Train
hyperopts = struct('AcquisitionFunctionName','expected-improvement-plus');
[Mdl,FitInfo,HyperparameterOptimizationResults] = fitrlinear(Allfeatures',train_label',...
    'OptimizeHyperparameters','auto',...
    'HyperparameterOptimizationOptions',hyperopts);
% % 
% % 
% % % Save Model
 outputName=['Revision_model_dt15frames_skip2frame.mat'];
 output = fullfile(outputName);
 AllTrainF_output=Allfeatures';
 trainlabel_output=train_label';
 save(output,'Mdl','FitInfo','HyperparameterOptimizationResults','AllTrainF_output','trainlabel_output');

%% load model :   If the model was already learned
% The model has already been built
% a = load('RegressionModel_110_scrambled_combined.mat');
% AllTrainF_output = a.AllTrainF_output;
% FitInfo = a.FitInfo;
% HyperparameterOptimizationResults = a.HyperparameterOptimizationResults;
% Mdl = a.Mdl;
% trainlabel_output = a.trainlabel_output;

%% Get Test
%cd('test/FV');
cd ('test/FV');
test_tra=[];
test_hog=[];
test_hof=[];
test_x=[];
test_y=[];

for i=1:testvidN
    k=66+i;
    fisher=load(['Fisher',int2str(k),'.mat']);
    fisher=fisher.res;
    
    test_tra(:,i)=fisher.fvt{1};
    test_hog(:,i)=fisher.fvt{2};
    test_hof(:,i)=fisher.fvt{3};
    test_x(:,i)=fisher.fvt{4};
    test_y(:,i)=fisher.fvt{5};
end
    
All_test_features=[test_tra;test_hog;test_hof;test_x;test_y];

%% % Test
YHat=[];
for j =1:testvidN
    YHat(j) = predict(Mdl,All_test_features(:,j)');
end


% Normalize between 0~1
FinalPre=[];
FinalPre(1,:)=YHat(1:11);
FinalPre(2,:)=YHat(12:22);
FinalPre(3,:)=YHat(23:33);
FinalPre(4,:)=YHat(34:44);
FinalPre(5,:)=YHat(45:55);
FinalPre(6,:)=YHat(56:66);


mini=min(min(FinalPre));
maxi=max(max(FinalPre));
FinalPre_mean=(FinalPre-mini)/(maxi-mini);


plot(mean(FinalPre_mean))
hold on
%plot(mean_perc)
plot(silk_old_test)
hold on
plot(mean(old))


save('Model_Predictions.mat','FinalPre','silk_old_test','FinalPre_mean');
