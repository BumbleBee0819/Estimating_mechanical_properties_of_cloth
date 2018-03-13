function gmm=pretrain(vid_num,K)

    % vid_num=11;  how many files in "GMM_FV_Train" 
    % params.K=256;  % how many clusters

    curdir=pwd;
    addpath(curdir);
    %%
    feat_list={'Traject','HOG','HOF','MBHx','MBHy'};
    % feat_len={30,96,108,96,96}; % length of features
    pca_feat={};
    fvt={};

    
    gmm.pca_coeff={};  
    gmm.w={};
    gmm.mu={};
    gmm.sigma={}

    %%
    Trajectory=[];
    HOG=[];
    HOF=[];
    MBHx=[];
    MBHy=[];
    cd('train');
    %%
    for j = 7:vid_num
        dtf_file=(['vid_',int2str(j)]);

        %% Extract features -- [ Trajectory,HOG,HOF,MBHx,MBHy ]
        disp(['Extracting dtf for vid',int2str(j)]);
        fprintf('\n'); 

        [Trajectory_tmp,HOG_tmp,HOF_tmp,MBHx_tmp,MBHy_tmp] = extract_dtf_feat(dtf_file,5000,'random');
        Trajectory=[Trajectory;Trajectory_tmp'];
        HOG=[HOG;HOG_tmp'];  % row is the data points; column is the dimension
        HOF=[HOF;HOF_tmp'];
        MBHx=[MBHx;MBHx_tmp'];
        MBHy=[MBHy;MBHy_tmp'];
    end 


    Trajectory=Trajectory';  %row is dimension; column is datapoints;
    HOG=HOG';
    HOF=HOF';
    MBHx=MBHx';
    MBHy=MBHy';
    
    cd(curdir);
    
    
    save('Trajectory.mat','Trajectory');
    save('HOG.mat','HOG');
    save('HOF.mat','HOF');
    save('MBHx.mat','MBHx');
    save('MBHy.mat','MBHy');
    
%     tmp_feature=load('Trajectory.mat');
%     Trajectory=tmp_feature.Trajectory;
%     tmp_feature=load('HOG.mat');
%     HOG=a.HOG;
%     tmp_feature=load('HOF.mat');
%     HOF=tmp_feature.HOF;
%     tmp_feature=load('MBHx.mat');
%     MBHx=tmp_feature.MBHx;
%     tmp_feature=load('MBHy.mat');
%     MBHy=tmp_feature.MBHy;


    %% PCA -- PCA_feats[reduce dimension by half], GMM, fisher_vector
    dtf_feat_num=length(feat_list);
    feats_train={Trajectory,HOG,HOF,MBHx,MBHy}; 

    
    for i=1:dtf_feat_num
        % Do PCA on train/test data to half-size original descriptors
        % After that, the dimensions of the subsampled features were reduced
        % to half of their original dimensions by doing PCA.
        disp(['Doing PCA for:',feat_list{i}]);
        fprintf('\n');       
        [pca_feat{i},gmm.pca_coeff{i}]=PCA_half(feats_train{i});


        disp(['Extracting FV for:', feat_list{i}]);
        fprintf('\n');  
        % Means matrix of GMM (d x K) in single/double format 
        % Variance matrix of GMM (d x K) in single/double format
        % Weights vector of GMM (1 x K) in single/double format
        [gmm.w{i},gmm.mu{i},gmm.sigma{i}]= yael_gmm (single(pca_feat{i}), K, 'niter', 500);
        outputName=['gmm',int2str(i),'.mat'];
        output = fullfile(outputName);
        save(output,'gmm');
    end
    
    cd (curdir);

    outputName='gmm.mat';
    output = fullfile(outputName);
    save(output,'gmm');

end
