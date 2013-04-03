function [TableNodesOutside, TableNodesInside, Estimatedcoord_density, InOut_realinside, InOut_realoutside, Endprogram]=APITtest_surface(X,Audibleanchors,RSS_noise,Neighborhood,Indices,H,dth_RSS_Neighborhood)

global M N 
[m n]=size(Audibleanchors);
Anchorstriangle=zeros(1,3);
TableNodesInside=[];
TableNodesOutsidetemp=[];
CombinationTriangles=[];
Nodeswecanestimate=[];
Estimatedcoord_density=[];
InOut_realinside=[];
InOut_realoutside=[];
%Counters
Anchorscounter=0;
temp=1;
conti=1; %Used for tables using RF profile
conto=1; %Used for tables using RF profile
est=1; %Used for the estimated positions through RFprofile
reali=1; %Used for real tables inside/outside
realo=1;
%X2 is going to have the same columns as X plus a third column of zeros in
%order to be feasible to operate w. cross

X2=X;
[Xsizex Xsizey]=size(X);
X2(:,3)=zeros(Xsizex,1);

%H1 is going to have the same columns as H plus a third column of zeros in
%order to be feasible to operate w. cross.

H1=H;
[Hsizex Hsizey]=size(H);
H1(:,3)=zeros(Hsizex,1);

