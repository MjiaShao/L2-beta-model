library(RMTstat)
n = 10000
data = rtw(n)
write.table(data, file = "tracy-widom-distribution.txt")