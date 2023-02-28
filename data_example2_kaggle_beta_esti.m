clear
df1 = readtable('./data/kg_Table.txt');
in_cord19 = readmatrix('./data/kg_in_cord19.txt');
deg_vec = df1.degree;
d_dict = df1.DOI;
nation_label = [df1.Other,df1.China,df1.USA,df1.UK,df1.EU,df1.JpKr,df1.India];

n = length(deg_vec);
deg_vec(deg_vec<=0) = [];
d_tab = tabulate(deg_vec);   
d_tab(d_tab(:,2)==0,:) = [];
[~,ord] = sort(d_tab(:,1),'descend');
d_tab = d_tab(ord,:);
deg_freq = d_tab(:,2); % vector of n_k's
linewidth = log(deg_freq)/log(10000000)+1;
beta_0 = zeros(size(deg_vec)); epsilon_0 = 1e-5;

% plot beta_lambda track over lambda values
beta_track = [];
delta_track = [];
aic_list = [];
lambda_vec = [0,1,2.5,5,10,20,40,80, 160, 320, 640,1280];
for(lambda_idx = 1:length(lambda_vec))
     stepsize = 1;    	
     [beta_track(:,lambda_idx), ~, delta_history] = ...
            Fast_Newton_method(deg_vec, beta_0, lambda_vec(lambda_idx), 100);
    delta_track(:,lambda_idx) = delta_history(:,end);
    aic_list(lambda_idx) = AIC_criterion_function(deg_vec, beta_track(:,lambda_idx), lambda_vec(lambda_idx));
end

fig = figure('visible','on');
for i = 1:size(delta_track,1)
    plot(1:length(lambda_vec),...
	    delta_track(i,:), 'k-',...
        'LineWidth',linewidth(i));
    hold on
end
hold off
xticks(1:length(lambda_vec)); xticklabels(lambda_vec);
xlabel('$\lambda$', 'interpreter','latex');
xlim([1,length(lambda_vec)])
ylabel('$\widehat\beta_\lambda$', 'interpreter','latex');
set(gca,'fontsize',15);
saveas(fig, sprintf("./plots/kaggle_beta_track.png"))

font_size = 18;  MarkerSize = 15;  LineWidth = 2;
fig = figure('visible','on');
plot1 = plot(1:length(lambda_vec),...
	aic_list,...
	'k-o');
xticks(1:length(lambda_vec)); xticklabels(lambda_vec);
xlabel('Penalty scale $\lambda$', 'interpreter','latex', 'FontSize', font_size);
ylabel('AIC','interpreter','latex', 'FontSize', font_size);
xlim([1,length(lambda_vec)])
plot1.MarkerSize = MarkerSize; 
plot1.LineWidth = LineWidth; 
set(gca,'fontsize',font_size);
saveas(fig, sprintf("./plots/kaggle_aic.png"))

beta_est = ...
            Fast_Newton_method(deg_vec, beta_0, 0, 100);
save('./results/kaggle_beta_est','beta_est')