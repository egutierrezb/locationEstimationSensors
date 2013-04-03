
function [X, Indices, Radio_approx] = deploy_nodes_random()

%deploy_nodes_random computes the positions of random nodes knowing
%the number of anchors and blindfolded devices
%Output parameters: X-> positions of the nodes
%Indices-> nodes (e.g. 1, 3, 5, 7) which are anchors


global M N 
%Counters
cont=1;

%Size of the grid
Grid=10; %10

%--->CODE IN ORDER TO GENERATE RANDOM NUMBERS FROM A UNIFORM DIST [0 x]
%a=zeros(M,1); %M+N - We should generate with the same seed for the total of nodes
%b=Grid*ones(M,1); %M+N

%Using uniform
%X(:,1)=a+((b-a).*rand(M,1)); %Generates uniform dist [0 10]
%X(:,2)=a+((b-a).*rand(M,1));

temp=1;
for i=1:N
   A(temp,:)=[random('Uniform',0,Grid,1,1) random('Uniform',0,Grid,1,1)];
   temp=temp+1;
end
temp=1;
for i=1:M
   X(temp,:)=[random('Uniform',0,Grid,1,1) random('Uniform',0,Grid,1,1)];
   temp=temp+1;
end
X=[A;X];
Indices=[1:N]';
temp=1;

%A=random('Uniform',0,Grid,2*N,1);
%X=random('Uniform',0,Grid,2*M,1);
%temp=1;
%[ma na]=size(A);
%for i=1:2:ma-1
%    A1(temp,:)=[A(i,1) A(i+1,1)];
%    temp=temp+1;
%end
%temp=1;
%[mx nx]=size(X);
%for i=1:2:mx-1
%    X1(temp,:)=[X(i,1) X(i+1,1)];
%    temp=temp+1;
%end
%temp=1;
%X=[];
%X=[A1;X1];
%Indices=[1:N]';

%Alg 0
%c=zeros(N,1);
%d=Grid*ones(N,1);

%Using uniform also for the anchors
%A(:,1)=c+((d-c).*rand(N,1));
%A(:,2)=c+((d-c).*rand(N,1));
%Indices=[1:N]';
%X=[A;X]; %append the first as indices or referece devicesm then the blindfolded devices


%Alg 1: To assume that the anchors are deployed in a uniform deployment
%A(:,1)=X(1:N,1);
%A(:,2)=X(1:N,2);
%Indices=[1:N]';

Radio_approx=1.7;

%Positions for the M+N elements of the sensor network in a grid of 
%X=Grid*rand(M+N,2);

%Alg 2: Choose randomly some nodes as Reference devices or Anchors
%for i=1:N
%    temp=round((M+N)*rand(1,1));
%    Indices(cont,:)=temp;
%    Repetition=find(Indices==temp);
%    [a b]=size(Repetition);
%    if(a>=2 | temp==0)
        %Means that there is more than one of the same random index 
%        temp2=round((M+N)*rand(1,1));
        %To assure that the next number should be different of the
        %previous one.
%        Indices(cont,:)=temp2;
%        Repetition=find(Indices==temp2);
%        [c d]=size(Repetition);
%        while (c>=2 | temp2==0)
%            temp2=round((M+N)*rand(1,1));
%            Indices(cont,:)=temp2;
%            Repetition=find(Indices==temp2);
%            [c d]=size(Repetition);
%        end
%end
%    A(i,:)=X(Indices(cont,:),:);
%    cont=cont+1;
%end

%Plot deployment
figure(1);
%Anchors in square and red
plot(A(:,1),A(:,2),'rs','MarkerFaceColor','r') 
hold on;
plot(X(:,1),X(:,2),'bo');
labels = num2str((1:(M+N))'); 
%For labelling each sensor
text(X(:,1)+.06,X(:,2),labels,'Color','r'); 
