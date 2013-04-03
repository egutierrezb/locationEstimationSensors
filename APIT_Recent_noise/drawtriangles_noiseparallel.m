i=input('Number of node');
Name_file=input('Number of file','s'); %Name_file is a string

% We disable the function in order to avoid conflicts with executing in
% shell
%function [TableNodesOutside, TableNodesInside, Nodeswecannotestimate, Endprogram]=drawtriangles_parallel(X,Audibleanchors,Pij,Neighborhood,Indices,i)

%drawtriangles_noiseparallel computes the tables of RSS for ONLY ONE targetNode and its
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
%i-> Target node of interest

% Data to be entered from the shell script
%X=input('Matrix X (Sensors positions): ');
%Audibleanchors=input('Audibleanchors ');
%Pij=input('Matrix of Pij ');
%Neighborhood=input('Matrix of Neighborhood ');
%Indices=input('Matrix of Indices ');
%Node to be worked out

load("-text", "GeneralTopology.mat", "M", "N", "Res", "X", "Audibleanchors", "Pij", "Neighborhood", "Indices" ,"H","RSS_noise");

%global M N 

[m n]=size(Audibleanchors);
Anchorstriangle=zeros(1,3);
DefiniteAnchors=[];
TableNodesInside=[];
TableNodesOutside=[];
TableNodesOutsidetemp=[];
TableNodesOutsidetempo=[];

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

%To accelarate process of search
%Index matrix contains the bounds for each target node. The bounds are
%going to be used for the Neighborhood

if (isempty(find(Indices==i))==1) %We consider only target nodes if(1)
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

