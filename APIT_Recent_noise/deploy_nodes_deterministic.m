
function [X, Indices] = deploy_nodes_deterministic()

%deploy_nodes_random computes the positions of random nodes knowing
%the number of anchors and blindfolded devices
%Output parameters: X-> positions of the nodes
%Indices-> nodes (e.g. 1, 3, 5, 7) which are anchors


global M N 

%Size of the grid
Grid=10; %10
i=1;
m=1;
X=[];

%for k=1:0.5:10
%    for l=1:10
%            A(m,:)=[k l];
%            m=m+1;
%    end 
%end
A=[1 4; 3 4; 2 3; 1 2; 3 2; 1 9; 3 9; 2 8; 1 7; 3 7; 6 9; 8 9; 7 8; 6 7; 8 7; 6 4; 8 4; 7 3; 6 2; 8 2];
for x=1:10
    for y=1:10
        if(isempty(find(A(:,1)==x & A(:,2)==y))==1)
            X(i,:)=[x y];
            i=i+1;
        end
    end
end
[N y]=size(A);
[M y]=size(X);
X=[A;X];
%We suppose that the first N elements belongs to anchors, thus the indices
%for the anchors run from the first 1 to N elements
Indices=[1:N]';

%Plot deployment
figure(1);
%Anchors in square and red
plot(A(:,1),A(:,2),'rs','MarkerFaceColor','r') 
hold on;
plot(X(:,1),X(:,2),'bo');
labels = num2str((1:(M+N))'); 
%For labelling each sensor
text(X(:,1)+.06,X(:,2),labels,'Color','r'); 
