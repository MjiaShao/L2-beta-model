Nall = [100, 200, 400, 800, 1600,3200];
for n = Nall
load(sprintf("./parameters/truemubeta_%d_dense.mat",n))
lambda = 0; epsilon_0 = 1e-7;  IterMax = 1000; stepsize = 1;

beta_true = beta + mu/2;
W = beta_true'*ones(1,n);  W = W + W';  W = 1./(1+exp(-W));  W = W-diag(diag(W));

MCnumber = 1000;
error1 = zeros(1,MCnumber);
error2 = zeros(1,MCnumber);
error3 = zeros(1,MCnumber);
timerecord = zeros(1,MCnumber);
testerror = zeros(1,MCnumber);
for k = 1:MCnumber
    A = generate_A(W);
    d_vec = sum(A);
    rho_n = sum(A(:))/(n*(n-1));
    beta_0 = zeros(n,1);
    tic;
    beta_est = Fast_gradient_method(sum(A)', beta_0, lambda, IterMax,stepsize);
    timerecord(k) = toc;
    error1(k) = mean(abs(beta_est'-beta_true));
    error2(k) = norm(beta_est'-beta_true)/sqrt(n);
    error3(k) = max(abs(beta_est'-beta_true));

    classifi = abs(beta_est'- mean(beta_est)) > sqrt(log(n)/n/mean(mean(A)));
    classifi_true = abs(beta)>0;
    testerror(k) = mean(classifi~=classifi_true);
end

save(sprintf("./results/l2result_%d_dense.mat",n),'error1','error2','error3','testerror','timerecord');
end



for n = Nall
load(sprintf("./parameters/truemubeta_%d_sparse.mat",n))
lambdalist = [1,5,n*log(n)];
for lambda = lambdalist
    epsilon_0 = 1e-7;  IterMax = 1000; stepsize = 1;
    beta_true = beta + mu/2;
    W = beta_true'*ones(1,n);  W = W + W';  W = 1./(1+exp(-W));  W = W-diag(diag(W)); 
    MCnumber = 1000;
    error1 = zeros(1,MCnumber);
    error2 = zeros(1,MCnumber);
    error3 = zeros(1,MCnumber);
    timerecord = zeros(1,MCnumber);
    testerror = zeros(1,MCnumber);
    for k = 1:MCnumber
        A = generate_A(W);
        d_vec = sum(A);
        rho_n = sum(A(:))/(n*(n-1));
        beta_0 = zeros(n,1);
        tic;
        beta_est = Fast_gradient_method(sum(A)', beta_0, lambda, IterMax,stepsize);
        timerecord(k) = toc;
        error1(k) = mean(abs(beta_est'-beta_true));
        error2(k) = norm(beta_est'-beta_true)/sqrt(n);
        error3(k) = max(abs(beta_est'-beta_true));
    
        classifi = abs(beta_est'- mean(beta_est)) > sqrt(log(n)/n/mean(mean(A)));
        classifi_true = abs(beta)>0;
        testerror(k) = mean(classifi~=classifi_true);
    end
    
    save(sprintf("./results/l2result_%d_%d_sparse.mat",n,floor(lambda)),'error1','error2','error3','testerror','timerecord');
end
end