%Reinitialize counter
aux=1;
marker_rowneighbori=1;
marker_rowneighbore=2;

    %Check out progress of the simulation w/ the number of Target node
    %Only consider target nodes, not anchors  (if 1= mean that it is not an
    %anchor node, it is a target node), and it should check that the target
    %node is a node considered in the Neighborhood, in order to avoid
    %problems with bounds of Index
    if (isempty(find(Indices==i))==1)  & (isempty(find(Neighborhood(:,1)==i))==0) 
         SetofNeighbors=[];
         Anchorstriangle=[];
         SetofNeighbors=find(Neighborhood(:,1)==i); %Set of Neighbors will contain the rows of the neighbors for a particular target node
         [ms ns]=size(SetofNeighbors); %ms contains the size of the neighborhood for TargetNode i
         Counterfornodenoestimate=0; %Initialize the counter for the node that can not be estimated
         %To check that it is running for each node
         fprintf(1,'--Computing RSSTargetNode and RSSNeighbors Tables for Target Node %d\n',i);
       
         for j=1:m        %size of Audibleanchors
            if i==Audibleanchors(j,1) %Format of audibleanchors: audibleanchors(targetnode,anchor) we want the first column
                Anchorscounter=Anchorscounter+1;
                Anchorstriangle(temp)=Audibleanchors(j,2); %We want the anchor, anchorstriangle is the number of anchors for an  specific target node
                temp=temp+1;
            end
         end
       
         % For debugging number of anchors for the target node i
         % fprintf(1,'--Ideally # of Anchors of TargetNode %d would be [ %d ]!!!\n ',i,temp-1);
         % pause(1);
        
        Share_sameneighbor=[];
        Anchorstriangle_neighborandtarget=[];
        counter=1;
        No_share_anchors=0;
        share_anchors=0;
        
        %We have to verify if a particular neighbor hears than
        %anchor Audibleanchors(j,2)
        for k=1:ms %Neighborhood will contain the neighbor of the target node
            for l=1:m %size of Audibleanchors
                    if Neighborhood(SetofNeighbors(k),2)==Audibleanchors(l,1)
                       %Now try to find if Audibleanchors(l,2) is in
                       %Anchorstriangle, if succeed the Neighborh and
                       %target node i shares the same anchor, 
                       Share_sameneighbor=find(Anchorstriangle(:)==Audibleanchors(l,2));
                       if(isempty(Share_sameneighbor)==0) %Format of Anchorstriangle_neighborandtarget=[TargetNode Neighbor Audibleanchor]
                            Anchorstriangle_neighborandtarget(counter,:)=[i Neighborhood(SetofNeighbors(k),2) Audibleanchors(l,2)];
                            counter=counter+1;
                            share_anchors=share_anchors+1;
                       else
                           No_share_anchors=No_share_anchors+1;
                       end
                    end
                    Share_sameneighbor=[];
            end
           
            % For debugging the number of anchors that are shared between a
            % neighbor and a target node i
            % fprintf(1,'--Neighbor %d shares [%d Anchors out of %d] with TargetNode %d\n',Neighborhood(SetofNeighbors(k),2), share_anchors, temp-1, i);
            % pause(1);
           
            No_share_anchors=0;
            share_anchors=0;
        end %Until this point we are going to have a targetnode with his audibleanchors and all his neighbors with their audibleanchors also
        %Goes with the next neighbor, we have to obtain the set of
        %neighbors that share three common neighbors in another
        %variable, Neighborhood_shared
        if(isempty(Anchorstriangle_neighborandtarget)==0)
            min=0; %Counter in order to know which is the minimum common set between the neighbors
            tempmin=min;
            counter=1;
            flag_if=1;
            Neighborhood_shared=[];
            for ii=1:(M+N)
                Counter_question_three=[];
                Counter_question_three=find(Anchorstriangle_neighborandtarget(:,2)==ii); %Check for neighbor, if there are 3 or more repetitions of the same neighbor, it means that hears to three anchors or more
                if(isempty(Counter_question_three)==0)
                    [mc nc]=size(Counter_question_three);
                    if mc>=3 %Means that it has more or equal than three anchors
                        for t=1:mc %Format of Neighborhood_shared=[Neighborhood Audibleanchor]
                            Neighborhood_shared(counter,:)=[Anchorstriangle_neighborandtarget(Counter_question_three(t),2) Anchorstriangle_neighborandtarget(Counter_question_three(t),3)]; %Saves the neighbor and the audible anchor
                            counter=counter+1;
                        end
                    end
                end
            end
            count=1;
            count2=1;
            %At the end we are going to obtain Neighborhood_shared with a
            %Certain neighbor and his anchors...we have to obtain the common
            %set among i and the neighbors
            %To fix the size of the anchorstriangle array and prevent bugs
            limit_anchors=temp-1;
            temp=1;
            %If number of anchors>=3 then we should form a triangle between the
            %anchors
            if Anchorscounter>=3
                CombinationTriangles=nchoosek(Anchorstriangle,3); %Combinations=nchoosek(n,k)
                [u v]=size(CombinationTriangles);
                for SetofAnchors=1:u %size of CombinationTriangles
                            %Introduce the algorithm for searching in the
                            %Neighborhood_shared the set of
                            %CombinationTriangles, how to avoid to include a
                            %for here the O(x) increases
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            %CODE ADDED MAY 25th
                            DefiniteNeighbors=[];
                            Limits_Neighbor=[];
                            neigh_count=1;
                            if(isempty(Neighborhood_shared)==0)
                                [m_neigh_size n_neigh_size]=size(Neighborhood_shared);
                                limit_neighbor=1;
                                Limits_Neighbor(limit_neighbor)=[Neighborhood_shared(1)]; %Refers to the neighbor of the first row from Neighbor_shared
                                limit_neighbor=2;
                                for node=1:m_neigh_size
                                    if node~=1
                                        if Neighborhood_shared(node,1)==Neighborhood_shared(node-1,1)
                                            doomy=1;
                                        else
                                            Limits_Neighbor(limit_neighbor)=[Neighborhood_shared(node)]; %Limits_Neighbor will contain the list of neighbors of Neighbor_shared. It is the same that Neighborhood(:,2) for a specified i
                                            limit_neighbor=limit_neighbor+1;
                                        end
                                    end
                                end
                                [ml nl]=size(Limits_Neighbor);
                                for neigh=1:nl
                                    Neighbor=[];
                                    Terna_search=[];
                                    Neighbor=find(Neighborhood_shared(:,1)==Limits_Neighbor(neigh)); %Neighbor contains the range of anchors for a specified neighbor
                                    if(isempty(Neighbor)==0)
                                            [mn nn]=size(Neighbor); %In Terna_search we are going to find the specified terna of anchors [neighbor x anchor1;neighbor x anchor 2; neighbor x anchor 3;...]
                                            Terna_search=find((Neighborhood_shared(Neighbor(1,1):Neighbor(mn,1),2)==CombinationTriangles(SetofAnchors,1))|(Neighborhood_shared(Neighbor(1,1):Neighbor(mn,1),2)==CombinationTriangles(SetofAnchors,2))|(Neighborhood_shared(Neighbor(1,1):Neighbor(mn,1),2)==CombinationTriangles(SetofAnchors,3)));
                                            [mt nt]=size(Terna_search);
                                            if(mt==3) %means that it was found the terna for the neighbor, thus we have to add this to the array DefiniteNeighbors
                                                %CODE ADDED MAY 30th
                                                if (Limits_Neighbor(neigh)~=CombinationTriangles(SetofAnchors,1)) & (Limits_Neighbor(neigh)~=CombinationTriangles(SetofAnchors,2)) & (Limits_Neighbor(neigh)~=CombinationTriangles(SetofAnchors,3))
                                                    DefiniteNeighbors(neigh_count)=Limits_Neighbor(neigh);
                                                    neigh_count=neigh_count+1;
                                                    %because the anchor is not shared, break the for and we can go with the next anchortriangle without supervising the remaining blocks of neighbors and anchors
                                                end
                                            end
                                    end
                                end
                                 neigh_count=1;
                                 [md nd]=size(DefiniteNeighbors);
                                 %Draw the triangle from the audible anchors for the Target Node [enable or disable]
                                 %line([X(CombinationTriangles(SetofAnchors,1),1) X(CombinationTriangles(SetofAnchors,2),1)],[X(CombinationTriangles(SetofAnchors,1),2) X(CombinationTriangles(SetofAnchors,2),2)],'Color','b','LineStyle','-');
                                 %line([X(CombinationTriangles(SetofAnchors,2),1) X(CombinationTriangles(SetofAnchors,3),1)],[X(CombinationTriangles(SetofAnchors,2),2) X(CombinationTriangles(SetofAnchors,3),2)],'Color','b','LineStyle','-');
                                 %line([X(CombinationTriangles(SetofAnchors,3),1) X(CombinationTriangles(SetofAnchors,1),1)],[X(CombinationTriangles(SetofAnchors,3),2) X(CombinationTriangles(SetofAnchors,1),2)],'Color','b','LineStyle','-');
                                 %Format of MatrixRSSTargetNode= MatrixRSSTargetNode=[TargetNode Anchor RSS]
                                 %In the case of the Matches, the
                                 %TargetNode is the anchor and the
                                 %nodecompared is the blindfolded device,
                                 %the angle is taken from the anchor.
                                 Match1=find(RSS_noise(:,2)==i & RSS_noise(:,1)==CombinationTriangles(SetofAnchors,1)); %Finds the row for the RSS to be used         
                                 Match2=find(RSS_noise(:,2)==i & RSS_noise(:,1)==CombinationTriangles(SetofAnchors,2)); %Finds the row for the RSS to be used         
                                 Match3=find(RSS_noise(:,2)==i & RSS_noise(:,1)==CombinationTriangles(SetofAnchors,3)); %Finds the row for the RSS to be used
                                 
                                 MatrixRSSTargetNode(temp2,:)=[i CombinationTriangles(SetofAnchors,1) RSS_noise(Match1,3)]; %Obtain RSS between the target node and the anchor node
                                 MatrixRSSTargetNode(temp2+1,:)=[i CombinationTriangles(SetofAnchors,2) RSS_noise(Match2,3)]; %Obtain RSS between the target node and the anchor node
                                 MatrixRSSTargetNode(temp2+2,:)=[i CombinationTriangles(SetofAnchors,3) RSS_noise(Match3,3)]; %Obtain RSS between the target node and the anchor node
                                 temp2=temp2+3;

                                 for d=1:nd %Range of DefiniteNeighbors
                                            %Count the number of neighbors for a target
                                            %node
                                            %%Changed by Neighborhood(d,2)
                                            %%instead of DefiniteNeighbors
                                            %In the case of the Matches,
                                            %the TargetNode is the anchor
                                            %and the nodecompared is the
                                            %blindfolded device, the angle
                                            %is taken from the anchor.
                                            Match1=find(RSS_noise(:,2)==DefiniteNeighbors(d) & RSS_noise(:,1)==CombinationTriangles(SetofAnchors,1)); %Finds the row for the RSS to be used         
                                            Match2=find(RSS_noise(:,2)==DefiniteNeighbors(d) & RSS_noise(:,1)==CombinationTriangles(SetofAnchors,2)); %Finds the row for the RSS to be used         
                                            Match3=find(RSS_noise(:,2)==DefiniteNeighbors(d) & RSS_noise(:,1)==CombinationTriangles(SetofAnchors,3)); %Finds the row for the RSS to be used         
                                            if (isempty(Match1)==0 & isempty(Match2)==0 & isempty(Match3)==0)
                                            
                                                 Number_neighbors=Number_neighbors+1;
                                                %Format of MatrixRSSNeighborhood=MatrixRSSNeighborhood=[TargetNode Neighbornode Anchor RSS]
                                                 MatrixRSSNeighborhood(temp3,:)=[i DefiniteNeighbors(d) CombinationTriangles(SetofAnchors,1) RSS_noise(Match1,3)]; %Obtain RSS between the anchor and the neigbor
                                                 MatrixRSSNeighborhood(temp3+1,:)=[i DefiniteNeighbors(d) CombinationTriangles(SetofAnchors,2) RSS_noise(Match2,3)];
                                                 MatrixRSSNeighborhood(temp3+2,:)=[i DefiniteNeighbors(d) CombinationTriangles(SetofAnchors,3) RSS_noise(Match3,3)];
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

                                 end %Fin del Range of DefiniteNeighbors
                                 if(aux3==Number_neighbors)
                                         %Means that it has not entered to a
                                         %neighbor that reports that the
                                         %target node is outside, thus
                                         %the target node is inside of
                                         %the triangle
                                         TableNodesInside(aux4,:)=[i CombinationTriangles(SetofAnchors,1) CombinationTriangles(SetofAnchors,2) CombinationTriangles(SetofAnchors,3)];
                                         Counterfornodenoestimate=1; %Mean that we can ESTIMATE the position of the node i since it lies of at least one seat of anchors
                                          aux4=aux4+1;
                                 end %For if->aux3
                                 %Reset counters, before change anchors
                                 Number_neighbors=0;
                                 aux3=0;
                                 %We may increase the pointers of the table of the target
                                 %node before it changes to the SetofAnchors
                                 InitSubtable_MatrixRSSTargetNode=InitSubtable_MatrixRSSTargetNode+3;   
                                 EndSubtable_MatrixRSSTargetNode=EndSubtable_MatrixRSSTargetNode+3;
                        end %Fin del end para saber si existe el Neighborhood_shared
                    end% Fin del for para SetAnchors
                end %fin del if para saber si existeanchorstriangle
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
    DefiniteNeighbors=[];
    DefiniteAnchors=[];

