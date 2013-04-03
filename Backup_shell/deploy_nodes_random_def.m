
function [X, Indices, Radio_approx] = deploy_nodes_random_def()

%deploy_nodes_random computes the positions of random nodes knowing
%the number of anchors and blindfolded devices
%Output parameters: X-> positions of the nodes
%Indices-> nodes (e.g. 1, 3, 5, 7) which are anchors


global M N 
%Counters
cont=1;

%Size of the grid
Grid=10; 

a=zeros(N/4,1);
b=5.*ones(N/4,1);
A1x=a+((b-a).*rand(N/4,1));
A1y=a+((b-a).*rand(N/4,1));
A1=[A1x A1y];

a=zeros(N/4,1);
b=5.*ones(N/4,1);
A2x=a+((b-a).*rand(N/4,1));
a=5.*ones(N/4,1);
b=Grid.*ones(N/4,1);
A2y=a+((b-a).*rand(N/4,1));
A2=[A2x A2y];

a=5.*ones(N/4,1);
b=Grid.*ones(N/4,1);
A3x=a+((b-a).*rand(N/4,1));
a=zeros(N/4,1);
b=5.*ones(N/4,1);
A3y=a+((b-a).*rand(N/4,1));
A3=[A3x A3y];

a=5.*ones(N/4,1);
b=Grid.*ones(N/4,1);
A4x=a+((b-a).*rand(N/4,1));
a=5.*ones(N/4,1);
b=Grid.*ones(N/4,1);
A4y=a+((b-a).*rand(N/4,1));
A4=[A4x A4y];

a=zeros(M/4,1);
b=5.*ones(M/4,1);
X1x=a+((b-a).*rand(M/4,1));
X1y=a+((b-a).*rand(M/4,1));
X1=[X1x X1y];

a=zeros(M/4,1);
b=5.*ones(M/4,1);
X2x=a+((b-a).*rand(M/4,1));
a=5.*ones(M/4,1);
b=Grid.*ones(M/4,1);
X2y=a+((b-a).*rand(M/4,1));
X2=[X2x X2y];

a=5.*ones(M/4,1);
b=Grid.*ones(M/4,1);
X3x=a+((b-a).*rand(M/4,1));
a=zeros(M/4,1);
b=5.*ones(M/4,1);
X3y=a+((b-a).*rand(M/4,1));
X3=[X3x X3y];

a=5.*ones(M/4,1);
b=Grid.*ones(M/4,1);
X4x=a+((b-a).*rand(M/4,1));
a=5.*ones(M/4,1);
b=Grid.*ones(M/4,1);
X4y=a+((b-a).*rand(M/4,1));
X4=[X4x X4y];

A=[A1;A2;A3;A4];
X=[X1;X2;X3;X4];

X=[A;X];

%With the function random it generates uniform distribution random
%variables with the size specified by the 4th and 5th elements
%If a=Grid and b=0
%a=Grid;
%b=0;
%X(:,1)=a+((b-a).*rand(M,1)); %Generates uniform dist [0 Grid]
%X(:,2)=a+((b-a).*rand(M,1));
%A(:,1)=a+((b-a).*rand(N,1));
%A(:,2)=a+((b-a).*rand(N,1));

%A=random('Uniform',0,Grid,N,2);
%X=random('Uniform',0,Grid,M,2);
%X=[A;X];
%We suppose that the first N elements belongs to anchors, thus the indices
%for the anchors run from the first 1 to N elements
Indices=[1:N]';

Radio_approx=1.5;

%Plot deployment
%figure(1);
%Anchors in square and red
%plot(A(:,1),A(:,2),'rs','MarkerFaceColor','r') 
%hold on;
%plot(X(:,1),X(:,2),'bo');
%labels = num2str((1:(M+N))'); 
%For labelling each sensor
%text(X(:,1)+.06,X(:,2),labels,'Color','r'); 
