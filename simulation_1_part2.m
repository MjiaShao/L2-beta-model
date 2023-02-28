
% L2 error rate as n changes

rng(2608);

for TrueBetaSetting = 1:6

switch(TrueBetaSetting)
	
	case 1
		gamma = -1/3;  alpha = 1/5;  s_prop = 1/5;
		lambda = 0.1;  epsilon_0 = 1e-7; 
	
	case 2
		gamma = -1/2;  alpha = 1/5;  s_prop = 1/5;
		lambda = 0.1;  epsilon_0 = 1e-7; 
		
	case 3
		gamma = -2/3;  alpha = 1/3;  s_prop = 1/5;
		lambda = 0.1;  epsilon_0 = 1e-7; 
		
	case 4
		gamma = -2/3;  alpha = 1/3;  s_prop = 1/5;
		lambda = 10;  epsilon_0 = 1e-7; 
	
	case 5
		gamma = -2/3;  alpha = 1/3;  s_prop = 1/5;
		lambda = 200;  epsilon_0 = 1e-7; 
		
	case 6
		gamma = -1/3;  alpha = gamma+0.05;  s_prop = 1/5;
		lambda = 200;  epsilon_0 = 1e-7;  
		
		
end
		

n_vec = [50, 100,400,1600,6400];
Nexp = 1000;
for n = n_vec


beta_list_Gradient = [];
beta_list_Newton   = [];

for(exp_index = 1:Nexp)
	
	
	
	s = floor(s_prop * n);
	
	%%% Set up beta parameters
	beta_true = zeros(n,1);
		beta_true(1:s) = alpha*log(n);
		beta_true((s+1):n) = gamma*log(n);

	%%% Generate network
	W = beta_true*ones(1,n);  W = W + W';  W = 1./(1+exp(-W));  W = W-diag(diag(W));
	A = generate_A(W);

	%%% Gradient method
	d_vec = sum(A);
    d_vec = d_vec';	
	IterMax = 500;
    beta_0 = zeros(n,1);
    beta_est = Fast_Newton_method(d_vec, beta_0, lambda, IterMax);
	beta_list_Newton(:, exp_index) = beta_est;
	
end


beta_list = beta_true;
V_beta = beta_list * ones(1,n); 
V_beta  = V_beta  +V_beta'; V_br = 1./(1+ exp(-V_beta)); 
A_bar = sum(sum(A))/n/(n-1);
nomi = A_bar - V_br;
deno = log(A_bar/(1-A_bar)) - V_beta;
V_b = nomi./deno;
V_b = V_b - diag(diag(V_b));
V_b = V_b + diag(sum(V_b,1));
true_location_vec = ones(1,n) * V_b * beta_list/(ones(1,n)*V_b*ones(n,1));


figure('visible','on');

font_size = 20;

data = beta_list_Newton(1,:);  data = data(:);
pd = fitdist(data,'normal');
x_pdf = linspace(min(data),max(data));
y_pdf = pdf(pd,x_pdf);
fig = histogram(data,'Normalization','pdf');  hold on;
x1 = xline(beta_true(1),'g:',{'True $\beta_1$ ($\lambda=0$)'},'linewidth',2,'LabelVerticalAlignment','middle', 'interpreter','latex');
x2 = xline(true_location_vec(1),'m:',{'Mean-predict (large $\lambda$)'},'linewidth',2,'LabelVerticalAlignment','middle', 'interpreter','latex');
x1.FontSize = font_size;
x2.FontSize = font_size;
line(x_pdf,y_pdf,'LineWidth',2,'color','red','linestyle','--');   hold off;
title(sprintf('Histogram of $\\widehat\\beta_{\\lambda,1}$ (Newton)\nSetting %d, $\\lambda=%1.1f$, $n=%d$', TrueBetaSetting,lambda,n),'interpreter','latex');
set(gca,'FontSize',font_size);
set(gca,'color',[192,192,192]/255);
set(gcf, 'InvertHardCopy', 'off');
saveas(fig, sprintf('./plots/normality_Newton_beta_1_case_%d_n_%d.png', TrueBetaSetting,n));


data = beta_list_Newton((n-1):n,:);  data = data';  data = outlier_elim(data);
fig = scatter(data(:,1),data(:,2),'k');
title(sprintf('Scatter plot of $(\\widehat\\beta_{\\lambda,%d}, \\widehat\\beta_{\\lambda,%d})$ (Newton)\nSetting %d, $\\lambda=%1.1f$, $n=%d$', n-1,n,TrueBetaSetting,lambda,n),'interpreter','latex');
set(gca,'FontSize',font_size);
set(gca,'color',[192,192,192]/255);
set(gcf, 'InvertHardCopy', 'off');
saveas(fig, sprintf('./plots/normality_Newton_beta_n-1n_case_%d_n_%d.png', TrueBetaSetting,n));


end
end