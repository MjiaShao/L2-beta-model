function beta = generate_beta(n,type,a,b,p)
    switch type 
        case 'binom'
            nidx = floor(n*p);
            label = 1:nidx;
            beta = ones(n,1)*(a*log(n));
            beta(label,1) = b*log(n);
        case 'unif'
            beta = rand(n,1)*(b-a)+a;
    end	
end
