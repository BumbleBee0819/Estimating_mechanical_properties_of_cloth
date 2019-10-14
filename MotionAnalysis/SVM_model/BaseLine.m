%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Main code for motion analysis.
%
% 11/08/2016 Wenyan Bi <wb1918a@student.american.edu> wrote it.




%==================== Initialization =====================================%
clc;clear all;

path = pwd;
function_path = fullfile([path,'/function']);

addpath(path);
addpath(function_path);
addpath(fullfile([function_path,'/yael_v438/matlab']));
run([function_path, '/vlfeat-0.9.20/toolbox/vl_setup']);

%%
trainVidN = 66;
testVidN = 66;
parameterN = 11;

feats_frame = 15;
num_feats = 5000;
samplingMethod = 'random';
gmm_k_cluster = 256;


% [wb] 1. train gmm and get the gmm parameters
gmm = pretrain(trainVidN, gmm_k_cluster, num_feats, feats_frame, samplingMethod, 'train');

% [wb] 2. get fisher vecotrs for train videos
compute_fv('train', trainVidN, gmm, function_path, num_feats, feats_frame, samplingMethod);

% [wb] 3. get fisher vectors for test videos
compute_fv('test',testVidN, gmm, function_path, num_feats, feats_frame, samplingMethod);


%% creating labels: Y_Test (SILK)
test_labels = load(['human_perceptual_test.mat']);
test_labels = test_labels.silk_old_test;
test_label = repmat(test_labels, testVidN/parameterN, 1);
test_label = reshape(test_label, 1, []);

%% creating labels: Y_Train (COTTON)
training_labels = load(['human_perceptual_train.mat']);
training_labels = training_labels.mean_perc_old;
train_label = repmat(training_labels, testVidN/parameterN, 1);
train_label = reshape(train_label, 1, []);

%% Get X_Train
res_tra=[];
res_hog=[];
res_hof=[];
res_x=[];
res_y=[];

train_fv_folder = [path, '/train/FV_', int2str(num_feats)];

for i = 1:trainVidN
    fisher = load([train_fv_folder, '/Fisher',int2str(i),'.mat']);
    fisher = fisher.res;
    
    res_tra(:,i) = fisher.fvt{1};
    res_hog(:,i) = fisher.fvt{2};
    res_hof(:,i) = fisher.fvt{3};
    res_x(:,i) = fisher.fvt{4};
    res_y(:,i) = fisher.fvt{5};
end
    
All_train_features = [res_tra;res_hog;res_hof;res_x;res_y];


%% [wb]: Train model
% [wb]: Train
 modelFolder=[path, '/myModel'];
 if (~exist(modelFolder, 'dir'))         % [wb]: Create the folder if it doesn't exist.
     mkdir(modelFolder);
 end
 
 modelName=[modelFolder, '/myModel.mat'];
 
 if isempty(dir(modelName))
     hyperopts = struct('AcquisitionFunctionName','expected-improvement-plus');
     [Mdl,FitInfo,HyperparameterOptimizationResults] = fitrlinear(All_train_features',train_label',...
         'OptimizeHyperparameters','auto',...
         'HyperparameterOptimizationOptions',hyperopts);
     % [wb]: Save the model
     AllTrainF_output = All_train_features';
     trainlabel_output=train_label';
     save(modelName,'Mdl','FitInfo','HyperparameterOptimizationResults','AllTrainF_output','trainlabel_output');
 else
     % load model if the model has already been built
     tmp = load(modelName);
     AllTrainF_output = tmp.AllTrainF_output;
     FitInfo = tmp.FitInfo;
     HyperparameterOptimizationResults = tmp.HyperparameterOptimizationResults;
     Mdl = tmp.Mdl;
     trainlabel_output = tmp.trainlabel_output;
     warning ('The model has already been trained, successfully loaded ...');
 end
 
 
 

%% [wb]: Test model

test_fv_folder = [path, '/test/FV_', int2str(num_feats)];

test_tra=[];
test_hog=[];
test_hof=[];
test_x=[];
test_y=[];

for i = 1:testVidN
    fisher = load([test_fv_folder, '/Fisher',int2str(i),'.mat']);
    fisher = fisher.res;
    
    test_tra(:,i) = fisher.fvt{1};
    test_hog(:,i) = fisher.fvt{2};
    test_hof(:,i) = fisher.fvt{3};
    test_x(:,i) = fisher.fvt{4};
    test_y(:,i) = fisher.fvt{5};
end
    
All_test_features=[test_tra;test_hog;test_hof;test_x;test_y];

%% % Test
YHat=[];
for j = 1:testVidN
    YHat(j) = predict(Mdl,All_test_features(:,j)');
end


% Normalize between 0~1
FinalPre=[];
for i = 1: testVidN/parameterN
    FinalPre(i,:) = YHat((i-1)*parameterN+1: parameterN*i);
end

mini=min(min(FinalPre));
maxi=max(max(FinalPre));
FinalPre_mean=(FinalPre-mini)/(maxi-mini);


plot(mean(FinalPre_mean))
hold on
plot(test_labels)


modelResult=[modelFolder, '/myModel_Result.mat'];
save(modelResult,'FinalPre','test_labels','FinalPre_mean');
