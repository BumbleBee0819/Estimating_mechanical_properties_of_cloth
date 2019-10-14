% function [PCA_feats,PCA_coeff]=PCA_half(feats_train)
%
% INPUTS
%  feats_train         - extracted dtf features;
% 
% OUTPUTS
%  pca_feats         - half of the original features
%  pca_coeff         - corresponding pca_coeff of the pca_feats
% -------------------------------------------------------------------------
% Wenyan Bi, 2016 [wb1918a@student.american.edu]
% Please email me if you find bugs, or have suggestions or questions
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [PCA_feats,PCA_coeff]=PCA_half(feats_train)    

        % [wb]: All the subsampled features are square rooted after L1 normalization.
        % L1 normalization & Square root
        feat = sqrt(feats_train/norm(feats_train,1));

        % [wb]: Do PCA on train/test data to half-size original descriptors
        % After that, the dimensions of the subsampled features were reduced
        % to half of their original dimensions by doing PCA.
        PCA_coeff = pca(feat');
        PCA_coeff = PCA_coeff(:, 1:floor(size(feat,1)/2))';

        % [wb]: dimensionality reduction
        feat = PCA_coeff * feat;
        PCA_feats = feat;
end