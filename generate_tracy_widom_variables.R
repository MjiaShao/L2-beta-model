library(RMTstat)
n = 10000
data = rtw(n)
dataf = as.data.frame(data)
write.table(data, file = "tracy-widom-distribution.txt")