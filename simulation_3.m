
clear
rng(2021)
LambdaRange = exp([0:0.5:8])-1;
plotLambdaRange = exp([0:1:8])-1;
nlambda = length(LambdaRange);
TrueBetaSettinglist=[1,2];
for TrueBetaSetting = TrueBetaSettinglist
    switch TrueBetaSetting
	    
	    case 1
		    gamma = -1/5;  alpha = 1/2;  s_prop = 1/10;
		    n = 500;  epsilon_0 = 1e-5;  IterMax = 100;
            location = "northwest";
	    
	    case 2
		    gamma = -1/3;  alpha = -1/3+0.05;  s_prop = 1/3;
		    n = 500;  epsilon_0 = 1e-5;  IterMax = 300;
            location = "northeast";
	    
    end
    
    s = floor(s_prop * n);
    beta_true = zeros(n,1);
	    beta_true(1:s) = alpha*log(n);
	    beta_true((s+1):n) = gamma*log(n);
    W = beta_true*ones(1,n);  W = W + W';  W = 1./(1+exp(-W));  W = W-diag(diag(W));
    
    
    A = generate_A(W);
    deg_obs = sum(A);  deg_obs = deg_obs(:);
    
    
    Newton_TuningCriterion = zeros(nlambda,1);
    Newton_goodness = zeros(nlambda,1);
    Newton_TrueL2Loss = zeros(nlambda,1);
    beta_track = zeros(n,nlambda);
    
    for(lambda_index = 1:nlambda)
	    
	    lambda = LambdaRange(lambda_index);
	    stepsize = 1;
	    beta_0 = zeros(n,1);
	    beta_est = ...
			    Fast_Newton_method(sum(A)', beta_0, lambda, IterMax);
        W_hat = beta_est*ones(1,n);  W_hat = W_hat + W_hat';  p_hat = 1./(1+exp(-W_hat));  
        A_tilt = (A-p_hat)./((n-1)*p_hat.*(1-p_hat)).^0.5; A_tilt = A_tilt-diag(diag(A_tilt));
        test_stat = n^(2/3)*(abs(eigs(A_tilt,1))-2);
        [pdf,cdf] = tracywidom_appx(test_stat,1);
	    Newton_goodness(lambda_index) = 2*min(cdf, 1-cdf);
	    Newton_TrueL2Loss(lambda_index) = norm(beta_est-beta_true)/norm(beta_true);
	    
	    eb = beta_est*ones(1,n);  eb = eb + eb';  eb = exp(eb);  eb = eb - diag(diag(eb));
	    NegLogLike = sum(sum(log(1+eb)))/2 - sum(beta_est .* deg_obs);
  
        AIC = n*max(deg_obs)/(max(deg_obs)+lambda);    
	    Newton_TuningCriterion(lambda_index) = AIC + NegLogLike;
        beta_track(:,lambda_index) = beta_est;
	    
	    
    end
    
    print_Newton_TuningCriterion1 = (Newton_TuningCriterion - ...
        min(Newton_TuningCriterion)) / range(Newton_TuningCriterion) * max(Newton_goodness);
    print_Newton_TuningCriterion2 = (Newton_TuningCriterion - ...
        min(Newton_TuningCriterion)) / range(Newton_TuningCriterion) * max(Newton_TrueL2Loss);
    
    
    font_size = 18;  MarkerSize = 15;  LineWidth = 2;
    
    fig = figure('visible','on');
    % figure('visible','on');
    plot1 = plot(log(LambdaRange+1), print_Newton_TuningCriterion1, 'k--o');
    hold on;
    plot2 = plot(log(LambdaRange+1), Newton_goodness, 'r-*');
    xlim([0 log(max(LambdaRange)+1)]);  xticks(log(plotLambdaRange+1));  xticklabels(round(plotLambdaRange,2));
    xlabel('Penalty scale $\lambda$', 'interpreter','latex', 'FontSize', font_size);
    ylabel('P-value; AIC($\lambda$)','interpreter','latex', 'FontSize', font_size);
    legend("AIC", "P-value",'Location',location)
    plot1.MarkerSize = MarkerSize;  plot2.MarkerSize = MarkerSize;
    plot1.LineWidth = LineWidth;    plot2.LineWidth = LineWidth;
    a = get(gca,'XTickLabel');  
    set(gca,'XTickLabel',a,'fontsize',font_size);
    xtickangle(45)
    title(sprintf('AIC vs. P-value, Setting %d',TrueBetaSetting), 'interpreter','latex', 'FontSize', font_size)
    saveas(fig, sprintf('./plots/tuning_lambda_Setting_%d.png',TrueBetaSetting));
    
    fig = figure('visible','on');
    % figure('visible','on');
    plot1 = plot(log(LambdaRange+1), print_Newton_TuningCriterion2, 'k--o');
    hold on;
    plot2 = plot(log(LambdaRange+1), Newton_TrueL2Loss, 'b--x');
    xlim([0 log(max(LambdaRange)+1)]);  xticks(log(plotLambdaRange+1));  xticklabels(round(plotLambdaRange,2));
    xlabel('Penalty scale $\lambda$', 'interpreter','latex', 'FontSize', font_size);
    ylabel('$\|\hat\beta_\lambda-\beta^*\|_2/\|\beta^*\|_2$; AIC($\lambda$)','interpreter','latex', 'FontSize', font_size);
    legend("AIC", "$\|\hat\beta_\lambda-\beta^*\|_2/\|\beta^*\|_2$", ...
        'Location',location,'Interpreter','Latex', 'FontSize', font_size)
    plot1.MarkerSize = MarkerSize;  plot2.MarkerSize = MarkerSize;
    plot1.LineWidth = LineWidth;    plot2.LineWidth = LineWidth;
    a = get(gca,'XTickLabel');  
    set(gca,'XTickLabel',a,'fontsize',font_size);
    title(sprintf('AIC vs. $l_2$ errors, Setting %d',TrueBetaSetting), 'interpreter','latex', 'FontSize', font_size)
    xtickangle(45)
    saveas(fig, sprintf('./plots/tuning_lambda_check_Setting_%d.png',TrueBetaSetting));

end
