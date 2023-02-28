
library(R.matlab)
library(glmnet)
library(dplyr)


sparsity = c("dense","sparse")
N_all = c(100, 200, 400, 800, 1600,3200)
for (sparseness in sparsity){
  for(n in N_all){
    
    para = readMat(sprintf("./parameters/truemubeta_%d_%s.mat",n,sparseness))
    
    n = as.vector(para$n)
    beta = as.vector(para$beta)
    mu = as.vector(para$mu)
    
    
    MCnumber = 100
    error1 = rep(0, MCnumber)
    error2 = rep(0, MCnumber)
    error3 = rep(0, MCnumber)
    testerror = rep(0, MCnumber)
    timerecord = rep(0, MCnumber)
    
    thetaall = rep(0, MCnumber*(n+1))
    dim(thetaall)= c(MCnumber, (n+1))
    
    beta_true = beta + mu/2;
    
    for (k in 1:MCnumber){
      adj_matrix <- sbetam_sample(beta, mu)
      timestart = Sys.time()
      fit <- sbetam(adj_matrix)
      pen <- log(choose(n,2))
      BIC <- GIC(fit$log_likelihood, fit$df, pen)
      selected_model <- which.min(BIC)
      beta_fitted <- fit$beta[,selected_model] # keep in mind that fit$beta is a matrix, hence the komma
      mu_fitted <- fit$mu[selected_model]
      timeend = Sys.time()
      timerecord[k] = as.numeric(difftime(timeend, timestart, units = "secs"))
      beta_est = beta_fitted + mu_fitted/2;
      
      error1[k] = mean(abs(beta_est-beta_true));
      error2[k] = sqrt(sum((beta_est-beta_true)^2))/sqrt(n);
      error3[k] = max(abs(beta_est-beta_true));
      
      classifi = beta_fitted>0;
      classifi_true = abs(beta)>0;
      testerror[k] = mean(classifi!=classifi_true);
      thetaall[k,] = c(mu_fitted, beta_fitted)
      
    }
    
    df = list(error1 = error1, error2 = error2, error3 = error3, testerror = testerror ,timerecord = timerecord)
    save(df, file=sprintf("./results/l0result_%d_%s.RData",n,sparseness)) 
    
  }
}