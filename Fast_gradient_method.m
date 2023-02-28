function [beta_est,beta_history,delta_history] = Fast_gradient_method(deg, beta_0, lambda, iter,stepsize)
    deg = deg(:);
    deg = reshape(deg,[length(deg),1]);
    deg_uniq = sort(unique(deg),'descend');
    n = length(deg);
    n_uniq = length(deg_uniq);
    deg_indx = zeros(n_uniq ,1);
    num_deg = zeros(n_uniq,1);
    delta_0  = zeros(n_uniq,1);
    for j = 1:length(deg_uniq)
	    deg_indx(deg == deg_uniq(j)) = j;	
	    num_deg(j,1) = sum(deg == deg_uniq(j));
	    delta_0(j,1) = mean(beta_0(deg == deg_uniq(j)));
    end
    delta_history = [];
    count = 1;
    for i =  1:iter
        delta_history(:,i) = delta_0;
        delta_0a = delta_0 * ones(1,n_uniq); delta_0a = delta_0a+delta_0a'; 
        delta_0a1 = 1./(1+exp(-delta_0a)); delta_0a10 = delta_0a1 - diag(diag(delta_0a1));
        delta_0_bar = 1/n* sum(num_deg.*delta_0);
        G = num_deg.* (delta_0a10 * num_deg) + num_deg.*(num_deg-1).* diag(delta_0a1) - num_deg.*deg_uniq + num_deg.*(delta_0 - delta_0_bar)*lambda;
        delta_new = delta_0 - stepsize * G;
        if objective_function(deg_uniq, num_deg, n, delta_new, lambda) < objective_function(deg_uniq, num_deg, n, delta_0, lambda)
            delta_0 = delta_new;
            stepsize = stepsize * 1.2;
        else
            stepsize = stepsize * 0.8;
        end
        count = count + 1;
    end
	beta_est = zeros(n,1);
    beta_history = zeros(n, iter);
	for i = 1:length(deg_uniq)
		beta_est(deg_indx == i) = delta_0(i);
        beta_history(deg_indx == i,:) = ones(sum(deg_indx == i),1) * delta_history(i,:);
    end
    count = count - 1;
end