function [InsideorOutside, TableNodesOutside, TableNodesInside, TableNodesOutsidetempo, Nodeswecannotestimate]=drawtriangles_fst_2c(X,Audibleanchors,Pij,Neighborhood,Indices, OldAnchors)

%drawtriangles_fst computes the tables of RSS for each targetNode and its
%Neighborhood. Computes which nodes are inside/outside for each combination of
%the anchors taking into account "determined nodes" (i.e. nodes that have 3
%audible anchors and at least fall in one triangle). Output variables of
%interest: TableNodesInside and TableNodesOutside.
%Input parameters: X-> array with the positions of the nodes
%Audibleanchors-> array with the list of audible anchors for each target
%node
%Neighborhood-> array with the list of neighbors for each target node
%Pij-> array with the power values for each pair-wise interdistance
%Indices-> nodes (e.g. 1, 3 5, 7) which are the anchors.

global M N 
[m n]=size(Audibleanchors);
Anchorstriangle=zeros(1,3);
%Counters
Anchorscounter=0;
temp=1;
temp2=1;
temp3=1;
aux=1;
aux2=1;
aux3=0;
aux4=1;
cont=1;
cont2=1;
cont3=1;
pos=1;
Number_neighbors=0;

%Flag to know if we can estimate the positions of the nodes
Warningflag_impossibleest=1;

InitSubtable_MatrixRSSNeighborhood=1;
EndSubtable_MatrixRSSNeighborhood=3;
InitSubtable_MatrixRSSTargetNode=1;
EndSubtable_MatrixRSSTargetNode=3;
%Counters to know if a neighbor node is further/away than the three anchors
%simultaneously.Therefore, we can know if it resides insider or outside of
%the triangle
Counter_Closer=0;
Counter_Further=0;

%->CODE INTRODUCED
%To accelarate process of search
%Index matrix contains the bounds for each target node. The bounds are
%going to be used for the Neighborhood
for i=1:(M+N) %M+N
     if (isempty(find(Indices==i))==1) & (isempty(find(OldAnchors==i))==1)%We consider only target nodes if(1)
          %Recognize which rows belongs to particular Nodes
          delimitbounds=find(Neighborhood(:,1)==i);
          if(isempty(delimitbounds)==0)
             Index(aux)=delimitbounds(1);
             [r s]=size(delimitbounds);
             Index(aux+1)=delimitbounds(r); %Index=[Renglon de inicio de nodo i, Renglon de fin de nodo i, Renglon de inicio de nodo j, Renglon de fin de nodo j] 
             aux=aux+2;
          end
          delimitbounds=[];
     end
end
%Reinitialize counter
aux=1;
marker_rowneighbori=1;
marker_rowneighbore=2;

