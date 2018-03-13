function compute_fv(train_or_test,train_vid)
% train_vid: N of train vids
% train_or_test: 'train'/'test'

path=pwd;
addpath(path);
%addpath('yael_v438/matlab');
run('vlfeat-0.9.20/toolbox/vl_setup')

%%
trainpara=load('gmm.mat');
pca_coeff=trainpara.gmm.pca_coeff;
w=trainpara.gmm.w;
mu=trainpara.gmm.mu;
sigma=trainpara.gmm.sigma;

%%

cd(train_or_test);

%%
params.feat_list={'Traject','HOG','HOF','MBHx','MBHy'};
% feat_len={30,96,108,96,96}; % length of features



%%
for i = 1:train_vid
    
    if strcmp(train_or_test,'train')
        j = i;
    else
        j = i+66;
    end
    
    res.fvt={};  % fisher vector
    Trajectory_tmp=[];
    HOG_tmp=[];
    HOF_tmp=[];
    MBHx_tmp=[];
    MBHy_tmp=[];
    
    dtf_file=(['vid_',int2str(j)]);
    [Trajectory,HOG,HOF,MBHx,MBHy] = extract_dtf_feat(dtf_file,-1,'linear');

        % Do PCA on train/test data to half-size original descriptors
        % After that, the dimensions of the subsampled features were reduced
        % to half of their original dimensions by doing PCA.
        disp(['Calculating PCA for vid',int2str(j)]);
        fprintf('\n');       
        Trajectory_tmp = pca_coeff{1} * Trajectory;
        HOG_tmp=pca_coeff{2} * HOG;
        HOF_tmp=pca_coeff{3} * HOF;
        MBHx_tmp=pca_coeff{4} * MBHx;
        MBHY_tmp=pca_coeff{5} * MBHy;


        disp(['Extracting FV for vid',int2str(j)]);
        fprintf('\n');  
        res.fvt{1}=fv(Trajectory_tmp,w{1},mu{1},sigma{1});
        res.fvt{2}=fv(HOG_tmp,w{2},mu{2},sigma{2});
        res.fvt{3}=fv(HOF_tmp,w{3},mu{3},sigma{3});
        res.fvt{4}=fv(MBHx_tmp,w{4},mu{4},sigma{4});
        res.fvt{5}=fv(MBHY_tmp,w{5},mu{5},sigma{5});
  

outputName=['Fisher',int2str(j),'.mat'];
%output = fullfile(outputName);
output = fullfile('FV',outputName);
save(output,'res');

end   

cd (path);     
end











