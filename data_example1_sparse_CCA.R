rm(list = ls())
library(MASS)
library(PMA)


output_marginal_2019_09 = read.csv('./results/output_marginal_2019_09.csv', header = F)
output_marginal_2020_04 = read.csv('./results/output_marginal_2020_04.csv', header = F)
output_diff  = read.csv('./results/output_diff.csv', header = F)



colnames(output_marginal_2019_09) = c("studentindex","gender","depression",
                                      "anxiety","stress","loneliness",
                                      "friend","p.interaction","multi-support")
colnames(output_marginal_2020_04) = c("studentindex","gender","depression",
                                      "anxiety","stress","loneliness",
                                      "friend","p.interaction","multi-support")
colnames(output_diff) = c("studentindex","gender","depression",
                          "anxiety","stress","loneliness",
                          "friend","p.interaction","multi-support")


boot = 10^4
K = 2
set.seed(1)
data = output_marginal_2019_09
X.matrix = as.matrix(data[,c(3:6)])
Y.matrix = as.matrix(data[,c(8:9)])
perm.out <- CCA.permute(X.matrix,Y.matrix ,typex="standard",typez="standard",nperms=7,penaltyxs=seq(.1,.7,len=10), penaltyzs=seq(.1,.7,len=10))
out <- CCA(X.matrix,Y.matrix ,typex="standard",typez="standard",K=2,
           penaltyx=perm.out$bestpenaltyx,penaltyz=perm.out$bestpenaltyz,
           v=perm.out$v.init, trace = FALSE)
CCA_marginal_2019_09 = rbind(out$u, out$v)
cor_2019_09 = out$cors
nnn1 = nrow(X.matrix)
CCA_boot = rep(0, 6*K*boot)
dim(CCA_boot) = c(6,K, boot)
cor_CCA = rep(0, 2*boot)
dim(cor_CCA) = c(boot,2)
for (b in 1:boot){
  tryCatch(
    {  
    sfidx = sample(1:nnn1, nnn1, replace = FALSE)
    X.matrix_boot = X.matrix[sfidx,]
    Y.matrix_boot = Y.matrix
    perm.out <- CCA.permute(X.matrix_boot,Y.matrix_boot ,typex="standard",typez="standard",nperms=7,trace = FALSE,penaltyxs=seq(.1,.7,len=10), penaltyzs=seq(.1,.7,len=10))
    out <- CCA(X.matrix_boot,Y.matrix_boot ,typex="standard",typez="standard",K=1,
               penaltyx=perm.out$bestpenaltyx,penaltyz=perm.out$bestpenaltyz,
               v=perm.out$v.init,trace = FALSE)
    CCA_boot[,,b] = rbind(out$u, out$v)
    cor_CCA[b,] = out$cors
      
    },
    error = function(e){
      CCA_boot[,,b] = NaN
      cor_CCA[b,] = NaN
    }
  )

}
P_val = matrix(0, 6,2)
for(i in 1:6){
  for(j in 1:2){
    P_val[i,j] = mean(abs(na.omit(CCA_boot[i,j,]))>abs(CCA_marginal_2019_09[i,j]))
  }
}
P_val_cor_2019_09 = apply(abs(na.omit(cor_CCA))>abs(cor_2019_09),2, mean)
CCA_result_2019_09 = cbind(CCA_marginal_2019_09[,1],P_val[,1], CCA_marginal_2019_09[,2],P_val[,2])


set.seed(1)
data = output_marginal_2020_04
X.matrix = as.matrix(data[,c(3:6)])
Y.matrix = as.matrix(data[,c(8:9)])
perm.out <- CCA.permute(X.matrix,Y.matrix ,typex="standard",typez="standard",nperms=7,penaltyxs=seq(.1,.7,len=10), penaltyzs=seq(.1,.7,len=10))
out <- CCA(X.matrix,Y.matrix ,typex="standard",typez="standard",K=2,
           penaltyx=perm.out$bestpenaltyx,penaltyz=perm.out$bestpenaltyz,
           v=perm.out$v.init, trace = FALSE)
