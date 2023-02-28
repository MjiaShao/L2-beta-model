
% L2 error rate as n changes
clear

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
	
end
		

n_vec = [50,100,200,400,800,1600,3200,6400,12800];



gradient_time_mat = [];
gradient_error_mat = [];
gradient_relative_error_mat = [];
Newton_time_mat = [];
Newton_error_mat = [];
Newton_relative_error_mat = [];


font_size = 20;

% REMEMBER TO CHANGE NEXP BACK TO 100 LATER
Nexp = 100;


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

		%%% Gradient method

		deg = sum(A);
        deg = deg';
		stepsize = 1;		
		IterMax = 1500;
		tic;
		beta_0 = log(deg+1)-mean(log(deg+1));
        beta_est = ... 
        Fast_gradient_method(deg, beta_0, lambda, IterMax, stepsize);
		gradient_time_mat(n_index, exp_index) = toc;		
		gradient_error_mat(n_index, exp_index) = ...
			norm(beta_est-beta_true)/sqrt(n);
		gradient_relative_error_mat(n_index, exp_index) = ...
			norm(beta_est-beta_true) / norm(beta_true);
			

		IterMax  = 500;
		tic;
		beta_0 = zeros(n,1);
        beta_est = Fast_Newton_method(deg, beta_0, lambda, IterMax);
		Newton_time_mat(n_index, exp_index) = toc;
		Newton_error_mat(n_index, exp_index) = ...
			norm(beta_est-beta_true)/sqrt(n);
		Newton_relative_error_mat(n_index, exp_index) = ...
			norm(beta_est-beta_true) / norm(beta_true);
    end
    
end

save(sprintf("./results/simulation_1_result_setting_%d",TrueBetaSetting), ...
    "Newton_relative_error_mat","Newton_error_mat","Newton_time_mat", ...
    "gradient_relative_error_mat","gradient_error_mat","gradient_time_mat");
end


Gradient_error = [];
Gradient_time = [];
Newton_error = [];
Newton_time = [];

font_size = 20;
MarkerSize = 15;  LineWidth = 2;

for(TrueBetaSetting = 1:6)
    load(sprintf("./results/simulation_1_result_setting_%d",TrueBetaSetting))
	for(n_ind = 1:length(n_vec))
		n = n_vec(n_ind);
		Gradient_error(:,n_ind) = gradient_relative_error_mat(n_ind,:);
		Gradient_time(:,n_ind) =  gradient_time_mat(n_ind,:);
		Newton_error(:,n_ind) = Newton_relative_error_mat(n_ind,:);
		Newton_time(:,n_ind) = Newton_time_mat(n_ind,:);
	end
	
	fig = figure('visible','on');
	plot1 = shadedErrorBar(1:length(n_vec),...
		mean(log(Gradient_error)),...
		std(log(Gradient_error)),...
		{'r-o'},1);
	hold on;
	plot2 = shadedErrorBar(1:length(n_vec),...
		mean(log(Newton_error)),...
		std(log(Newton_error)),...
		{'k--x'},1);
	hold off;
	xlabel('Network size $n$', 'interpreter','latex', 'FontSize', font_size);
	xlim([1 length(n_vec)]);  xticks(1:length(n_vec));  xticklabels(n_vec);
	a = get(gca,'XTickLabel');  
	set(gca,'XTickLabel',a,'fontsize',font_size)
	ylabel('$\log(\|\hat\beta_\lambda-\beta^*\|_2/\|\beta^*\|_2)$','interpreter','latex','fontsize',font_size);
	legend([plot1.mainLine,plot2.mainLine], 'Gradient','Newton','location','northeast');
	plot1.mainLine.MarkerSize = MarkerSize;  plot2.mainLine.MarkerSize = MarkerSize;
	plot1.mainLine.LineWidth = LineWidth;    plot2.mainLine.LineWidth = LineWidth;
	set(gca,'fontsize',font_size);
	saveas(fig, sprintf('./plots/Setting_%d_error.png',TrueBetaSetting));
	
	
	
	fig = figure('visible','on');
	plot1 = shadedErrorBar(1:length(n_vec),...
		mean(log(Gradient_time)),...
		std(log(Gradient_time)),...
		{'r-o'},1);
	hold on;
	plot2 = shadedErrorBar(1:length(n_vec),...
		mean(log(Newton_time)),...
		std(log(Newton_time)),...
		{'k--x'},1);
	hold off;
	xlabel('Network size $n$', 'interpreter','latex', 'FontSize', font_size);
	xlim([1 length(n_vec)]);  xticks(1:length(n_vec));  xticklabels(n_vec);
	a = get(gca,'XTickLabel');  
	set(gca,'XTickLabel',a,'fontsize',font_size)
	ylabel('Log(time)','fontsize',font_size);
	legend([plot1.mainLine,plot2.mainLine], 'Gradient','Newton','location','northwest');
	plot1.mainLine.MarkerSize = MarkerSize;  plot2.mainLine.MarkerSize = MarkerSize;
	plot1.mainLine.LineWidth = LineWidth;    plot2.mainLine.LineWidth = LineWidth;
	set(gca,'fontsize',font_size);
	saveas(fig, sprintf('./plots/Setting_%d_time.png',TrueBetaSetting));
	
end