fprintf(1,'--Computed RSSTargetNode and RSSNeighbors Tables for all nodes\n');
if Warningflag_impossibleest==1; %Means that no nodes were found to be estimated
    fprintf(1,'--No nodes can be estimated!');
    Endprogram=1;
    return;
else
    Endprogram=0;
    %Procedure to filter values, since TableNodesOutsidetemp have repetitive rows.  TableNodesOutsidetempo is
    %the same that TableNodesOutsidetemp with the exception that it does not
    %have repetitive rows
    if (isempty(TableNodesOutsidetemp)==0)
        [m n]=size(TableNodesOutsidetemp);
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
    end
   
    cont3=1;
    if (isempty(find(Nodeswecanestimate==i))==1) % if (1) means that the node is not found in Nodeswecanestimate and therefore is part of the Nodeswecannotestimate
            Nodeswecannotestimate(cont3,:)=i;
            cont3=cont3+1;
    else
            Nodeswecannotestimate=[];
    end
    
    %Procedure in order to eliminate the nodes that are reported outside of a
    %particular combination of 3 anchors, so we eliminate the rows from
    %TableNodesOutsidetempo according to Nodeswecannotestimate
    if (isempty(Nodeswecannotestimate)==1) & (isempty(TableNodesOutsidetemp)==0) %if it exists the array of Nodeswecannotestimate
        [m n]=size(TableNodesOutsidetempo);
        %We eliminate the following part of the code, we are dealing only
        %with one node that can be estimated
        %[o p]=size(Nodeswecannotestimate);
        %for j=1:o
        %    for i=1:m
        %        if (isempty(find(Nodeswecannotestimate(j,1)==TableNodesOutsidetempo(i,1)))==0) %if it is found in Table  in the first column (which is the Target Node) we should eliminate it.
        %            TableNodesOutsidetempo(i,:)=[0 0 0 0]; %Artifitial way to eliminate it
        %        end
        %    end
        %end
        if(TableNodesOutsidetempo==zeros(m,n)) %We can be in the situation in which all nodes are inside of the triangles, so there are no nodes we can estimate outside of triangles, and we have to assign the
                                               %variable TableNodesOutside
            TableNodesOutside=[]; %Simply there are no nodes outside of triangles
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
    %We are dealing only with one node
    %else
    %    TableNodesOutside=TableNodesOutsidetempo;
    end
end
%Save matrices
letter1i='Tinside'
letter2i='.mat'
letter1o='Toutside'
letter2o='.mat'
TinsideMatrix=strcat(letter1i,Name_file,letter2i); %It concatenates: Tinside(Name_file).mat
ToutsideMatrix=strcat(letter1o,Name_file,letter2o); %It concatenates: Toutside(Name_file).mat
save ("-text", TinsideMatrix, "TableNodesInside");
save ("-text", ToutsideMatrix, "TableNodesOutside");
    