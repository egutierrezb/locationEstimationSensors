function [AH, ND, Neighborhood,Audibleanchors, Dist_Anchor]=connectivity_ANR(X,Indices,TrueDist,Radio_approx)

%connectivity_ANR the Audibleanchors and Neighborhood for each TargetNode
%It receives the parameters: X the array with the positions of the nodes
%and Indices - the Nodes (e.g. 1, 5, 9,..) that act as anchors. 

global M N 

Neighborhood=[];
Audibleanchors=[];
Audibleanchorstarget=[];
TargetNode_NumAnchors=[];
TargetNode_NumAnchorst=[];
TargetNode_NumNeighbors=[];

%ANR defines the ratio between the distance of the beacon (Dist_Anchor) and the distance
%of the radio of a regular node (Dist_Neighborhood)
ANR=1; 

%Based in the experiments of Whitehouse we define a threshold of 4.57m
Dist_Neighborhood=Radio_approx; %4.58m
Dist_Anchor=ANR*Dist_Neighborhood;

%Counters
aux=1;
aux2=1;
cuenta=1;
cuenta2=1;
cont=1;
cont2=1;

for x=1:(M+N) %M+N
    for y=1:(M+N) %M+N
       Node1=x; 
       Node2=y;
       %Procedure to define the number of AH (Anchors Heard) w/ANR
       if (TrueDist(x,y)<=Dist_Anchor) & (TrueDist(x,y)~=0)
            %Node2 == Number of Anchor Anchor
            %Node1 == Number of TargetNode
            %If the matrix is empty (if 1) when trying to find Node1 means
            %that it is not an Anchors and is a TargetNode
            %If the matrix is not empty (if 0) when trying to find Node2
            %means that is is an Anchor
           
            %CODE CHANGED MAY 30th
            if Node1~=Node2 & ((isempty(find(Indices==Node2))==0) & (isempty(find(Indices==Node1))==0)) %0 1                          %Node2 == 1 | Node2 == 11 | Node2 == 4 | Node2 == 15 | Node2==14 | Node2==28 | Node2 == 9 | Node2 == 7 | Node2 == 20 | Node2 == 30 | Node2 == 26 | Node2 == 29
                fprintf(1,'--Anchor %d has Anchor %d as an audible one.\n',Node1,Node2); %Target Node
                Audibleanchorstarget(cuenta,:)=[Node1 Node2];
                cuenta=cuenta+1;
            end
            if Node1~=Node2 & (isempty(find(Indices==Node2))==0) %Audible anchors will include anchors and blindfolded devices in the first column and in the second will include only anchors   
                %fprintf(1,'--Target node %d has Anchor %d as an audible one.\n',Node1,Node2); %Node2 is the anchor
                fprintf(1,'--Node %d has Anchor %d as an audible one.\n',Node1,Node2); 
                %Audibleanchors has the following format:
                %Target node -- Audible anchor
                %In order to form a triangle then:
                %[1 a]
                %[1 b]
                %[1 c]
                Audibleanchors(aux,:)=[Node1 Node2]; %Useful in order to consider which Anchors are listened for a Target Node
                aux=aux+1;
            end
            %Neighborhood has the following format: 
            %Target node -- Neighbor within a radius of 4.57
            %e.g. 1-4
            %     1-11
            %     1-23
            %     1-33
            %     2-3
            %     2-7
            %     2-39
       end
       %Procedure to define the Neighborhood with Dist_Neighborhood
     
         %CODE CHANGED MAY 30th  
         % if (TrueDist(x,y)<Dist_Neighborhood) & (TrueDist(x,y)~=0) & (isempty(find(Indices==Node1))==1) & (isempty(find(Indices==Node2))==1) %ADDED CODE 04/11 Means that Node2 and Node1 are TargetNode
         if (TrueDist(x,y)<=Dist_Neighborhood) & (TrueDist(x,y)~=0) & (isempty(find(Indices==Node1))==1) %Node1 is a blindfolded device and Node2 is a blindfolded or anchor
                Neighborhood(aux2,:)=[Node1 Node2]; 
                % Draw a line between two nodes if they are connected (i.e.
                % interdistance is less than the value of the threshold).
                % line([X(Node1,1) X(Node2,1)],[X(Node1,2) X(Node2,2)],'Color','g','LineStyle','--');
                aux2=aux2+1;
         end
    end
    %To compute the number of Anchors per  (i.e. Node1)
    %CODE CHANGED MAY 30th
    %if (isempty(Audibleanchors)==0) & (isempty(find(Indices==Node1))==1)
    if (isempty(Audibleanchors)==0)   
         numbera=[];
         numbera=find(Audibleanchors(:,1)==Node1);
         if(isempty(numbera)==0)
             [Number_Anchors a]=size(numbera); %Number_Anchors contains the number of anchors per TargetNode
             TargetNode_NumAnchors(cont,:)=Number_Anchors;
             cont=cont+1;
         end
    end
    if (isempty(Audibleanchorstarget)==0)   
         numbert=[];
         numbert=find(Audibleanchorstarget(:,1)==Node1);
         if(isempty(numbert)==0)
             [Number_Anchors a]=size(numbert); %Number_Anchors contains the number of anchors per TargetNode
             TargetNode_NumAnchorst(cuenta2,:)=Number_Anchors;
             cuenta2=cuenta2+1;
         end
    end
    if (isempty(Neighborhood)==0)
        numbern=[];
        numbern=find(Neighborhood(:,1)==Node1);
        if(isempty(numbern)==0)
            [Number_Neighbors b]=size(numbern);
            TargetNode_NumNeighbors(cont2,:)=Number_Neighbors;
            cont2=cont2+1;
        end
    end
end

%Compute the average number of Anchors and Neighbors (i.e. ND and AH)
%[m n]=size(TargetNode_NumAnchors);
avg=sum(TargetNode_NumAnchors)/(M+N);
%Anchor heard
AH=avg;
fprintf(1,'--AH: Anchor Heard= %f\n',avg); %tnode

[m n]=size(TargetNode_NumAnchorst);
avg=sum(TargetNode_NumAnchorst)/m;
%Anchor heard
AH=avg;
fprintf(1,'--AH: Anchor Heard (anchor-anchor) = %f\n',avg);

[m n]=size(TargetNode_NumNeighbors);
avg=sum(TargetNode_NumNeighbors)/m;
%Node density
ND=avg;
fprintf(1,'--ND: Node Density = %f\n',avg);