lambda_vec = [0,1,2.5,5,10,20,40,80, 160, 320, 640,1280];
for lambda = lambda_vec
iter = 30;
deg_vec = readmatrix('./data/AWS-csv/deg_vec.txt');
deg_vec(deg_vec<=0) = [];
n = length(deg_vec);   
stepsize = 1;
beta_0 = log(deg_vec+1)-mean(log(deg_vec+1));
deg = deg_vec;
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
for i = 1: iter
    delta_history(i,:) = delta_0;
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
end
beta_est = zeros(n,1);
for i = 1:length(deg_uniq)
	beta_est(deg_indx == i) = delta_0(i);
end

aic = AIC_criterion_function(deg_vec, beta_est, lambda);

save(sprintf("./results/aws_beta_gradient_check_faster_%d.mat",floor(lambda)),'delta_history','beta_est','aic');
end