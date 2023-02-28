
rm(list = ls())
library(R.matlab)
library(latex2exp)

Nall =c(100,200,400, 800, 1600, 3200)
error1all = rep(0, length(Nall)*3)
dim(error1all) = c(length(Nall), 3)
error2all = rep(0, length(Nall)*3)
dim(error2all) = c(length(Nall), 3)
error3all = rep(0, length(Nall)*3)
dim(error3all) = c(length(Nall), 3)
testerrorall = rep(0, length(Nall)*3)
dim(testerrorall) = c(length(Nall), 3)
timecostall = rep(0, length(Nall)*3)
dim(timecostall) = c(length(Nall), 3)


for(i in 1:length(Nall)){
  n = Nall[i]
  data = readMat(sprintf("./results/l2result_%d_dense.mat",n))
  error1all[i,1] = mean(data$error1)
  error2all[i,1] = mean(data$error2)
  error3all[i,1] = mean(data$error3)
  testerrorall[i,1] = mean(data$testerror)
  timecostall[i,1] = mean(data$timerecord)
  load(sprintf("./results/l1result_%d_dense.RData",n))
  error1all[i,2] = mean(df$error1)
  error2all[i,2] = mean(df$error2)
  error3all[i,2] = mean(df$error3)
  testerrorall[i,2] = mean(df$testerror)
  timecostall[i,2] = mean(df$timerecord)
  if (!(n %in% c(3200))){
    load(sprintf("./results/l0result_%d_dense.RData",n))
    error1all[i,3] = mean(df$error1)
    error2all[i,3] = mean(df$error2)
    error3all[i,3] = mean(df$error3)
    testerrorall[i,3] = mean(df$testerror)
    timecostall[i,3] = mean(df$timerecord)
  }
}

error1all[6,3] = -Inf
error2all[6,3] = -Inf
error3all[6,3] = -Inf
testerrorall[6,3] = -Inf
timecostall[6,3] = 10^9


linewidth = 2.5

pdf(file=sprintf('./plots/error1_dense_lda_%s.pdf',lambda),width=6, height=6)
par(mar=c(5, 6.4, 1, 1), mgp=c(3.1, 1, 0), las=0,pty = "s")
plot(log(Nall), error1all[,1], type="o", col="blue", pch="o", lty=1, ylim=c(0,1.2), ylab=TeX(r'($n^{-1}\cdot||\hat{\beta_\lambda}- \beta_\lambda^*||_1$)'),xlab = "Network size n",cex.main=3, cex.lab=2.2, cex.axis=1.8,lwd = 2,cex = 2.5,xaxt = "n")
points(log(Nall), error1all[,2], col="red", pch="*", cex = linewidth)
lines(log(Nall), error1all[,2], col="red",lty=2,lwd = 2)
points(log(Nall), error1all[,3], col="dark red",pch="+", cex =linewidth)
lines(log(Nall), error1all[,3], col="dark red", lty=3,lwd = 2)
labels = c("Our method $\\lambda = 0$", "Stein and Leng (2020)", "Chen et al. (2021)")
legend("topleft",legend=TeX(labels), col=c("blue","red","dark red"),pch=c("o","*","+"),lty=c(1,2,3), ncol=1, cex = 1.8)
axis(1, at=log(Nall), labels=Nall, cex.axis=1.5)
dev.off()





pdf(file=sprintf('./plots/error2_dense_lda_%s.pdf',lambda))
par(mar=c(5, 6.4, 1, 1), mgp=c(3.1, 1, 0), las=0,pty = "s")
plot(log(Nall), error2all[,1], type="o", col="blue", pch="o", lty=1, ylim=c(0, 1.4), ylab=TeX(r'($n^{-1/2}\cdot||\hat{\beta_\lambda}- \beta_\lambda^*||_2$)'), xlab = "Network size n" ,cex.main=3, cex.lab=2.2, cex.axis=1.8,lwd = 2,cex = 2.5,xaxt = "n")
points(log(Nall), error2all[,2], col="red", pch="*", cex = linewidth)
lines(log(Nall), error2all[,2], col="red",lty=2,lwd = 2)
points(log(Nall), error2all[,3], col="dark red",pch="+", cex =linewidth)
lines(log(Nall), error2all[,3], col="dark red", lty=3,lwd = 2)
labels = c("our method $\\lambda = 0$", "SL", "CKL")
axis(1, at=log(Nall), labels=Nall, cex.axis=1.5)
dev.off()


