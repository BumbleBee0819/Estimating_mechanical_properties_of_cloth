function fvt=fv(pca_feat,w,mu,sigma)
% calculate fisher vector based on the gmm model that was trained.

pca_feat=single(pca_feat);

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