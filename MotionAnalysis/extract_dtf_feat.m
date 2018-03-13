function [ Traject,HOG,HOF,MBHx,MBHy ] = extract_dtf_feat(dtf_file, num_feats,samplingMethod)
%EXTRACT_DTF_FEATS extract DTF features.
%   samplingMETHOD: 1)'random'; 2) 'linear'(default)
%   dtf_file: 1) unzipped; 2) absolute path.
%	
%   Subsampling:
%       randomly choose "num_feats" descriptors from each video clip(dtf file)
%		To use all the DTF fatures, set num_feats to a negative number.
%


%% whether valid data exists
if ~exist(dtf_file,'file')
	warning('File %s does not exist! Skip now...',dtf_file);
	return;
else
	tmpfile=dir(dtf_file);
	if tmpfile.bytes < 1024
		warning('File %s is too small! Skip now...',dtf_file);
		return;
	end
end


%%
params.feat_list={'Traject','HOG','HOF','MBHx','MBHy'}; % all features involved in this test
feat_len={30,96,108,96,96}; % length of features: 15 frames
%feat_len={4,32,36,32,32}; % length of features: 2 frames
%feat_len = {64,64,72,64,64}; 
%feat_len={8,32,36,32,32}; % length of features: 4 frames
%feat_len={16,64,72,64,64}; % length of features: 8 frames
%feat_len={32,144,72,128,128};


params.feat_len_map=containers.Map(params.feat_list, feat_len);
params.feat_start=11; % start position(column) of DTF features


Traject=zeros(params.feat_len_map('Traject'),1);
HOG=zeros(params.feat_len_map('HOG'),1);
HOF=zeros(params.feat_len_map('HOF'),1);
MBHx=zeros(params.feat_len_map('MBHx'),1);
MBHy=zeros(params.feat_len_map('MBHy'),1);


x=load(dtf_file);


traject_range=params.feat_start:(params.feat_start+params.feat_len_map('Traject')-1);
hog_range=traject_range(end)+1:(traject_range(end)+params.feat_len_map('HOG'));
hof_range=hog_range(end)+1:(hog_range(end)+params.feat_len_map('HOF'));
mbhx_range=hof_range(end)+1:(hof_range(end)+params.feat_len_map('MBHx'));
mbhy_range=mbhx_range(end)+1:(mbhx_range(end)+params.feat_len_map('MBHy'));


%% sampling features
% negative num_feats: USE ALL
if num_feats<0 
	num_feats=size(x,1);
end

% num_feats > all num_feats: USE ALL
if size(x,1)<=num_feats
	idx=1:size(x,1);
else
    
    if samplingMethod=='random'
        idx=randperm(size(x,1),num_feats); % randomly subsampling
    else
        idx=floor(linspace(1,size(x,1),num_feats)); % linearly subsampling
    end
end

%%
Traject=x(idx,traject_range)'; 
HOG=x(idx,hog_range)';
HOF=x(idx,hof_range)';
MBHx=x(idx,mbhx_range)';
MBHy=x(idx,mbhy_range)';
end

