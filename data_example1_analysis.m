rng(2608)

%%%%%%%% data 3: COVID-19 student social network
% paper: https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0236337#sec025
% data:  https://osf.io/muknv/

DataName = "COVID-19-student-network";

var_names = ["studentindex",...
			"gender","depression","anxiety","stress","loneliness",...
			"friend","p.interaction","multi-support"];

Table_marginal_2019_09 = readmatrix('./data/marginal-2019-09.csv');
Table_marginal_2020_04 = readmatrix('./data/marginal-2020-04.csv');


Table_marginal_2019_09_temp = Table_marginal_2019_09;
Table_marginal_2019_09_temp(:,9:11) = [];
Table_marginal_2019_09_temp(:,9) = sum(Table_marginal_2019_09(:,9:11),2);
Table_marginal_2019_09 = Table_marginal_2019_09_temp;

Table_marginal_2020_04_temp = Table_marginal_2020_04;
Table_marginal_2020_04_temp(:,9:11) = [];
Table_marginal_2020_04_temp(:,9) = sum(Table_marginal_2020_04(:,9:11),2);
Table_marginal_2020_04 = Table_marginal_2020_04_temp;


k = [0:0.5:6];
lambdalist = exp(k)-1; 
epsilon_0 = 1e-3;
IterMax = 2000; stepsize = 1;


output_marginal_2019_09 = zeros(size(Table_marginal_2019_09,1),size(Table_marginal_2019_09,2),length(k));
aic_2019_09 = [];
for(lambdaindex = 1:length(lambdalist))
lambda = lambdalist(lambdaindex);
    for(icol = 7:9)
        deg = Table_marginal_2019_09(:,icol);
        idx = find(Table_marginal_2019_09(:,icol)~=0);
        deg = deg(idx);
        n = length(deg);
        beta_0 = zeros(n,1);
    	beta_est = ...
    		Fast_gradient_method(deg, beta_0, lambda, IterMax, stepsize);
    	aic_2019_09(icol,lambdaindex) = AIC_criterion_function(deg, beta_est, lambda);
    	output_marginal_2019_09(idx,icol,lambdaindex) = beta_est;
    end
end

output_marginal_2020_04 = zeros(size(Table_marginal_2020_04,1),size(Table_marginal_2020_04,2),length(k));
aic_2020_04  = [];
for(lambdaindex = 1:length(lambdalist))
lambda = lambdalist(lambdaindex);
    for(icol = 7:9)
        deg = Table_marginal_2020_04(:,icol);
        idx = find(Table_marginal_2020_04(:,icol)~=0);
        deg = deg(idx);
        n = length(deg);
        beta_0 = zeros(n,1);
    	beta_est = ...
    		Fast_gradient_method(deg, beta_0, lambda, IterMax, stepsize);
    	aic_2020_04(icol,lambdaindex) = AIC_criterion_function(deg, beta_est, lambda);
    	output_marginal_2020_04(idx,icol,lambdaindex) = beta_est;
    end
end
save(sprintf("./results/mental_lambda_sensitivity"),'output_marginal_2019_09', 'output_marginal_2020_04', 'aic_2019_09', 'aic_2020_04')

q = Table_marginal_2019_09(:,8:9)  > 0;
idx19 = find(sum(q,2)==2);
Table_marginal_2019_09 = Table_marginal_2019_09(idx19,:);

q = Table_marginal_2020_04(:,8:9)  > 0;
idx20 = find(sum(q,2)==2);
Table_marginal_2020_04 = Table_marginal_2020_04(idx20,:);


Combined_table = [];
count = 1;
Common_index = [];
for(nn = 1:length(Table_marginal_2019_09))
	pos=find(Table_marginal_2020_04(:,1)==Table_marginal_2019_09(nn,1));
	if length(pos)>=1
		Combined_table(count,:,1) = Table_marginal_2019_09(nn,:);
		Combined_table(count,:,2) = Table_marginal_2020_04(pos(1),:);
		Common_index(count)       = Table_marginal_2019_09(nn,1);
		count = count + 1;
	end
end

aic_2019_09 = aic_2019_09(7:9,:);
aic_2020_04 = aic_2020_04(7:9,:);
[~, minindex] = min(aic_2019_09,[],2);
output_marginal_2019_09_temp = [];
output_marginal_2019_09_temp(:,1:6) = Table_marginal_2019_09(:,1:6);
for inx = 7:9
    output_marginal_2019_09_temp(:,inx) = output_marginal_2019_09(idx19,inx,minindex(inx-6));
end
output_marginal_2019_09 = output_marginal_2019_09_temp;

[~, minindex] = min(aic_2020_04,[],2);
output_marginal_2020_04_temp = [];
output_marginal_2020_04_temp(:,1:6) = Table_marginal_2020_04(:,1:6);
for inx = 7:9
    output_marginal_2020_04_temp(:,inx) = output_marginal_2020_04(idx20,inx,minindex(inx-6));
end
output_marginal_2020_04 = output_marginal_2020_04_temp;

output_diff = [];
for(nn = 1:length(Common_index))
	x1 = find( (output_marginal_2019_09(:,1)==Common_index(nn)) );
	x2 = find( (output_marginal_2020_04(:,1)==Common_index(nn)) );
	output_diff(nn,3:9) = output_marginal_2020_04(x2,3:9) - output_marginal_2019_09(x1,3:9);
	output_diff(nn,1:2) = output_marginal_2020_04(nn,1:2);
end


output_marginal_2019_09(:,3:9) = normalize(output_marginal_2019_09(:,3:9),1);
output_marginal_2020_04(:,3:9) = normalize(output_marginal_2020_04(:,3:9),1);
output_diff(:,3:9)    = normalize(output_diff(:,3:9),1);


writematrix(output_marginal_2019_09,'./results/output_marginal_2019_09.csv') 
writematrix(output_marginal_2020_04,'./results/output_marginal_2020_04.csv') 
writematrix(output_diff,'./results/output_diff.csv') 

