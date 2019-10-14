%% function [Trajectory,HOG,HOF,MBHx,MBHy] = extract_dtf_feat(dtf_file, num_feats, feats_frame, samplingMethod)
% extract the dtf features. 
%
% INPUTS
%  dtf_file_dir         - the directory of the dtf_file
%  dtf_file             - the name of the raw dtf_file
%  num_feats            - Set the number of dtf, used in the sampling.
%                         To use all the DTF features, set it to a negative
%                         value.
%  feats_frame          - How many frames is the dtf calculated from?
%                         This number must be the one used in the original
%                         dense Trajectoryory codes (defalut: 15).
%  samplingMethod       - 1)'random'; 
%                         2) 'linear'(default); 

%
% OUTPUTS
%  Sampled five DTF: Trajectory,HOG,HOF,MBHx,MBHy
%
% -------------------------------------------------------------------------
% Wenyan Bi, 2016 [wb1918a@student.american.edu]
% Please email me if you find bugs, or have suggestions or questions
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [Trajectory,HOG,HOF,MBHx,MBHy] = extract_dtf_feat(dtf_file_dir, dtf_file, num_feats, feats_frame, samplingMethod)

    %% [wb]: Check whether the valid input data exists
    if ~exist(dtf_file_dir,'file')
        warning('File %s does not exist! Skip now...',dtf_file);
        return;
    else
        tmpfile = dir(dtf_file);
       % tmpfile = tmpfile(~ismember({tmpfile.name}, {'.', '..', '.DS_Store'}));         % [wb]: remove the hidden files
        
        if tmpfile.bytes < 1024
            warning('File %s is too small! Skip now...',dtf_file);
            return;
        end
    end

    this_dtf_file = [dtf_file_dir, '/', tmpfile.name];              % [wb]: the full name of the dtf file
    %%
    params.feat_list={'Trajectory','HOG','HOF','MBHx','MBHy'};      % [wb]: all dtf features
 
    %
    spatial_cell = 2;

    switch feats_frame
        case 2
            temporal_cell = 1;                       % [wb]: length of features: 2 frames
        case 4
            temporal_cell = 1;                       % [wb]: length of features: 4 frames
        case 8 
            temporal_cell = 2;                       % [wb]: length of features: 8 frames
        case 15
            temporal_cell = 3;                       % [wb]: length of features: 15 frames
        otherwise
            temporal_cell = input(sprintf('How many temporal_cell? \n'));
            if (isempty(temporal_cell))
                error ('Need to define the feat_len.\n')
            end
    end

    feat_len = {2*feats_frame,...
                temporal_cell*spatial_cell*spatial_cell*8,...
                temporal_cell*spatial_cell*spatial_cell*9,...
                temporal_cell*spatial_cell*spatial_cell*8,...
                temporal_cell*spatial_cell*spatial_cell*8};       



    params.feat_len_map = containers.Map(params.feat_list, feat_len);

    params.feat_start = 11;           % [wb]: Start position(column) of DTF features.
                                      % The first 10 elements for each line in 
                                      % dtf_file are marginal stats of the Trajectory.



    Trajectory = zeros(params.feat_len_map('Trajectory'),1);
    HOG = zeros(params.feat_len_map('HOG'),1);
    HOF = zeros(params.feat_len_map('HOF'),1);
    MBHx = zeros(params.feat_len_map('MBHx'),1);
    MBHy = zeros(params.feat_len_map('MBHy'),1);


    x = load(this_dtf_file);           % [wb]: Load the raw dtf file.
    fprintf('The raw dtf file [%s] successfully loaded\n', tmpfile.name);

    Trajectory_range = params.feat_start:(params.feat_start+params.feat_len_map('Trajectory')-1);
    hog_range = Trajectory_range(end)+1:(Trajectory_range(end)+params.feat_len_map('HOG'));
    hof_range = hog_range(end)+1:(hog_range(end)+params.feat_len_map('HOF'));
    mbhx_range = hof_range(end)+1:(hof_range(end)+params.feat_len_map('MBHx'));
    mbhy_range = mbhx_range(end)+1:(mbhx_range(end)+params.feat_len_map('MBHy'));


    %% [wb]: sampling features
    % [wb]: negative num_feats: USE ALL
    if num_feats < 0 
        num_feats = size(x,1);
    end

    % [wb]: num_feats > all num_feats: USE ALL
    if size(x,1) <= num_feats
        idx = 1:size(x,1);
    else
        warning ('Sampled [%f%%] of the dtf points for [%s]', 100*num_feats*1.0/size(x,1), tmpfile.name);
        if strcmp(samplingMethod, 'random')
            idx = randperm(size(x,1),num_feats);              %[wb]: randomly subsampling
        else
            idx = floor(linspace(1,size(x,1),num_feats));     %[wb]: linearly subsampling
        end
    end

    %%
    Trajectory = x(idx,Trajectory_range)'; 
    HOG = x(idx,hog_range)';
    HOF = x(idx,hof_range)';
    MBHx = x(idx,mbhx_range)';
    MBHy = x(idx,mbhy_range)';
end

