
function [X, Indices, Radio_approx] = deploy_nodes_random_def()

%deploy_nodes_random computes the positions of random nodes knowing
%the number of anchors and blindfolded devices
%Output parameters: X-> positions of the nodes
%Indices-> nodes (e.g. 1, 3, 5, 7) which are anchors


global M N 
%Counters
cont=1;

%Size of the grid
Grid=10; %10
%Distribution uniform described in the paper, the area is divided into
%grids, and the nodes are evenly distributed on these grids
A1x=random('Uniform',0,5,N/4,1);
A1y=random('Uniform',0,5,N/4,1);
A1=[A1x A1y];

A2x=random('Uniform',0,5,N/4,1);
A2y=random('Uniform',5,10,N/4,1);
A2=[A2x A2y];

A3x=random('Uniform',5,10,N/4,1);
A3y=random('Uniform',0,5,N/4,1);
A3=[A3x A3y];

A4x=random('Uniform',5,10,N/4,1);
A4y=random('Uniform',5,10,N/4,1);
A4=[A4x A4y];

X1x=random('Uniform',0,5,M/4,1);
X1y=random('Uniform',0,5,M/4,1);
X1=[X1x X1y];

X2x=random('Uniform',0,5,M/4,1);
X2y=random('Uniform',5,10,M/4,1);%
X2=[X2x X2y];

X3x=random('Uniform',5,10,M/4,1);
X3y=random('Uniform',0,5,M/4,1);
X3=[X3x X3y];

X4x=random('Uniform',5,10,M/4,1);
X4y=random('Uniform',5,10,M/4,1);
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

Radio_approx=4.57;

%Plot deployment
figure(1);
%Anchors in square and red
plot(A(:,1),A(:,2),'rs','MarkerFaceColor','r') 
hold on;
plot(X(:,1),X(:,2),'bo');
labels = num2str((1:(M+N))'); 
%For labelling each sensor
text(X(:,1)+.06,X(:,2),labels,'Color','r'); 