CCA_marginal_2020_04 = rbind(out$u, out$v)
cor_2020_04 = out$cors
nnn1 = nrow(X.matrix)
CCA_boot = rep(0, 6*K*boot)
dim(CCA_boot) = c(6,K, boot)
cor_CCA = rep(0, 2*boot)
dim(cor_CCA) = c(boot,2)
for (b in 1:boot){
  tryCatch(
    {  
  sfidx = sample(1:nnn1, nnn1, replace = FALSE)
  X.matrix_boot = X.matrix[sfidx,]
  Y.matrix_boot = Y.matrix
  perm.out <- CCA.permute(X.matrix_boot,Y.matrix_boot ,typex="standard",typez="standard",nperms=7,trace = FALSE,penaltyxs=seq(.1,.7,len=10), penaltyzs=seq(.1,.7,len=10))
  out <- CCA(X.matrix_boot,Y.matrix_boot ,typex="standard",typez="standard",K=1,
             penaltyx=perm.out$bestpenaltyx,penaltyz=perm.out$bestpenaltyz,
             v=perm.out$v.init,trace = FALSE)
  CCA_boot[,,b] = rbind(out$u, out$v)
  cor_CCA[b,] = out$cors
  },
  error = function(e){
    CCA_boot[,,b] = NaN
    cor_CCA[b,] = NaN
  }
)
}
P_val = matrix(0, 6,2)
for(i in 1:6){
  for(j in 1:2){
    P_val[i,j] = mean(abs(na.omit(CCA_boot[i,j,]))>abs(CCA_marginal_2020_04[i,j]))
  }
}
P_val_cor_2020_04  = apply(abs(na.omit(cor_CCA))>abs(cor_2020_04),2, mean)
CCA_result_2020_04 = cbind(CCA_marginal_2020_04[,1],P_val[,1], CCA_marginal_2020_04[,2],P_val[,2])


set.seed(1)
data = output_diff
X.matrix = as.matrix(data[,c(3:6)])
Y.matrix = as.matrix(data[,c(8:9)])
perm.out <- CCA.permute(X.matrix,Y.matrix ,typex="standard",typez="standard",nperms=7,penaltyxs=seq(.1,.7,len=10), penaltyzs=seq(.1,.7,len=10))
out <- CCA(X.matrix,Y.matrix ,typex="standard",typez="standard",K=2,
           penaltyx=perm.out$bestpenaltyx,penaltyz=perm.out$bestpenaltyz,
           v=perm.out$v.init, trace = FALSE)
CCA_diff = rbind(out$u, out$v)
cor_diff = out$cors
nnn1 = nrow(X.matrix)
CCA_boot = rep(0, 6*K*boot)
dim(CCA_boot) = c(6,K, boot)
cor_CCA = rep(0, 2*boot)
dim(cor_CCA) = c(boot,2)
for (b in 1:boot){
  tryCatch(
    {  
  sfidx = sample(1:nnn1, nnn1, replace =  FALSE)
  X.matrix_boot = X.matrix[sfidx,]
  Y.matrix_boot = Y.matrix
  perm.out <- CCA.permute(X.matrix_boot,Y.matrix_boot ,typex="standard",typez="standard",nperms=7,trace = FALSE,penaltyxs=seq(.1,.7,len=10), penaltyzs=seq(.1,.7,len=10))
  out <- CCA(X.matrix_boot,Y.matrix_boot ,typex="standard",typez="standard",K=1,
             penaltyx=perm.out$bestpenaltyx,penaltyz=perm.out$bestpenaltyz,
             v=perm.out$v.init,trace = FALSE)
  CCA_boot[,,b] = rbind(out$u, out$v)
  cor_CCA[b,] = out$cors
    },
  error = function(e){
    CCA_boot[,,b] = NaN
    cor_CCA[b,] = NaN
  }
  )
}
P_val = matrix(0, 6,2)
for(i in 1:6){
  for(j in 1:2){
    P_val[i,j] = mean(abs(na.omit(CCA_boot[i,j,]))>abs(CCA_diff[i,j]))
  }
}
P_val_cor_diff = apply(abs(na.omit(cor_CCA))>abs(cor_diff),2, mean)
CCA_result_diff = cbind(CCA_diff[,1],P_val[,1], CCA_diff[,2],P_val[,2])



df = list(CCA_result_2019_09 = CCA_result_2019_09, CCA_result_2020_04  = CCA_result_2020_04 , CCA_result_diff = CCA_result_diff, P_val_cor_2019_09 = P_val_cor_2019_09, P_val_cor_2020_04  = P_val_cor_2020_04 , P_val_cor_diff = P_val_cor_diff,CCA_boot = CCA_boot)
df$CCA_result_2019_09
df$CCA_result_2020_04
df$CCA_result_diff
 

write.matrix(df$CCA_result_2019_09,file="./results/sparse_CCA_2019_09.csv")
write.matrix(df$CCA_result_2020_04,file="./results/sparse_CCA_2020_04.csv")
write.matrix(df$CCA_result_diff,file="./results/sparse_CCA_diff.csv")





