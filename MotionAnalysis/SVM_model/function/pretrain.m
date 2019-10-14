%% function gmm = pretrain(vid_num, K, num_feats, feats_frame, samplingMethod, video_folder)
% Train the gmm model
% 
% INPUTS
%  vid_num             - how many files in "GMM_FV_Train" 
%  K                   - how many clusters
%  num_feats           - Set the number of dtf, used in the sampling.
%                        To use all the DTF features, set it to a negative
%                        value.
%  feats_frame         - How many frames is the dtf calculated from?
%                        This number must be the one used in the original
%                        dense trajectory codes (defalut: 15).
%  samplingMethod      - 1)'random'; 
%                        2) 'linear'(default); 
%  video_folder        - the stimuli folder: 'train'/'test'

% OUTPUTS
%  <gmm_parameters_Trajectory.mat>
%  <gmm_parameters_HOF.mat>
%  <gmm_parameters_HOG.mat>
%  <gmm_parameters_MBHx.mat>
%  <gmm_parameters_MBHy.mat>
%  <gmm.mat> that contains the gmm parameters: pca_coeff, w, mu, sigm
%
% -------------------------------------------------------------------------
% Wenyan Bi, 2016 [wb1918a@student.american.edu]
% Please email me if you find bugs, or have suggestions or questions
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function gmm = pretrain(vid_num, K, num_feats, feats_frame, samplingMethod, video_folder)

    curdir = pwd;
    addpath(curdir);
    
    %%
    feat_list={'Trajectory','HOG','HOF','MBHx','MBHy'};
    
    Trajectory=[];
    HOG=[];
    HOF=[];
    MBHx=[];
    MBHy=[];
    
    pca_feat={};
    gmm.pca_coeff={};  
    gmm.w={};
    gmm.mu={};
    gmm.sigma={};


   % cd('train');                    % train the gmm with the training videos
    
   %% [wb]: Sample the dtf.
   filePath = [curdir, '/', video_folder, '/dtf_sampled_', int2str(num_feats)];
   
   if (~exist(filePath, 'dir'))         % [wb]: Create the folder if it doesn't exist.
       mkdir(filePath);
   end
   
   
   tmp_dt_file = dir(filePath);
   tmp_dt_file = tmp_dt_file(~ismember({tmp_dt_file.name}, {'.', '..', '.DS_Store'}));      % [wb]: remove the hidden files
   
   %% [wb]: If the sampled dtf exists (only for the training videos)
   if length(tmp_dt_file) == length(feat_list)
       for i = 1:length(feat_list)
           thisFile = [filePath, '/', feat_list{i}, '.mat'];
           
           if ~isempty(dir(thisFile))
               warning ('[%s] already exists, now loading ...\n', [feat_list{i}, '.mat'])
               tmp_feature = load(thisFile);        
               switch feat_list{i}
                   case 'Trajectory'
                       Trajectory = tmp_feature.Trajectory;
                   case 'HOG'
                       HOG = tmp_feature.HOG;
                   case 'HOF'
                       HOF = tmp_feature.HOF;
                   case 'MBHx'
                       MBHx = tmp_feature.MBHx;   
                   case 'MBHy'
                       MBHy = tmp_feature.MBHy; 
                   otherwise 
                       warning ('[%s] does not exit\n', feat_list{i});
               end  
           end
       end
       
   else
   %% [wb]: Sampling the dtf for the training videos
   
       % [wb]: Concatenate the dtf of all training videos
       for j = 1:vid_num
           dtf_file_dir=[curdir, '/', video_folder, '/vid_',int2str(j)];
           dtf_file = [dtf_file_dir, '/vid_',int2str(j), '*'];
           % [wb]: Extract features -- [ Trajectory,HOG,HOF,MBHx,MBHy ]
           disp(['Sampling dtf for vid',int2str(j)]);
           fprintf('\n'); 

           [Trajectory_tmp,HOG_tmp,HOF_tmp,MBHx_tmp,MBHy_tmp] = extract_dtf_feat(dtf_file_dir, dtf_file, num_feats, feats_frame, samplingMethod);
           save([dtf_file_dir, '/','Trajectory_', int2str(num_feats), '.mat'],'Trajectory_tmp');
           save([dtf_file_dir, '/','HOG_', int2str(num_feats), '.mat'],'HOG_tmp');
           save([dtf_file_dir, '/','HOF_', int2str(num_feats), '.mat'],'HOF_tmp');
           save([dtf_file_dir, '/','MBHx_', int2str(num_feats), '.mat'],'MBHx_tmp');
           save([dtf_file_dir, '/','MBHy_', int2str(num_feats), '.mat'],'MBHy_tmp');
                   
           
           Trajectory = [Trajectory;Trajectory_tmp'];
           HOG = [HOG;HOG_tmp'];         % the row is the data points; the column is the dimension
           HOF = [HOF;HOF_tmp'];
           MBHx = [MBHx;MBHx_tmp'];
           MBHy = [MBHy;MBHy_tmp'];
       end 


       Trajectory = Trajectory';         % the row is dimension; the column is datapoints;
       HOG = HOG';
       HOF = HOF';
       MBHx = MBHx';
       MBHy = MBHy';

       
       save([filePath, '/','Trajectory.mat'],'Trajectory');
       save([filePath, '/','HOG.mat'],'HOG');
       save([filePath, '/','HOF.mat'],'HOF');
       save([filePath, '/','MBHx.mat'],'MBHx');
       save([filePath, '/','MBHy.mat'],'MBHy');
   end



    %% PCA -- PCA_feats[reduce dimension by half], GMM, fisher_vector
    dtf_feat_num = length(feat_list);
    feats_train = {Trajectory, HOG, HOF, MBHx, MBHy}; 

    outputName = ['gmm_',int2str(K),'.mat'];
    if isempty(dir(outputName))
        for i = 1:dtf_feat_num
            % [wb]: Do PCA on train/test data to half-size original descriptors
            % After that, the dimensions of the subsampled features were reduced
            % to half of their original dimensions by doing PCA.
            disp(['Doing PCA for:',feat_list{i}]);
            fprintf('\n');       
            [pca_feat{i},gmm.pca_coeff{i}] = PCA_half(feats_train{i});


            disp(['Extracting FV for:', feat_list{i}]);
            fprintf('\n');  

            % [wb]: Means matrix of GMM (d x K) in single/double format 
            % Variance matrix of GMM (d x K) in single/double format
            % Weights vector of GMM (1 x K) in single/double format
            [gmm.w{i}, gmm.mu{i}, gmm.sigma{i}] = yael_gmm (single(pca_feat{i}), K, 'niter', 500);
        end
        output = fullfile(outputName);
        save(output,'gmm');
    else
        tmpfile = load(outputName);
        gmm = tmpfile.gmm;        
    end
    
end
