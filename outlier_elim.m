function [y] = outlier_elim(x)
	
	m = size(x,1);
	n = size(x,2);
	
	y = zeros(size(x));
	
	if (m>n)
		
		for(iii = 1:n)
			
			xx = x(:,iii);
			mu = mean(xx);
			sd = std(xx);
			med = median(xx);
			IQR = iqr(xx);
			outlier_loc = find(abs(xx-mu)>5*sd | abs(xx-med)>3*IQR);
			xx(outlier_loc) = median(xx);
			
			y(:,iii) = xx;
			
		end
		
	else
		
		for(iii = 1:m)
			
			xx = x(iii,:);
			mu = mean(xx);
			sd = std(xx);
			med = median(xx);
			IQR = iqr(xx);
			outlier_loc = find(abs(xx-mu)>5*sd | abs(xx-med)>3*IQR);
			xx(outlier_loc) = median(xx);
			
			y(iii,:) = xx;
			
		end
		
	end
	
	
end