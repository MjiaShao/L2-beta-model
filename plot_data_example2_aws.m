clear
deg_vec = readmatrix('./data/deg_vec.txt');
deg_vec(deg_vec<=0) = [];
d_tab = tabulate(deg_vec);   
d_tab(d_tab(:,2)==0,:) = [];
[~,ord] = sort(d_tab(:,1),'descend');
d_tab = d_tab(ord,:);
deg_freq = d_tab(:,2); % vector of n_k's
linewidth = log(deg_freq)/log(80)+1;

beta_track = [];
aic_list = [];
lambda_vec = [0,1,2.5,5,10,20,40,80, 160,320, 640,1280];
for lambdainx = 1:length(lambda_vec)
    lambda = lambda_vec(lambdainx);
    load(sprintf("./results/aws_beta_gradient_check_faster_%d",floor(lambda)))
    beta_track(:,lambdainx) = delta_history(end,:)';
    aic_list(lambdainx) = aic;
end
fig = figure('visible','on');
for i = 1:size(beta_track,1)
    plot(1:length(lambda_vec),...
	    beta_track(i,:), 'k-',...
        'LineWidth',linewidth(i));
    hold on
end
hold off
xticks(1:length(lambda_vec)); xticklabels(lambda_vec);
xlabel('$\lambda$', 'interpreter','latex');
xlim([1,length(lambda_vec)])
ylabel('$\widehat\beta_\lambda$', 'interpreter','latex');
set(gca,'fontsize',15);
saveas(fig, sprintf("./plots/aws_beta_track.png"))

font_size = 18;  MarkerSize = 15;  LineWidth = 2;
fig = figure('visible','on');
plot1 = plot(1:length(lambda_vec),...
	aic_list,...
	'k-o', ...
    'LineWidth',2);
xticks(1:length(lambda_vec)); xticklabels(lambda_vec);
xlabel('Penalty scale $\lambda$', 'interpreter','latex', 'FontSize', font_size);
ylabel('AIC','interpreter','latex', 'FontSize', font_size);
xlim([1,length(lambda_vec)])
plot1.MarkerSize = MarkerSize; 
plot1.LineWidth = LineWidth; 
ylabel('AIC', 'interpreter','latex');
set(gca,'fontsize',font_size);
saveas(fig, sprintf("./plots/aws_aic.png"))

load(sprintf("./results/aws_beta_gradient_check_faster_%d",0))
writematrix(beta_est, './results/aws_beta_est.txt', 'Delimiter',',');


