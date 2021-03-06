function [AH, ND, Neighborhood,Audibleanchors]=connectivity_DOI(X,Indices, RSS_noise, dth_RSS_Neighborhood)
global M N Res 
Neighborhood=[];
Neighborhood2=[];
Audibleanchors=[];
Audibleanchors2=[];

%RSS_noise=[TargetNode Nodetocompare RSS+noise]
%ANR defines the ratio between the distance of the beacon (Dist_Anchor) and the distance
%of the radio of a regular node (Dist_Neighborhood)
ANR=1;

%We should simulate a value of RSS threshold in order to succesfully decode
%packets
%RSS_Neighborhood=-101; %Value in dBm
%RSS_Anchor=ANR*RSS_Neighborhood;

%We can take that further than a threshold distance there is no RSS at all.
RSS_Anchor=ANR*dth_RSS_Neighborhood;

%Counters
aux=1;
temp=1;
aux2=1;
aux3=1;
cont=1;
cont2=1;
cont3=1;
cont4=1;

for x=1:(M+N) %M+N
    for y=1:(M+N) %M+N
       Node1=x; 
       Node2=y;
       %Procedure to define the number of AH (Anchors Heard) w/ANR
       %Take the TargetNode and Node_compared from the RSS table. 
       Match=find(RSS_noise(:,1)==x & RSS_noise(:,2)==y);
       if (isempty(Match)==0) 
            %if (RSS_noise(Match,3)>RSS_Anchor)   %CODED DELETED -> 04/04
            if (RSS_noise(Match,4)<RSS_Anchor)    %RSS_noise(Match,4) points to TrueDist(i,j) ADDED CODE-> 04/04
                %Node2 == Number of Anchor Anchor
                %Node1 == Number of TargetNode
                %If the matrix is empty (if 1) when trying to find Node1 means
                %that it is not an Anchor and it is a TargetNode
                %If the matrix is not empty (if 0) when trying to find Node2
                %means that is is an Anchor
                % CODE DELETED AUG 13
                %if ((isempty(find(Indices==Node2))==0) & (isempty(find(Indices==Node1))==1))
                if Node1~=Node2 & (isempty(find(Indices==Node2))==0)
                    fprintf(1,'--Target node %d has Anchor %d as an audible one.\n',Node1,Node2);
                    %Audibleanchors has the following format:
                    %Target node -- Audible anchor
                    %In order to form a triangle then:
                    %[1 a]
                    %[1 b]
                    %[1 c]
                    %Audibleanchors=Audibleanchors[Anchor/Blindfolded_Device AudibleAnchor]
                    Audibleanchors(aux,:)=[Node1 Node2]; %Useful in order to consider which Anchors are listened for a Target Node
                    aux=aux+1;
                end
		if Node1~=Node2 & (isempty(find(Indices==Node2))==0) & (isempty(find(Indices==Node1))==1)
		    %Audibleanchors2=Audibleanchors2[Blindfolded Device Audibleanchor]
		    Audibleanchors2(temp,:)=[Node1 Node2];	
		    temp=temp+1;
		end
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
       %we do not consider an if after this if because it is supposed that
       %all nodes which TrueDistances are above RSS_Neighborhood (threshold) have already been filtered in empmodel_DOI
       if (isempty(Match)==0) & (isempty(find(Indices==Node1))==1)
          % if (RSS_noise(Match,3)>RSS_Neighborhood) %CODE DELETED 04/04 
                %Neighborhood=Neighborhood[BlindfoldedDevice BlindfoldedDevice / Anchor]
                Neighborhood(aux2,:)=[Node1 Node2];
                % Draw a line between two nodes if they are connected (i.e.
                % interdistance is less than the value of the threshold).
                % line([X(Node1,1) X(Node2,1)],[X(Node1,2) X(Node2,2)],'Color','g','LineStyle','--');
                aux2=aux2+1;
         %  end
       end
       if (isempty(Match)==0) & (isempty(find(Indices==Node1))==1) & (isempty(find(Indices==Node2))==1)
	       Neighborhood2(aux3,:)=[Node1 Node2];
	       aux3=aux3+1;
       end
    end
    %To compute the number of Anchors per TargetNode (i.e. Node1)
    if (isempty(Audibleanchors)==0) 
         numbera=[];
         numbera=find(Audibleanchors(:,1)==Node1);
         if(isempty(numbera)==0)
             [Number_Anchors a]=size(numbera); %Number_Anchors contains the number of anchors per TargetNode
             TargetNode_NumAnchors(cont,:)=Number_Anchors;
             cont=cont+1;
         end
    end

    if (isempty(Audibleanchors2)==0)
	numberc=[];
	numberc=find(Audibleanchors2(:,1)==Node1);
	if(isempty(numberc)==0)
	    [Number_Anchors c]=size(numberc);
	    TargetNode_NumAnchors2(cont4,:)=Number_Anchors;
	    cont4=cont4+1;
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
    if (isempty(Neighborhood2)==0)
	numberb=[];
	numberb=find(Neighborhood2(:,1)==Node1);
	if(isempty(numberb)==0)
	    [Number_Neighbors b]=size(numberb);
	    TargetNode_NumNeigh2(cont3,:)=Number_Neighbors;
	    cont3=cont3+1;
	end
    end
end

%Compute the average number of Anchors and Neighbors (i.e. ND and AH)
%[m n]=size(TargetNode_NumAnchors);
avg=sum(TargetNode_NumAnchors)/(M+N);
%Anchor heard
AH=avg;
fprintf(1,'--AH: Anchor Heard= %f\n',avg); %tnode

[m n]=size(TargetNode_NumAnchors2);
avg=sum(TargetNode_NumAnchors2)/m;
AH2=avg;
fprintf(1,'--AH: Anchor Heard (unknown sensors-anchors)= %f\n',avg);

[m n]=size(TargetNode_NumNeighbors);
avg=sum(TargetNode_NumNeighbors)/m;
%Node density
ND=avg;
fprintf(1,'--ND: Node Density = %f\n',avg);

[m n]=size(TargetNode_NumNeigh2);
avg=sum(TargetNode_NumNeigh2)/m;
ND2=avg;
fprintf(1,'--ND: Node Density (only unknown sensors) = %f\n',avg); 