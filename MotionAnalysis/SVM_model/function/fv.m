%% function fvt=fv(pca_feat,w,mu,sigma)
% calculate fisher vector based on the gmm model that was trained.
%
% INPUTS

% OUTPUTS
%
% -------------------------------------------------------------------------
% Wenyan Bi, 2016 [wb1918a@student.american.edu]
% Please email me if you find bugs, or have suggestions or questions
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function fvt=fv(pca_feat,w,mu,sigma)

pca_feat = single(pca_feat);

% Means matrix of GMM (d x K) in single/double format 
% Variance matrix of GMM (d x K) in single/double format
% Weights vector of GMM (1 x K) in single/double format
%[w, mu, sigma] = yael_gmm (pca_feat, clusterN, 'niter', 500);
fvt = yael_fisher (pca_feat, w, mu, sigma);
% power normalization
fvt = sign(fvt) .* sqrt(abs(fvt));
% L2 normalization
fvt = double(yael_vecs_normalize(single(fvt)));
end