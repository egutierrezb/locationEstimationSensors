%X=a+(b-a)R
%R is a random number from the uniform dist. [0 1]
%X is going to be / [-1 1]
%X should be Weibull according to the paper of He. not uniform

DOIv=0.3;
%a=-1*ones(360,1);
%b=ones(360,1);
%RAND=a+((b-a).*rand(360,1)); %Generates uniform dist [-1 1]

%beta=1.01*ones(360,1); 
%alfa=0.17*ones(360,1); 
%RANDt=rand(360,1);
%RAND=alfa.*((-log(1-RANDt)).^(1./beta));

%We are going to generate 360 values which belong to the different 360 i
%directions
RAND=wblrnd(0.16,0.67,360,1);
%wblrnd(A,B,m,n)
%A is the scale
%B is the shape
K=zeros(360,1);
for i=1:360
    if i==1
        K(i,1)=1; %Ki=1, i=1
    else
        K(i,1)=K(i-1,1)+(wblrnd(0.16,0.67,1,1)*DOIv); %Ki, for i~=1
    end
end
K(i+1,1)=1;
t=0:pi/180:2*pi %pi/180 equals to 1 degree
polar(t,K');
%hold on;
%Reference distance
do=1; %[m]
%Reference power at do
P0=-37.466; %[dBm]
%Propagation exponent
np=2.3;
%Compute the matrix of the mean power for every pair [i,j] of nodes. 
distr=2;
Pij=10*np*log10(distr.*(1/do));
for i=1:361
    RSSe(i,:)=P0-(Pij*K(i,1));
end    
figure(2);
t=0:pi/180:2*pi; %per degree
polar(t,RSSe');

