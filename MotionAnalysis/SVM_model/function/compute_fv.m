%% function compute_fv(train_or_test, train_vid, gmm, function_path, num_feats, feats_frame, samplingMethod)
% computer fisher vectors of the training and testing videos.
% 
% INPUTS
%  train_or_test     - 'train', 'test'
%  train_vid         - the number of vidoes
%  gmm               - the pre-trained gmm parameters
%  function_path     - the folder that contains this code
%  num_feats            - Set the number of dtf, used in the sampling.
%                         To use all the DTF features, set it to a negative
%                         value.
%  feats_frame          - How many frames is the dtf calculated from?
%                         This number must be the one used in the original
%                         dense Trajectoryory codes (defalut: 15).
%  samplingMethod       - 1)'random'; 
%                         2) 'linear'(default); 


% OUTPUTS
%  Fisher vector for each video
%
% -------------------------------------------------------------------------
% Wenyan Bi, 2016 [wb1918a@student.american.edu]
% Please email me if you find bugs, or have suggestions or questions
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function compute_fv(train_or_test, train_vid, gmm, function_path, num_feats, feats_frame, samplingMethod)

    curdir = pwd;
    fileFolder = [pwd, '/', train_or_test];
    
    addpath(fullfile([function_path,'/yael_v438/matlab']));
    run([function_path, '/vlfeat-0.9.20/toolbox/vl_setup']);

    %%
    pca_coeff = gmm.pca_coeff;
    w = gmm.w;
    mu = gmm.mu;
    sigma = gmm.sigma;

    %%
    params.feat_list={'Trajectory','HOG','HOF','MBHx','MBHy'};

    %%
    for j = 1:train_vid

        res.fvt = {};                   % fisher vector
        Trajectory_tmp = [];
        HOG_tmp = [];
        HOF_tmp = [];
        MBHx_tmp = [];
        MBHy_tmp = [];


        dtf_file_dir=[fileFolder, '/vid_',int2str(j)];
        dtf_file = [dtf_file_dir, '/vid_',int2str(j), '*'];
        
        dtf_file_HOG = [dtf_file_dir, '/HOG_',int2str(num_feats), '.mat'];
        dtf_file_HOF = [dtf_file_dir, '/HOF_',int2str(num_feats), '.mat'];
        dtf_file_MBHx = [dtf_file_dir, '/MBHx_',int2str(num_feats), '.mat'];
        dtf_file_MBHy = [dtf_file_dir, '/MBHy_',int2str(num_feats), '.mat'];
        dtf_file_Trajectory = [dtf_file_dir, '/Trajectory_',int2str(num_feats), '.mat'];
        
        
        if (isempty(dir(dtf_file_HOG))||isempty(dir(dtf_file_HOF))||isempty(dir(dtf_file_MBHx))||...
                isempty(dir(dtf_file_MBHy))||isempty(dir(dtf_file_Trajectory)))  
            
            [Trajectory,HOG,HOF,MBHx,MBHy] = extract_dtf_feat (dtf_file_dir, dtf_file, num_feats, feats_frame, samplingMethod);
            save(dtf_file_HOG,'HOG_tmp');
            save(dtf_file_HOF,'HOF_tmp');
            save(dtf_file_MBHx,'MBHx_tmp');
            save(dtf_file_MBHy,'MBHy_tmp');
            save(dtf_file_Trajectory,'Trajectory_tmp');
     
        else
            Trajectory = load(dtf_file_Trajectory);
            Trajectory = Trajectory.Trajectory_tmp;
            HOG = load(dtf_file_HOG);
            HOG = HOG.HOG_tmp;
            HOF = load(dtf_file_HOF);
            HOF = HOF.HOF_tmp;
            MBHx = load(dtf_file_MBHx);
            MBHx = MBHx.MBHx_tmp;            
            MBHy = load(dtf_file_MBHy);
            MBHy = MBHy.MBHy_tmp; 
        end
        
        
        % [wb]: Do PCA on train/test data to half-size original descriptors
        % After that, the dimensions of the subsampled features were reduced
        % to half of their original dimensions by doing PCA.
        disp(['Doing PCA dimensional deduction for vid',int2str(j)]);
        fprintf('\n');       
        Trajectory_tmp = pca_coeff{1} * Trajectory;
        HOG_tmp = pca_coeff{2} * HOG;
        HOF_tmp = pca_coeff{3} * HOF;
        MBHx_tmp = pca_coeff{4} * MBHx;
        MBHY_tmp = pca_coeff{5} * MBHy;


        disp(['Calculating FV for vid',int2str(j)]);
        fprintf('\n');  
        res.fvt{1} = fv(Trajectory_tmp,w{1},mu{1},sigma{1});
        res.fvt{2} = fv(HOG_tmp,w{2},mu{2},sigma{2});
        res.fvt{3} = fv(HOF_tmp,w{3},mu{3},sigma{3});
        res.fvt{4} = fv(MBHx_tmp,w{4},mu{4},sigma{4});
        res.fvt{5} = fv(MBHY_tmp,w{5},mu{5},sigma{5});


    outputFolder=[fileFolder, '/FV_', int2str(num_feats)];
    if (~exist(outputFolder, 'dir'))         % [wb]: Create the folder if it doesn't exist.
        mkdir(outputFolder);
    end

    outputName = [outputFolder, '/Fisher',int2str(j),'.mat'];
    save(outputName,'res');

    end   
end