pdf(file=sprintf('./plots/error3_dense_lda_%s.pdf',lambda))
par(mar=c(5, 6.4, 1, 1), mgp=c(3.1, 1, 0), las=0,pty = "s")
plot(log(Nall), error3all[,1], type="o", col="blue", pch="o", lty=1, ylim=c(0,3.4), ylab=TeX(r'($||\hat{\beta_\lambda}- \beta_\lambda^*||_\infty$)'), xlab = "Network size n",cex.main=3, cex.lab=2.2, cex.axis=1.8,lwd = 2,cex = 2.5,xaxt = "n")
points(log(Nall), error3all[,2], col="red", pch="*", cex = linewidth)
lines(log(Nall), error3all[,2], col="red",lty=2,lwd = 2)
points(log(Nall), error3all[,3], col="dark red",pch="+", cex =linewidth)
lines(log(Nall), error3all[,3], col="dark red", lty=3,lwd = 2)
labels = c("our method $\\lambda = 0$", "SL", "CKL")
axis(1, at=log(Nall), labels=Nall, cex.axis=1.5)
dev.off()

pdf(file=sprintf('./plots/testerror_dense_lda_%s.pdf',lambda))
par(mar=c(5, 6.4, 1, 1), mgp=c(3.1, 1, 0), las=0,pty = "s")
plot(log(Nall), testerrorall[,1], type="o", col="blue", pch="o", lty=1, ylim=c(0,1), ylab="Err. of active set Est.", xlab = "Network size n",cex.main=3, cex.lab=2.2, cex.axis=1.8,lwd = 2,cex = 2.5,xaxt = "n")
points(log(Nall), testerrorall[,2], col="red", pch="*", cex = linewidth)
lines(log(Nall), testerrorall[,2], col="red",lty=2,lwd = 2)
points(log(Nall), testerrorall[,3], col="dark red",pch="+", cex = linewidth)
lines(log(Nall), testerrorall[,3], col="dark red", lty=3,lwd = 2)
labels = c("our method $\\lambda = 0$", "SL", "CKL")
axis(1, at=log(Nall), labels=Nall, cex.axis=1.5)
dev.off()



pdf(file=sprintf('./plots/timecost_dense_lda_%s.pdf',lambda))
par(mar=c(5, 6.4, 1, 1), mgp=c(3.1, 1, 0), las=0,pty = "s")
timecostall = log(timecostall)
timecostall[6,3] = NaN
plot(log(Nall), timecostall[,1], type="o", col="blue", pch="o", lty=1, ylim=c(-10,10), ylab="Log(time)", xlab = "Network size n",cex.main=3, cex.lab=2.2, cex.axis=1.8,lwd = 2,cex = 2.5,xaxt = "n")
points(log(Nall), timecostall[,2], col="red",pch="*", cex = linewidth)
lines(log(Nall), timecostall[,2], col="red",lty=2,lwd = 2)
points(log(Nall), timecostall[,3], col="dark red",pch="+", cex = linewidth)
lines(log(Nall), timecostall[,3], col="dark red", lty=3,lwd = 2)
lines(log(Nall), rep(6.761573,length(Nall)), col="dark green", lty=2,lwd = 2)
text(log(500), 7.2, "Total running time = 24 hours", cex = 1.8, col = "dark green")
labels = c("our method $\\lambda = 0$", "SL", "CKL")
axis(1, at=log(Nall), labels=Nall, cex.axis=1.5)
dev.off()
