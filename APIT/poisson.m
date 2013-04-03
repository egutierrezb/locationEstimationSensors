function y=poisson(n,mu)

%POISSON Generate Poisson random numbers

%according to the inversion method.

 

x=rand(1,n);

% sample

% Calculate Poison CDF

exp_mu = exp(-mu);

CDF(1) = exp_mu;

for k = 2:50

p(k) = mu^k*exp_mu/factorial(k);

CDF(k) = p(k)+CDF(k-1);

end

% Generate Poisson-distributed random numbers

% using the inversion method.

for i = 1:n

temp=find(CDF >= x(i));

if size(temp,2) == 0

y(i) = 0;

else

y(i) = temp(1)-1;

end

end

  
