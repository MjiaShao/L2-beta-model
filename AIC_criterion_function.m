function [AIC, likelihood] = AIC_criterion_function(d_vec, beta_est, lambda)
    d_vec = d_vec(:);
    deg_uniq = sort(unique(d_vec),'descend');
    n = length(d_vec);
    n_uniq = length(deg_uniq);
    num_deg = zeros(n_uniq,1);
    delta_0  = zeros(n_uniq,1);
    for j = 1:length(deg_uniq)
	    num_deg(j,1) = sum(d_vec == deg_uniq(j));
	    delta_0(j,1) = mean(beta_est(d_vec == deg_uniq(j)));
    end
    delta_0a = delta_0 * ones(1,n_uniq); delta_0a = delta_0a+delta_0a'; 
    delta_0a1 = log(1+exp(delta_0a)); delta_0a10 = delta_0a1 - diag(diag(delta_0a1));
    likelihood = num_deg'*delta_0a10*num_deg/2 + sum(num_deg.*(num_deg-1)/2.* diag(delta_0a1)) - sum(beta_est.*d_vec);
    d_max = max(d_vec);
    AIC = (n-2)*d_max/(d_max *(n-2)/(n-1)+lambda) + 2*d_max/(2*d_max+lambda) + likelihood;
end






   