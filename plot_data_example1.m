mental_subset = 3:6;
var_names  =["depression","anxiety","stress","loneliness",...
			"p.interaction","multi.support"];
CCA_output_2019 = readmatrix('./results/sparse_CCA_2019_09.csv');
CCA_output_2020 = readmatrix('./results/sparse_CCA_2020_04.csv');
CCA_output_diff = readmatrix('./results/sparse_CCA_diff.csv');
for icol = 1:size(CCA_output_2019,2)
    if sign(CCA_output_2019(6,icol))==-1
        CCA_output_2019(:,icol) =  CCA_output_2019(:,icol)*(-1);
    end
    if sign(CCA_output_2019(5,icol))==-1
        CCA_output_2019(:,icol) =  CCA_output_2019(:,icol)*(-1);
    end
end
for icol = 1:size(CCA_output_2020,2)
    if sign(CCA_output_2020(6,icol))==-1
        CCA_output_2020(:,icol) =  CCA_output_2020(:,icol)*(-1);
    end
    if sign(CCA_output_2020(5,icol))==-1
        CCA_output_2020(:,icol) =  CCA_output_2020(:,icol)*(-1);
    end
end
for icol = 1:size(CCA_output_diff,2)
    if sign(CCA_output_diff(6,icol))==-1
        CCA_output_diff(:,icol) =  CCA_output_diff(:,icol)*(-1);
    end
    if sign(CCA_output_diff(5,icol))==-1
        CCA_output_diff(:,icol) =  CCA_output_diff(:,icol)*(-1);
    end
end

fw = fopen('./results/output_CCA_table.txt', 'w');
fprintf(fw, 'Variable & CC1 & p-val.& CC2 & p-val.& CC1 & p-val. & CC2 & p-val. &  CC1 & p-val. &  CC2 & p-val.\\\\\\hline\n');
for(irow = 1:size(CCA_output_2019,1))
	fprintf(fw, '%s & %1.3f & (%1.3f) & %1.3f & (%1.3f) & %1.3f & (%1.3f) & %1.3f  & (%1.3f) & %1.3f & (%1.3f) & %1.3f & (%1.3f)\\\\\n', ...
		var_names(irow),...
		CCA_output_2019(irow,:),...
		CCA_output_2020(irow,:),...
		CCA_output_diff(irow,:)...
	);
	if(irow==1 | irow==length(mental_subset))
		fprintf(fw, '\\hline\n');
	end
end
fprintf(fw,'\\hline');
fclose(fw);



clear

%%% SENSITIVITY ANALYSIS
% model estimation
k = [0:0.5:6];
lambda_vec = exp(k)-1; 
load("./results/mental_lambda_sensitivity.mat")
sens_output_marginal_2019_09 = output_marginal_2019_09(:,7:9,:);
sens_output_marginal_2020_04 = output_marginal_2020_04(:,7:9,:);
var_names = ["studentindex",...
			"gender","depression","anxiety","stress","loneliness",...
			"friend","p.interaction","multi-support"];

colors={'k','r','b'};

fig = figure;
ppp = {};
for(kk = 1:3)
    sens_output_marginal_2019_09_temp = reshape(sens_output_marginal_2019_09(:,kk,:),[size(sens_output_marginal_2019_09,[1,3])]);
    sens_output_marginal_2019_09_temp = sens_output_marginal_2019_09_temp(find(~all(sens_output_marginal_2019_09_temp==0,2)),:);
	for(ii = 1:size(sens_output_marginal_2019_09_temp(:,kk,:),1))
		if(ii == 1)
            temp1 = sens_output_marginal_2019_09_temp(ii,:); 
			ppp{kk} = plot(1:length(lambda_vec), sens_output_marginal_2019_09_temp(ii,:), colors{kk}, 'DisplayName',var_names{kk});
			hold on;
		else
			plot(1:length(lambda_vec), sens_output_marginal_2019_09_temp(ii,:), colors{kk});
		end
    end

	ann = annotation('textbox',[0.14,0.81,0.35,0.09],'String', sprintf('2019-09'),'fontsize',28);
    ann.VerticalAlignment = 'middle';
    ann.HorizontalAlignment = 'center';
	xticks(1:length(lambda_vec)); xticklabels(round(lambda_vec,1));
    xlim([1, length(lambda_vec)])
    ylim([-3.8,0.5])
    yticks(-3:1:0);  yticklabels(-3:1:0);
	xlabel('$\lambda$', 'interpreter','latex');
	ylabel('$\widehat\beta_\lambda$', 'interpreter','latex');
	set(gca,'fontsize',15);
    title('Sensitivity analysis of $\hat \beta_\lambda$', 'interpreter','latex','fontsize',20)
