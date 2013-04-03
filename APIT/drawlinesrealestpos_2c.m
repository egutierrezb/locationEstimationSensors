function Xnodes=drawlinesrealestpos_2c(Estimatedcoordinates,X)

%drawlinesrealestpos is a function which draws lines between the estimated
%positions of the nodes and the true positions of the nodes
%Input coordinates: Estimatedcoordinates-> Estimated positions of the nodes
%X-> True positions of the nodes
%Xnodes-> True positions of the nodes (reallocation the columns)

global M N

nodes=1:1:(M+N);
X(:,3)=nodes';

%Xnodes has the following format Xnodes=[Num_node Xpos Ypos] 
Xnodes(:,1)=X(:,3);
Xnodes(:,2)=X(:,1);
Xnodes(:,3)=X(:,2);

for i=1:(M+N)
    Match_e=find(Estimatedcoordinates(:,1)==i); %The node is in Estimatedcoordinates matrix
    Match_x=find(Xnodes(:,1)==i); %The node is in 
    %line([Estimatedcoordinates(Match_e,2) Xnodes(Match_x,2)],[Estimatedcoordinates(Match_e,3) Xnodes(Match_x,3)],'Color','m','LineStyle','--');
end