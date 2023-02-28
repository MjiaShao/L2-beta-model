gamma =  0.2;  
alpha = 0.4; 
Nall = [100, 200, 400, 800, 1600,3200];
for n = Nall
    s_star = n/5;
    mu = -gamma * log(n);
    beta = zeros(1,n);
    beta(1:floor(s_star/2)) = log(n)*alpha;
    beta((floor(s_star/2)+1):floor(s_star)) = -log(n)*alpha;  
    save(sprintf("./parameters/truemubeta_%d_dense",n),'n','mu','beta')
end

gamma =  0.6;  
alpha = 0.2; 
Nall = [100, 200, 400, 800, 1600,3200];
for n = Nall
    s_star = n/10;
    mu = -gamma * log(n);
    beta = zeros(1,n);
    beta(1:floor(s_star/2)) = log(n)*alpha;
    save(sprintf("./parameters/truemubeta_%d_sparse",n),'n','mu','beta')
end