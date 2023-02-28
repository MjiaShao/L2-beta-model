clear
N_all = [100, 200, 400, 800, 1600];
type = 'binom';
a = 0.1;
b_all = [-0.1,-0.2,-0.3,-0.4];
p = 0.4;
lambda = 0;   epsilon_0 = 1e-7;  IterMax = 500;
Boot = 10^4;

for n = N_all
for b = b_all
beta_true = generate_beta(n,type,a,b,p);
record = zeros(Boot,1);
for i= 1:Boot
    W = beta_true*ones(1,n);  W = W + W';  W = 1./(1+exp(-W));  W = W-diag(diag(W));
    A = generate_A(W);
    d_vec = sum(A)';
    beta_0 = zeros(n,1);
    beta_est = Fast_Newton_method(sum(A), beta_0, lambda, IterMax);
    W_hat = beta_est*ones(1,n);  W_hat = W_hat + W_hat';  p_hat = 1./(1+exp(-W_hat));  
    A_tilt = (A-p_hat)./((n-1)*p_hat.*(1-p_hat)).^0.5; A_tilt = A_tilt-diag(diag(A_tilt));
    record(i,1) = n^(2/3)*(abs(eigs(A_tilt,1))-2);
end
save(sprintf("./results/result_%d_%s_%d_%d_%d.mat",n,type,abs(floor(a*10)),abs(floor(b*10)), abs(floor(p*10))),'record')
end
end
