library(R.matlab)
sparsity = c("dense","sparse")
N_all = c(100, 200, 400, 800, 1600,3200)
for (sparseness in sparsity){
  for(n in N_all){
    
    para = readMat(sprintf("./parameters/truemubeta_%d_%s.mat",n,sparseness))
    
    n = as.vector(para$n)
    beta = as.vector(para$beta)
    mu = as.vector(para$mu)
    
    
    beta_true = beta+mu/2
    
    MCnumber = 100
    error1 = rep(0, MCnumber)
    error2 = rep(0, MCnumber)
    error3 = rep(0, MCnumber)
    testerror = rep(0, MCnumber)
    timerecord = rep(0, MCnumber)
    
    
    n.sample           <- matrix(1, n, n)
    diag(n.sample)     <- 0
    p1          <- outer(exp(beta), exp(beta)) * exp(mu)
    p           <- p1/(1+p1)
    
    
    for (k in 1:MCnumber){
      adjacent <- matrix(0, n, n)
      for(i in 1:n){
        for(j in i:n){
          if(n.sample[i,j]>0){  
            x             <- rbinom(1, n.sample[i,j], p[i,j])
            adjacent[i,j] <- x
            adjacent[j,i] <- x
          }  
        }
      }
      adjacent0                 <- adjacent
      c1                        <- order(rowMeans(adjacent0), decreasing = T)
      adjacent                  <- adjacent0[c1,c1]
      timestart = Sys.time()
      fit                       <- compute.mle.beta(adjacent, n.sample)
      timeend = Sys.time()
      timerecord[k] = as.numeric(difftime(timeend, timestart, units = "secs"))
      hatKfinal             <- fit$kfinal
      muBetaHat             <- fit$theta
      
      muHat                 <- muBetaHat[1]
      BetaHat               <- muBetaHat[-1]
      beta_est = BetaHat + muHat/2;
      error1[k] = mean(abs(beta_est-beta_true[c1]));
      error2[k] = sqrt(sum((beta_est-beta_true[c1])^2))/sqrt(n);
      error3[k] = max(abs(beta_est-beta_true[c1]));
      
      classifi = BetaHat>0;
      classifi_true = abs(beta[c1])>0;
      testerror[k] = mean(classifi!=classifi_true);
      
    }
    
    df = list(error1 = error1, error2 = error2, error3 = error3, testerror = testerror ,timerecord = timerecord)
    save(df, file=sprintf("./results/l0result_%d_%s.RData",n,sparseness)) 
    
  }
}