for i=1:(M+N) %M+N
    %Check out progress of the simulation w/ the number of Target node
    %Only consider target nodes, not anchors  (if 1= mean that it is not an
    %anchor node, it is a target node), and it should check that the target
    %node is a node considered in the Neighborhood, in order to avoid
    %problems with bounds of Index
    if (isempty(find(Indices==i))==1)  & (isempty(find(Neighborhood(:,1)==i))==0) 
        Anchorstriangle=[];
        fprintf(1,'--Making RSS comparisons for Target Node %d\n',i);
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
            CombinationTriangles=[];
            CombinationTriangles=nchoosek(Anchorstriangle(1:limit_anchors),3); %Combinations=nchoosek(n,k)
            [u v]=size(CombinationTriangles);
            for SetofAnchors=1:u %size of CombinationTriangles
                %Check if it is Inside of a triangle or outside of a
                %triangle in the real sense
                [isinsidereal]=checkrealinsideoroutside(X2,CombinationTriangles(SetofAnchors,:),i);
                if(isinsidereal==1)
                    %Means that it is inside
                    InOut_realinside(reali,:)=[i CombinationTriangles(SetofAnchors,1) CombinationTriangles(SetofAnchors,2) CombinationTriangles(SetofAnchors,3)];
                    reali=reali+1;
                else
                    InOut_realoutside(realo,:)=[i CombinationTriangles(SetofAnchors,1) CombinationTriangles(SetofAnchors,2) CombinationTriangles(SetofAnchors,3)];
                    realo=realo+1;
                end
                %We check if a point of the grid (i.e. point in H) is INSIDE or OUTSIDE of a
                %particular combination of anchors->triangle
                %We take all the grid points at once
                %We repeat the anchor until it grows to the size of H in
                %order that cross can be congruent
                CombinationTrianglesA=repmat(CombinationTriangles(SetofAnchors,1),Hsizex,1);
                CombinationTrianglesB=repmat(CombinationTriangles(SetofAnchors,2),Hsizex,1);
                CombinationTrianglesC=repmat(CombinationTriangles(SetofAnchors,3),Hsizex,1);
                %We are going to check that the gridpoints are in range of
                %the three anchors, if so we consider only these points for
                %the APIT RF profile test!!!.
                D_GridxAnchorA=sqrt(((H1(:,2)-X2(CombinationTrianglesA,2)).^2)+((H1(:,1)-X2(CombinationTrianglesA,1)).^2));
                D_GridxAnchorB=sqrt(((H1(:,2)-X2(CombinationTrianglesB,2)).^2)+((H1(:,1)-X2(CombinationTrianglesB,1)).^2));
                D_GridxAnchorC=sqrt(((H1(:,2)-X2(CombinationTrianglesC,2)).^2)+((H1(:,1)-X2(CombinationTrianglesC,1)).^2));
                Match=find(D_GridxAnchorA<=dth_RSS_Neighborhood & D_GridxAnchorB<=dth_RSS_Neighborhood & D_GridxAnchorC<=dth_RSS_Neighborhood);
                %HMatch will contain the rows that are above the threshold
                %defined R (dth_RSS_Neighborhood)
                HMatch=H1(Match,:);
                [HMsize y]=size(HMatch);
                CombinationTrianglesAHM=repmat(CombinationTriangles(SetofAnchors,1),HMsize,1);
                CombinationTrianglesBHM=repmat(CombinationTriangles(SetofAnchors,2),HMsize,1);
                CombinationTrianglesCHM=repmat(CombinationTriangles(SetofAnchors,3),HMsize,1);
                Mt(:,1:3)=cross(HMatch-X2(CombinationTrianglesAHM,:),X2(CombinationTrianglesBHM,:)-X2(CombinationTrianglesAHM,:)); %H-A,B-A 
                Nt(:,1:3)=cross(HMatch-X2(CombinationTrianglesBHM,:),X2(CombinationTrianglesCHM,:)-X2(CombinationTrianglesBHM,:)); % H-B,C-B
                Ot(:,1:3)=cross(HMatch-X2(CombinationTrianglesCHM,:),X2(CombinationTrianglesAHM,:)-X2(CombinationTrianglesCHM,:)); % H-C,A-C
                % Means that the point of the grid H is INSIDE
                Matchinside1=find(Ot(:,3)>0 & Mt(:,3)>0 & Nt(:,3)>0); 
                Matchinside2=find(Ot(:,3)<0 & Mt(:,3)<0 & Nt(:,3)<0);
                Matchinside=[Matchinside1;Matchinside2];
                %Means that point of the grid H is OUTSIDE
                Matchoutside1=find(Ot(:,3)>0 & Mt(:,3)>0 & Nt(:,3)<0); 
                Matchoutside2=find(Ot(:,3)>0 & Mt(:,3)<0 & Nt(:,3)<0); 
                Matchoutside3=find(Ot(:,3)>0 & Mt(:,3)<0 & Nt(:,3)>0);
                Matchoutside4=find(Ot(:,3)<0 & Mt(:,3)<0 & Nt(:,3)>0); 
                Matchoutside5=find(Ot(:,3)<0 & Mt(:,3)>0 & Nt(:,3)>0);
                Matchoutside6=find(Ot(:,3)<0 & Mt(:,3)>0 & Nt(:,3)<0); 
                Matchoutside=[Matchoutside1; Matchoutside2; Matchoutside3; Matchoutside4; Matchoutside5; Matchoutside6];
                % In this function we are going to compute the
                % RMI for the grid point and each anchor of the
                % triangle defined by
                % CombinationTriangles(SetofAnchors,:)
                % RSS_insidetriangle (or RSS_outsidetriangle)=RSS_insidetriangle[Anchor1 Anchor2 Anchor3
                % Gridpoint PowerfromAnchor1_Gridpoint PowerfromAnchor2_Gridpoint PowerfromAnchor3_Gridpoint]
                %fprintf(1,'Target Node %d and Anchors [%d %d %d] evaluated through RSS surface\n',i,CombinationTriangles(SetofAnchors,1),CombinationTriangles(SetofAnchors,2),CombinationTriangles(SetofAnchors,3));
                if(isempty(Matchinside)==0)
                    %If Matchinside is empty is that no gridpoints were
                    %found inside of the triangle, this is because the
                    %granularity of the grid is not enough.
                    %This matrix contains RECORDED RSS INSIDE OF THE
                    %TRIANGLE
                    [RSS_insidetriangle]=RSSDOI_compute(X, HMatch(Matchinside,1:2),CombinationTriangles(SetofAnchors,:));
                end
                if(isempty(Matchinside)==1)
                    RSS_insidetriangle=[];
                end
                if(isempty(Matchoutside)==0)
                    %It is for sure that we may have gridpoints outside of
                    %the triangle
                    %This matrix contains RECORDED RSS OUTSIDE OF THE
                    %TRIANGLE
                    [RSS_outsidetriangle]=RSSDOI_compute(X, HMatch(Matchoutside,1:2),CombinationTriangles(SetofAnchors,:));
                end
                %We search for the {RSSAnchor1_TNode, RSSAnchor2_TNode,
                %RSSAnchor3_TNode}
                %->> We have to check:
                if(isempty(Matchoutside)==0) %We check only Matchoutside, because it's almost always for sure that there are grid points outside of the triangle, however
                    %for inside points if the length of the grid area is
                    %too big maybe these points do not fall inside of the
                    %triangle and RSS_insidetriangle is empty
                    MatchRSSAnchor1Target=find(RSS_noise(:,1)==CombinationTriangles(SetofAnchors,1) & RSS_noise(:,2)==i);
                    MatchRSSAnchor2Target=find(RSS_noise(:,1)==CombinationTriangles(SetofAnchors,2) & RSS_noise(:,2)==i);
                    MatchRSSAnchor3Target=find(RSS_noise(:,1)==CombinationTriangles(SetofAnchors,3) & RSS_noise(:,2)==i);
                    %Set of OBSERVED RSS (like in the paper of Radar)
                    RSSAnchorsTarget=[RSS_noise(MatchRSSAnchor1Target,3) RSS_noise(MatchRSSAnchor2Target,3) RSS_noise(MatchRSSAnchor3Target,3)];
                    %Function in which we are compute the RMSE for the RSS's of
                    %the RSS_insidetriangle and RSS_outisdetriangle, find the
                    %minimum and decide if the node is outside or outside of
                    %the triangle
                    %WE COMPUTE THE MINUMUM DIFFERENCE THROUGH RMSE BETWEEN
                    %OBSERVED AND RECORDED RSS.
                    [isInside, Estimatedcoord_density(est,:)]=findminimumRSS(RSS_insidetriangle, RSS_outsidetriangle, RSSAnchorsTarget, i, 1);
                    est=est+1;
                    if (isInside==1)
                        TableNodesInside(conti,:)=[i CombinationTriangles(SetofAnchors,1) CombinationTriangles(SetofAnchors,2) CombinationTriangles(SetofAnchors,3)];
                        conti=conti+1;
                    else
                        %TableNodesOutsidetemp is a temporary array which is
                        %going to be used jointly which Nodeswecannotestimate
                        %in order to filter values and to obtain
                        %TableNodesOutside
                        TableNodesOutsidetemp(conto,:)=[i CombinationTriangles(SetofAnchors,1) CombinationTriangles(SetofAnchors,2) CombinationTriangles(SetofAnchors,3)];
                        conto=conto+1;
                    end
                else
                    %We can have the situation in which Matchinside is
                    %empty so automatically this node is reported at
                    %outside table
                       TableNodesOutsidetemp(conto,:)=[i CombinationTriangles(SetofAnchors,1) CombinationTriangles(SetofAnchors,2) CombinationTriangles(SetofAnchors,3)];
                       conto=conto+1;
                end
                Mt=[];
                Nt=[];
                Ot=[];
             end
        end
    end 
    Anchorscounter=0;
end
%Enable if we are going to make comparisons errors, between tables, if we
%are going to use APIT Test RF disable, if we are going to estimate nodes
%using RF profile pure  disable this and the remaining of the program
%(except Endofprogram)

TableNodesOutside=TableNodesOutsidetemp; %we take the matrix as raw data, without filtering such rows of the nodes that we can not estimate

%if(isempty(TableNodesOutsidetemp)==0 & isempty(TableNodesInside)==0) %If TableNodesInside is not empty, it exists at least one neighbor of i that reports that it is inside of a particular triangle
%    [TableNodesOutside]=createTNodesoutside(Indices,Neighborhood, TableNodesInside, TableNodesOutsidetemp);
     Endprogram=0;
%else %Since we have TableNodesInside empty, it sound reasonable not to compute any of the nodes positions.
%    TableNodesOutside=[];
%    Endprogram=1;
%end


