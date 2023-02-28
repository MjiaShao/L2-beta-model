function [likelihood] = objective_function(deg_uniq, num_deg, n, delta_0, lambda)
    n_uniq = length(deg_uniq);
    delta_0a = delta_0 * ones(1,n_uniq); delta_0a = delta_0a+delta_0a'; 
    delta_0a1 = log(1+exp(delta_0a)); delta_0a10 = delta_0a1 - diag(diag(delta_0a1));
    likelihood = num_deg'*delta_0a10*num_deg/2 + sum(num_deg.*(num_deg-1)/2.* diag(delta_0a1)) - sum(num_deg .*deg_uniq.*delta_0) ;
    delta_0_bar = 1/n* sum(num_deg.*delta_0);
    likelihood = likelihood + lambda/2* sum(num_deg.*(delta_0-delta_0_bar).^2);
   
end


   