function [PCA_feats,PCA_coeff]=PCA_half(feats_train)    
        % input: extracted dtf features;
        % return:
        % pca_feats: half of the original features
        % pca_coeff: corresponding pca_coeff of the pca_feats

        
        % All the subsampled features are square rooted after L1 normalization.
        % L1 normalization & Square root
        feat=sqrt(feats_train/norm(feats_train,1));

        % Do PCA on train/test data to half-size original descriptors
        % After that, the dimensions of the subsampled features were reduced
        % to half of their original dimensions by doing PCA.
        PCA_coeff = princomp(feat');
        PCA_coeff = PCA_coeff(:, 1:floor(size(feat,1)/2))';

        % dimensionality reduction
        feat = PCA_coeff * feat;
        PCA_feats=feat;
end