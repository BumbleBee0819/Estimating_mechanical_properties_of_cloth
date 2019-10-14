params.K=256;   % num of GMMs

gmm_params.cluster_count=params.K;
gmm_params.maxcomps=gmm_params.cluster_count/4;
gmm_params.GMM_init= 'kmeans';
gmm_params.pnorm = single(2);    % L2 normalization, 0 to disable
gmm_params.subbin_norm_type = 'l2';
gmm_params.norm_type = 'l2';
gmm_params.post_norm_type = 'none';
gmm_params.pool_type = 'sum';
gmm_params.quad_divs = 2;
gmm_params.horiz_divs = 3;
gmm_params.kermap = 'hellinger';

feats=single(PCA_feats{2});
% dimension*cluster
% init_mean = yael_kmeans (single(PCA_feats{2}), params.K, 'niter', 500);


% 
% Means matrix of GMM (d x K) in single/double format 
% Variance matrix of GMM (d x K) in single/double format
% Weights vector of GMM (1 x K) in single/double format
[w, mu, sigma] = yael_gmm (single(PCA_feats{2}), params.K, 'niter', 500);
fvt = yael_fisher (single(PCA_feats{2}), w, mu, sigma);
% power normalization
fvt = sign(fvt) .* sqrt(abs(fvt));
% L2 normalization
fvt = double(yael_vecs_normalize(single(fvt)));



