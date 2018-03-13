%% creating labels: Y_Train
perceptual(1,:)=[0.0000 0.0991 0.3770 1.4759 1.6182 2.2060 2.3387 2.4168 2.4550 2.5880 2.2610];
perceptual(2,:)=[0.000 -0.353 -0.139  0.525  1.122  1.838  1.667  1.780  2.655  2.041  2.146];
perceptual(3,:)=[0.0000  0.2443 0.1490  0.8091  1.2449  1.8647  1.7564  1.8671  2.4156  2.4119  2.1792]; 
perceptual(4,:)=[0.000 -0.525  0.119  0.804  1.281  1.704  1.618  1.458  2.058  1.631  1.522];
perceptual(5,:)=[0.000 -0.530 -0.309 0.152 0.310 0.757 0.478 0.751 1.075 0.946 0.732];

for i = 1:5
    perc(i,:)=(perceptual(i,:)-min(perceptual(i,:)))/(max(perceptual(i,:))-min(perceptual(i,:)));
end

mean_perc=mean(perc);
%% Get Y_Train
train_label=[mean_perc mean_perc mean_perc mean_perc mean_perc mean_perc];


%% Get X_Train
trainvidN=66;
train_tra=[];
train_hog=[];
train_hof=[];
train_x=[];
train_y=[];

curDir=pwd;
cd('train/FV');
for i=1:trainvidN
    fisher=load(['Fisher',int2str(i),'.mat']);
    fisher=fisher.res;
    for j =1:5
        train_tra(:,i)=fisher.fvt{1};
        train_hog(:,i)=fisher.fvt{2};
        train_hof(:,i)=fisher.fvt{3};
        train_x(:,i)=fisher.fvt{4};
        train_y(:,i)=fisher.fvt{5};
    end   
end
cd(curDir);
AllTrainF=[train_tra;train_hog;train_hof;train_x;train_y];
%% get X_test
testvidN=66;
test_tra=[];
test_hog=[];
test_hof=[];
test_x=[];
test_y=[];

%cd('test/FV');
cd ('test/66cotonTrain_66silkTest/FV');

for i=1:testvidN %1:testvidN
    k=i+66;
    %k=i;
    fisher=load(['Fisher',int2str(k),'.mat']);
    fisher=fisher.res;
    for j =1:5
        test_tra(:,i)=fisher.fvt{1};
        test_hog(:,i)=fisher.fvt{2};
        test_hof(:,i)=fisher.fvt{3};
        test_x(:,i)=fisher.fvt{4};
        test_y(:,i)=fisher.fvt{5};
    end   
end
AllTestF=[test_tra;test_hog;test_hof;test_x;test_y];






%% Build Model
% Train

% If 5-fold cross validate: 
% X: row - N of train points; col - dimensions
% Y: row - N of train points; col-1
%[Mdl,FitInfo]=fitrlinear(AllTrainF',train_label');

% Find hyperparameters that minimize five-fold cross validation loss 
% by using automatic hyperparameter optimization.

% hyperopts = struct('AcquisitionFunctionName','expected-improvement-plus');
% [Mdl,FitInfo,HyperparameterOptimizationResults] = fitrlinear(AllTrainF',train_label',...
%     'OptimizeHyperparameters','auto',...
%     'HyperparameterOptimizationOptions',hyperopts);
% 
% 
% % Save Model
% outputName=['RegressionModel_66CottonTrain.mat'];
% output = fullfile(outputName);
% AllTrainF_output=AllTrainF';
% trainlabel_output=train_label';
% save(output,'Mdl','FitInfo','HyperparameterOptimizationResults','AllTrainF_output','trainlabel_output');



%% load model 
% The model has already been built
a = load('RegressionModel_66CottonTrain.mat');
AllTrainF_output = a.AllTrainF_output;
FitInfo = a.FitInfo;
HyperparameterOptimizationResults = a.HyperparameterOptimizationResults;
Mdl = a.Mdl;
trainlabel_output = a.trainlabel_output;





%% Plot results of ml model: 11 test videos
YHat=[];
for j =1:testvidN
    YHat(j) = predict(Mdl,AllTestF(:,j)');
end

% Normalize between 0~1
mini=min(YHat);
maxi=max(YHat);
YHat=(YHat-mini)/(maxi-mini);


plot(YHat)
hold on
plot(mean_perc)





% Plot results of ml model: 66 test videos
%
% YHat=[];
% for j =1:testvidN
%     YHat(j) = predict(Mdl,AllTestF(:,j)');
% end
% 
% FinalPre=[];
% FinalPre(1,:)=YHat(1:11);
% FinalPre(2,:)=YHat(12:22);
% FinalPre(3,:)=YHat(23:33);
% FinalPre(4,:)=YHat(34:44);
% FinalPre(5,:)=YHat(45:55);
% FinalPre(6,:)=YHat(56:66);
%     
% mini=min(min(FinalPre));
% maxi=max(max(FinalPre));
% FinalPre=(FinalPre-mini)/(maxi-mini);
% plot(mean(FinalPre))
% hold on
% plot(mean_perc)
% save('Train_66Cotton_Test_66Silk_ScrambledModel_PredictionResults.mat','FinalPre','mean_perc');

%% Random Model
trainsize=size(AllTrainF');
randomtrain=rand(1, trainsize(1)*trainsize(2));
randomtrain = reshape(randomtrain, trainsize(1), trainsize(2));


hyperopts_ran = struct('AcquisitionFunctionName','expected-improvement-plus');
[Mdl_ran,FitInfo_ran,HyperparameterOptimizationResults_ran] = fitrlinear(randomtrain,train_label',...
    'OptimizeHyperparameters','auto',...
    'HyperparameterOptimizationOptions',hyperopts_ran);


% Save Model
outputName=['RandomModel_66CottonTrain.mat'];
output = fullfile(outputName);
trainlabel_output=train_label';
save(output,'Mdl_ran','FitInfo_ran','HyperparameterOptimizationResults_ran','randomtrain','trainlabel_output');



% Plot results of random model
YHat_ran=[];
for j =1:testvidN
    YHat_ran(j) = predict(Mdl_ran,AllTestF(:,j)');
end

% Normalize between 0~1
mini=min(YHat_ran);
maxi=max(YHat_ran);
YHat_ran=(YHat_ran-mini)/(maxi-mini);


plot(YHat_ran)
hold on
plot(mean_perc)
save('randomModel_11silkasTest.mat','YHat','mean_perc');





%% Test
% matrix
YHat=[];
for j =1:testvidN
    YHat(j) = predict(Mdl,AllTestF(:,j)');
end

FinalPre=[];
FinalPre(1,:)=YHat(1:11);
FinalPre(2,:)=YHat(12:22);
FinalPre(3,:)=YHat(23:33);
FinalPre(4,:)=YHat(34:44);
FinalPre(5,:)=YHat(45:55);
FinalPre(6,:)=YHat(56:66);
    
mini=min(min(FinalPre));
maxi=max(max(FinalPre));
FinalPre=(FinalPre-mini)/(maxi-mini);
plot(mean(FinalPre))
hold on
plot(mean_perc)
save('1.mat','FinalPre','mean_perc');





save('OldTrain_66Cotton_OldTest_66Silk.mat','FinalPre','mean_old_silk_perc');




%% vector
YHat=[];
for j =1:testvidN
    YHat(j) = predict(Mdl,AllTestF(:,j)');
end

% Normalize between 0~1
mini=min(YHat);
maxi=max(YHat);
YHat=(YHat-mini)/(maxi-mini);


plot(YHat)
hold on
plot(mean_perc)
save('1.mat','YHat','mean_perc');