%To delimit bounds for searching in the matrix of Neighborhood
%LimitNeighborhoodi=Index(1);
%LimitNeighborhoods=Index(2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:(M+N) %M+N
    %Check out progress of the simulation w/ the number of Target node
    %Only consider target nodes, not anchors  (if 1= mean that it is not an
    %anchor node, it is a target node), and it should check that the target
    %node is a node considered in the Neighborhood, in order to avoid
    %problems with bounds of Index
    %ADDED OldAnchors, means that an oldanchor should not be considered, so
    %if it is not in the matrix, then proceeds
    if (isempty(find(Indices==i))==1)  & (isempty(find(Neighborhood(:,1)==i))==0) & (isempty(find(OldAnchors==i))==1) 
        %-->CODE IN TEST 
        Counterfornodenoestimate=0; %Initialize the counter for the node that can not be estimated
        %-->
        fprintf(1,'--Computing RSSTargetNode and RSSNeighbors Tables for Target Node %d\n',i);
        for j=1:m        
            if i==Audibleanchors(j,1) %Format of audibleanchors: audibleanchors(targetnode,anchor) we want the first column
                Anchorscounter=Anchorscounter+1;
                Anchorstriangle(temp)=Audibleanchors(j,2); %We want the anchor
                temp=temp+1;
            end
        end
        %To fix the size of the anchorstriangle array and prevent bugs
        limit_anchors=temp-1;
        temp=1;
        if Anchorscounter>=3
            %If number of anchors>=3 then we should form a triangle between the
            %anchors
            CombinationTriangles=nchoosek(Anchorstriangle(1:limit_anchors),3); %Combinations=nchoosek(n,k)
            [u v]=size(CombinationTriangles);
            for SetofAnchors=1:u %size of CombinationTriangles
                 %Draw the triangle from the audible anchors for the Target
                 %Node [enable or disable]
                 %line([X(CombinationTriangles(SetofAnchors,1),1) X(CombinationTriangles(SetofAnchors,2),1)],[X(CombinationTriangles(SetofAnchors,1),2) X(CombinationTriangles(SetofAnchors,2),2)],'Color','b','LineStyle','-');
                 %line([X(CombinationTriangles(SetofAnchors,2),1) X(CombinationTriangles(SetofAnchors,3),1)],[X(CombinationTriangles(SetofAnchors,2),2) X(CombinationTriangles(SetofAnchors,3),2)],'Color','b','LineStyle','-');
                 %line([X(CombinationTriangles(SetofAnchors,3),1) X(CombinationTriangles(SetofAnchors,1),1)],[X(CombinationTriangles(SetofAnchors,3),2) X(CombinationTriangles(SetofAnchors,1),2)],'Color','b','LineStyle','-');
                 %Format of MatrixRSSTargetNode= MatrixRSSTargetNode=[TargetNode Anchor RSS]
                 MatrixRSSTargetNode(temp2,:)=[i CombinationTriangles(SetofAnchors,1) Pij(i,CombinationTriangles(SetofAnchors,1))]; %Obtain RSS between the target node and the anchor node
                 MatrixRSSTargetNode(temp2+1,:)=[i CombinationTriangles(SetofAnchors,2) Pij(i,CombinationTriangles(SetofAnchors,2))]; %Obtain RSS between the target node and the anchor node
                 MatrixRSSTargetNode(temp2+2,:)=[i CombinationTriangles(SetofAnchors,3) Pij(i,CombinationTriangles(SetofAnchors,3))]; %Obtain RSS between the target node and the anchor node
                 temp2=temp2+3;
                                 
                 for d=Index(marker_rowneighbori):Index(marker_rowneighbore) %Range of Neighborhood
                    
                            %Count the number of neighbors for a target
                            %node
                             Number_neighbors=Number_neighbors+1;
                            %Format of MatrixRSSNeighborhood=MatrixRSSNeighborhood=[TargetNode Neighbornode Anchor RSS]
                             MatrixRSSNeighborhood(temp3,:)=[i Neighborhood(d,2) CombinationTriangles(SetofAnchors,1) Pij(CombinationTriangles(SetofAnchors,1),Neighborhood(d,2))]; %Obtain RSS between the anchor and the neigbor
                             MatrixRSSNeighborhood(temp3+1,:)=[i Neighborhood(d,2) CombinationTriangles(SetofAnchors,2) Pij(CombinationTriangles(SetofAnchors,2),Neighborhood(d,2))];
                             MatrixRSSNeighborhood(temp3+2,:)=[i Neighborhood(d,2) CombinationTriangles(SetofAnchors,3) Pij(CombinationTriangles(SetofAnchors,3),Neighborhood(d,2))];
                             temp3=temp3+3;
                             %We want to compare the neighbor tables with
                             %the target node (see
                             %PruebaRSSTables_TargetNode2)
                                %Sweeping MatrixRSSTargetNode in order to
                                %compare RSS values with the neighbor
                                %tables. RSS values are in the third
                                %column (target) and fourth (neighbor)
                                for k= InitSubtable_MatrixRSSTargetNode:EndSubtable_MatrixRSSTargetNode
                                    if MatrixRSSTargetNode(k,3)<MatrixRSSNeighborhood(cont,4)
                                        Counter_Further=Counter_Further+1;
                                    else
                                        Counter_Closer=Counter_Closer+1;
                                    end
                                    cont=cont+1;
                                end
                                %We may increase the pointers of the table of the neighborhood before it changes the SetofAnchors       
                                InitSubtable_MatrixRSSNeighborhood=InitSubtable_MatrixRSSNeighborhood+3;
                                EndSubtable_MatrixRSSNeighborhood=EndSubtable_MatrixRSSNeighborhood+3;
                                
                                %We may compare if there is a neighbor
                                %further/closer than the three anchors
                                %simulatenously
                                if (Counter_Further==3) | (Counter_Closer==3)
                                %Means that target node is outside of the triangle
                                %Format
                                %InsideorOutside=InsideorOutside[TargetNode
                                %0(Outside)/1(Inside) Anchors]
                                        InsideorOutside(aux,:)=[i 0 CombinationTriangles(SetofAnchors,1) CombinationTriangles(SetofAnchors,2) CombinationTriangles(SetofAnchors,3)];
                                        TableNodesOutsidetemp(aux2,:)=[i CombinationTriangles(SetofAnchors,1) CombinationTriangles(SetofAnchors,2) CombinationTriangles(SetofAnchors,3)];
                                        aux2=aux2+1;
                                        
                                else
                                %Means that target node is inside of the
                                %triangle, possibly
                                        InsideorOutside(aux,:)=[i 1 CombinationTriangles(SetofAnchors,1) CombinationTriangles(SetofAnchors,2) CombinationTriangles(SetofAnchors,3)];
                                %Increase counter
                                        aux3=aux3+1;
                                end
                                aux=aux+1;
                                %Reset counters
                                Counter_Closer=0;
                                Counter_Further=0; 
                           
                                
                    
                 end
               %-----------------------------------------------------------
                if(aux3==Number_neighbors)
                     %Means that it has not entered to a
                     %neighbor that reports that the
                     %target node is outside, thus
                     %the target node is inside of
                     %the triangle
                     TableNodesInside(aux4,:)=[i CombinationTriangles(SetofAnchors,1) CombinationTriangles(SetofAnchors,2) CombinationTriangles(SetofAnchors,3)];
                     %-->CODE IN TEST
                     Counterfornodenoestimate=1; %Mean that we can ESTIMATE the position of the node i since it lies of at least one seat of anchors
                     %-->CODE IN TEST
                     aux4=aux4+1;
                end
                 %Reset counters, before change anchors
                 Number_neighbors=0;
                 aux3=0;
                 %We may increase the pointers of the table of the target
                 %node before it changes to the SetofAnchors
                 InitSubtable_MatrixRSSTargetNode=InitSubtable_MatrixRSSTargetNode+3;   
                 EndSubtable_MatrixRSSTargetNode=EndSubtable_MatrixRSSTargetNode+3;
             end
        end
        Anchorscounter=0;
        marker_rowneighbori=marker_rowneighbori+2;
        marker_rowneighbore=marker_rowneighbore+2;
        if Counterfornodenoestimate==1
            %Means that we can estimate the position of the node
           Nodeswecanestimate(cont3,:)=i;
           cont3=cont3+1;
           Warningflag_impossibleest=0;
           Counterfornodenoestimate=0; 
        end
    end
end
if Warningflag_impossibleest==1; %Means that no nodes were found to be estimated
    fprintf(1,'--No nodes can be estimated!');
end
[m n]=size(TableNodesOutsidetemp);
%[o p]=size(TableNodesInsidetemp);
for h=1:(M+N) %M+N
    for j=1:m %Checking in the first column the target node that it is outside
        if h==TableNodesOutsidetemp(j,1)
            
            if j~=1
                if TableNodesOutsidetemp(j,:)==TableNodesOutsidetemp(j-1,:)
                    doomy=1; %Do not do anything in particular... we are interested when 2 rows are different so we can filter the values
                else
                    %Filters the table in order to not have repetitions
                    %Copy the entire row including the anchors
                    TableNodesOutsidetempo(cont2,:)=TableNodesOutsidetemp(j-1,:);
                    TableNodesOutsidetempo(cont2+1,:)=TableNodesOutsidetemp(j,:);
                    cont2=cont2+1;
                end
            end
        end
    end
end
cont3=1;
%-->CODE TO TEST
for i=1:(M+N)
    if (isempty(find(Nodeswecanestimate==i))==1) % if (1) means that the node is not found in Nodeswecanestimate and therefore is part of the Nodeswecannotestimate
        Nodeswecannotestimate(cont3,:)=i;
        cont3=cont3+1;
    end
end
if (isempty(Nodeswecannotestimate)==0) %if it exists the array of Nodeswecannotestimate
    [m n]=size(TableNodesOutsidetempo);
    [o p]=size(Nodeswecannotestimate);
    for j=1:o
        for i=1:m
            if (isempty(find(Nodeswecannotestimate(j,1)==TableNodesOutsidetempo(i,1)))==0) %if it is found in Table  in the first column (which is the Target Node) we should eliminate it.
                TableNodesOutsidetempo(i,:)=[0 0 0 0]; %Artifitial way to eliminate it
            end
        end
    end
    cont3=1;
    for i=1:m
        if TableNodesOutsidetempo(i,:)==[0 0 0 0]
            doomy=1; %Just a doomy alg
        else
            TableNodesOutside(cont3,:)=TableNodesOutsidetempo(i,:);
            cont3=cont3+1;
        end
    end
else
    TableNodesOutside=TableNodesOutsidetempo;
end
%---->