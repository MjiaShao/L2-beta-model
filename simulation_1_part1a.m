
% L2 error rate as n changes

rng(2608);
TrueBetaSetting = 1;
switch(TrueBetaSetting)
	
	case 1
		gamma = -1/3;  alpha = 1/5;  s_prop = 1/5;
		lambda = 0.1;  epsilon_0 = 1e-7;  IterMax = 500;
	
	case 2
		gamma = -1/2;  alpha = 1/5;  s_prop = 1/5;
		lambda = 0.1;  epsilon_0 = 1e-7;  IterMax = 500;
		
	case 3
		gamma = -2/3;  alpha = 1/3;  s_prop = 1/5;
		lambda = 0.1;  epsilon_0 = 1e-7;  IterMax = 500;
		
	case 4
		gamma = -2/3;  alpha = 1/3;  s_prop = 1/5;
		lambda = 10;  epsilon_0 = 1e-7;  IterMax = 500;
	
	case 5
		gamma = -2/3;  alpha = 1/3;  s_prop = 1/5;
		lambda = 200;  epsilon_0 = 1e-7;  IterMax = 500;
		
	case 6
		gamma = -1/3;  alpha = gamma+0.05;  s_prop = 1/5;
		lambda = 200;  epsilon_0 = 1e-7;  IterMax = 500;
		
		
end
		

n_vec = [50,12800];

gradient_time_mat = [];
gradient_error_mat = [];
gradient_relative_error_mat = [];
Newton_time_mat = [];
Newton_error_mat = [];
Newton_relative_error_mat = [];


font_size = 20;

Nexp = 1;

for(n_index = 1:length(n_vec))
	
	n = n_vec(n_index);
	
	for(exp_index = 1:Nexp)		
		s = floor(s_prop * n);		
		%%% Set up beta parameters
		beta_true = zeros(n,1);
			beta_true(1:s) = alpha*log(n);
			beta_true((s+1):n) = gamma*log(n);
		%%% Generate network
		W = beta_true*ones(1,n);  W = W + W';  W = 1./(1+exp(-W));  W = W-diag(diag(W));
		A = generate_A(W);

		d_vec = sum(A);
        deg = d_vec';
		stepsize = 1;	
		IterMax = 1500;
        iter_actual = IterMax;
		tic;
		beta_0 = log(d_vec+1)-mean(log(d_vec+1));
		[beta_est, beta_history] = Fast_gradient_method(deg, beta_0, lambda, IterMax, stepsize);			
		if(exp_index==1)
            figure('Visible','on')
			TmpMat = beta_history-beta_est*ones(1,iter_actual);
			ConvVec = sqrt(mean(TmpMat.^2,1));
			fig = plot(1:500, ConvVec(1:500), 'r-o');
			xlabel('Iteration $t$', 'Interpreter','Latex','FontSize', font_size);
			ylabel('$n^{-1/2}\cdot\|\hat\beta_\lambda^{(t)}-\hat\beta_\lambda\|_2$', 'interpreter','latex', 'FontSize', font_size);
			xticks(100:100:500);  xticklabels(100:100:500);
            xlim([0,500]) 
			set(gca,'fontsize',font_size);		
			saveas(fig, sprintf('./plots/Setting_%d_gradient_iteration_%d.png', TrueBetaSetting,n));
		end
		

		tic;
        IterMax = 500;
        iter_actual = IterMax;
		beta_0 = zeros(n,1);
		[beta_est, beta_history] = Fast_Newton_method(deg, beta_0, lambda, IterMax);
		
		if(exp_index==1)
            figure('Visible','on')
			TmpMat = beta_history-beta_est*ones(1,iter_actual);
			ConvVec = sqrt(mean(TmpMat.^2,1));
			fig = plot(1:10, ConvVec(1:10), 'r-o');
			xlabel('Iteration $t$', 'Interpreter','Latex', 'FontSize', font_size);
			ylabel('$n^{-1/2}\cdot\|\hat\beta_\lambda^{(t)}-\hat\beta_\lambda\|_2$', 'interpreter','latex', 'FontSize', font_size);
			xticks(2:2:10);  xticklabels(2:2:10);
            a = get(gca,'XTickLabel');  
			set(gca,'XTickLabel',a,'fontsize',font_size);			
            saveas(fig, sprintf('./plots/Setting_%d_Newton_iteration_%d.png', TrueBetaSetting,n));
        end		
    end
end









