
function A = generate_A(W)
	
	n = size(W, 1);
	A = rand(n, n);  A = A<W;  
    A = triu(A,1);  
    A = (A+A')>0.5;  
    A = A-diag(diag(A));
	
end