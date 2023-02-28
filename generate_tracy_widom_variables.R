library(RMTstat)
n = 10000
data = rtw(n)
dataf = as.data.frame(data)
write.table(data, file = "C:\\phd4\\network yuan\\beta-model\\tracy-widom-distribution.txt")