end
hold off;
legend([ppp{1:3}],var_names{7:9},'location','southeast');
saveas(fig, './plots/output_sensitivity_beta_2019_09.png')



fig = figure;
ppp = {};
for(kk = 1:3)
    sens_output_marginal_2020_04_temp = reshape(sens_output_marginal_2020_04(:,kk,:),[size(sens_output_marginal_2020_04,[1,3])]);
	sens_output_marginal_2020_04_temp = sens_output_marginal_2020_04_temp(find(~all(sens_output_marginal_2020_04_temp==0,2)),:);
	for(ii = 1:size(sens_output_marginal_2020_04_temp(:,kk,:),1))

        if(ii == 1)
            
			ppp{kk} = plot(1:length(lambda_vec), sens_output_marginal_2020_04_temp(ii,:), colors{kk}, 'DisplayName',var_names{kk});
			hold on;
		else
			plot(1:length(lambda_vec), sens_output_marginal_2020_04_temp(ii,:), colors{kk});
		end
    end
	ann = annotation('textbox',[0.14,0.81,0.35,0.09],'String', sprintf('2020-04'),'fontsize',28);
    ann.VerticalAlignment = 'middle';
    ann.HorizontalAlignment = 'center';
	xticks(1:length(lambda_vec)); xticklabels(round(lambda_vec,1));
    xlim([1, length(lambda_vec)])
    ylim([-3.8,0.5])
    yticks(-3:1:0);  yticklabels(-3:1:0);
	xlabel('$\lambda$', 'interpreter','latex');
	ylabel('$\widehat\beta_\lambda$', 'interpreter','latex');
	set(gca,'fontsize',15);
    title('Sensitivity analysis of $\hat \beta_\lambda$', 'interpreter','latex','fontsize',20)
end
hold off;
saveas(fig, './plots/output_sensitivity_beta_2020_04.png')


clear
k = [0:0.5:6];
lambdalist = exp(k)-1; 
load("./results/mental_lambda_sensitivity.mat")
lambda_vec = lambdalist;
var_names = ["studentindex",...
			"gender","depression","anxiety","stress","loneliness",...
			"friend","p.interaction","multi-support"];
var_names2 = ["studentindex",...
			"gender","depression","anxiety","stress","loneliness",...
			"friend network","interaction network","support network"];

font_size = 15;  MarkerSize = 15;  LineWidth = 2;
for i= 7:9
    fig = figure('visible','on');
    plot1 = plot(log(lambdalist+1), aic_2019_09(i,:), 'k--o');
	ann = annotation('textbox',[0.15,0.81,0.35,0.09],'String', sprintf('2019-09'),'fontsize',28);
    ann.VerticalAlignment = 'middle';
    ann.HorizontalAlignment = 'center';
    xlim([0 log(max(lambdalist)+1)]);  xticks(log(lambdalist+1));  xticklabels(round(lambdalist,2));
    xlabel('Penalty scale $\lambda$', 'interpreter','latex', 'FontSize', font_size);
    ylabel('AIC','interpreter','latex', 'FontSize', font_size);
    plot1.MarkerSize = MarkerSize; 
    plot1.LineWidth = LineWidth;       
    a = get(gca,'XTickLabel');  
    set(gca,'XTickLabel',a,'fontsize',font_size);
    title(sprintf("AIC plot for %s",var_names2(i)), 'interpreter','latex','fontsize',20)
    saveas(fig, sprintf('./plots/mental_2019_tuning_lambda_AIC_%s.png',var_names(i)));
end


for i= 7:9
    fig = figure('visible','on');
    plot1 = plot(log(lambdalist+1), aic_2020_04(i,:), 'k--o');
	ann = annotation('textbox',[0.15,0.81,0.35,0.09],'String', sprintf('2020-04'),'fontsize',28);
    ann.VerticalAlignment = 'middle';
    ann.HorizontalAlignment = 'center';
    xlim([0 log(max(lambdalist)+1)]);  xticks(log(lambdalist+1));  xticklabels(round(lambdalist,2));
    xlabel('Penalty scale $\lambda$', 'interpreter','latex', 'FontSize', font_size);
    ylabel('AIC','interpreter','latex', 'FontSize', font_size);
    plot1.MarkerSize = MarkerSize; 
    plot1.LineWidth = LineWidth;      
    a = get(gca,'XTickLabel');  
    set(gca,'XTickLabel',a,'fontsize',font_size);
    title(sprintf("AIC plot for %s",var_names2(i)), 'interpreter','latex','fontsize',20)
    saveas(fig, sprintf('./plots/mental_2020_tuning_lambda_AIC_%s.png',var_names(i)));
end

