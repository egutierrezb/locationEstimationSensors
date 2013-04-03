function [TableNodesOutside]=createTNodesoutside(Indices,Neighborhood, TableNodesInside, TableNodesOutsidetemp)
%Routine to know if a node is not in TableNodesInside, then we can not
%estimate the position of the node since for all its combinations of the
%triangles the node is considered outside of them, so it doesnt make sense
%to estimate its position for triangles in which is outside
TableNodesOutside=[];
temp=1;
global M N
for i=1:(M+N)
    %Only target nodes!
    if (isempty(find(Indices==i))==1)  & (isempty(find(Neighborhood(:,1)==i))==0)
        %If the node is not located in TableNodesInside->matrix
        %empty->we can not estimate that node
       if (isempty(find(TableNodesInside(:,1)==i))==1)
           Nodeswecannotestimate(temp,:)=i;
           temp=temp+1;
       end
    end
end
%Now we should eliminate those rows in which the first column is i
[sizeNwecannotest y]=size(Nodeswecannotestimate);
for i=1:sizeNwecannotest
    %We make to zero the rows which match with the nodes we can not
    %estimate
    Match=find(TableNodesOutsidetemp(:,1)==Nodeswecannotestimate(i,1));
    [Matchsizex y]=size(Match);
    if(isempty(Match)==0)
        TableNodesOutsidetemp(Match,:)=zeros(Matchsizex, 4);
    end
end
temp=1;
[sizeTableNOt y]=size(TableNodesOutsidetemp);
%Routine to create TableNodesOutside with the nodes we can estimate only
for i=1:sizeTableNOt
    if((TableNodesOutsidetemp(i,1)~=0 & TableNodesOutsidetemp(i,2)~=0 & TableNodesOutsidetemp(i,3)~=0 & TableNodesOutsidetemp(i,4)~=0))
        TableNodesOutside(temp,:)=TableNodesOutsidetemp(i,:);
        temp=temp+1;
    end
end
