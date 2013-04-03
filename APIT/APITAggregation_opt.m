function Target_GridMaxArea=APITAggregation(X,TableNodesOutside, TableNodesInside);
%This variable will divide the area in gridSize x gridSize
gridSize=3;

%Counters for positive and negative triangles
%For each APIT inside decision (a decision where the APIT test
%determines the node is inside a particular region) the values of the
%grid regions over which the corresponding triangle resides are
%incremented. For an outside decision, the grid area is similarly
%decremented. Once all triangular regions are computed, the
%resulting information is used to find the maximum overlapping
%area (e.g. the grid area with value 2 in Figure 8), which is then
%used to calculate the center of gravity for position estimation.
%Counters
Counter_positivetriangle=1;
Counter_negativetriangle=-1;
count=1;
cont=1;
cont2=1;
aux=1;
aux2=1;
Booleano_entrance=0; %in order to not have a lot of zeros in rows of Negativeareas and Positiveareas
Doesitexist=0;

 %Computing reference points
[m n]=size(TableNodesInside)
[p q]=size(TableNodesOutside)
for i=1:30
     for j=1:m
         if i==TableNodesInside(j,1)
             %Format of TableNodesInside[TargetNode Anchor1 Anchor2
             %Anchor3]
             %For the first anchor
              RefpointAinside(count,:)=[i X(TableNodesInside(j,2),1) X(TableNodesInside(j,2),2) 0];
             %For the second anchor 
              RefpointBinside(count,:)=[i X(TableNodesInside(j,3),1) X(TableNodesInside(j,3),2) 0];
              %For the thrid anchor
              RefpointCinside(count,:)=[i X(TableNodesInside(j,4),1) X(TableNodesInside(j,4),2) 0];
              count=count+1;
         end
     end
     count=1;
     for j=1:p
         if i==TableNodesOutside(j,1)
             %Format of TableNodesInside[TargetNode Anchor1 Anchor2
             %Anchor3]
             %For the first anchor
              RefpointAoutside(count,:)=[i X(TableNodesOutside(j,2),1) X(TableNodesOutside(j,2),2) 0];
             %For the second anchor 
              RefpointBoutside(count,:)=[i X(TableNodesOutside(j,3),1) X(TableNodesOutside(j,3),2) 0];
              %For the third anchor
              RefpointCoutside(count,:)=[i X(TableNodesOutside(j,4),1) X(TableNodesOutside(j,4),2) 0];
              count=count+1;
         end
     end
end
count=1;

%Points in the grid (Decision Triangles outside of the target node)
[u v]=size(RefpointAoutside);
[a b]=size(RefpointAinside);
for r=0:0.5:10
    for s=0:0.5:10
        %Matrix H contains the coordinates for each of the corners of the
        %squares of the grid
        H(cont,:)=[r s 0];
        cont=cont+1;
    end
end
cont=1;

[w x]=size(H);
Doesitexisto=0;
Doesitexisti=0;
for t=1:w
    for i=1:30
        for j=1:u
            if i==RefpointAoutside(j,1)
                     RefpointcrossAo(cont,:)=[RefpointAoutside(j,2) RefpointAoutside(j,3) 0];
                     RefpointcrossBo(cont,:)=[RefpointBoutside(j,2) RefpointBoutside(j,3) 0];
                     RefpointcrossCo(cont,:)=[RefpointAoutside(j,2) RefpointCoutside(j,3) 0];
                     M=cross(H(t,:)-RefpointcrossAo(cont,:),RefpointcrossBo(cont,:)-RefpointcrossAo(cont,:)); 
                     N=cross(H(t,:)-RefpointcrossBo(cont,:),RefpointcrossCo(cont,:)-RefpointcrossBo(cont,:));
                     O=cross(H(t,:)-RefpointcrossCo(cont,:),RefpointcrossAo(cont,:)-RefpointcrossCo(cont,:));
                     %Because the target node is outside of the triangle,
                     %points of the grid inside of the triangle should be
                     %decreased
                     if ((M(1,3)>0)&(N(1,3)>0)&(O(1,3)>0)) | ((M(1,3)<0)&(N(1,3)<0)&(O(1,3)<0))
                                 Insidethetriangleo(aux,:)=[i H(t,:) 0];
                                 aux=aux+1;
                                 Doesitexisto=1;
                     end
                     cont=cont+1;
            end
        end
        
        %-->INSERT RefointAinside (size RefpointAinside)
        for j=1:a
            if i==RefpointAinside(j,1)
                         RefpointcrossAi(cont,:)=[RefpointAinside(j,2) RefpointAinside(j,3) 0];
                         RefpointcrossBi(cont,:)=[RefpointBinside(j,2) RefpointBinside(j,3) 0];
                         RefpointcrossCi(cont,:)=[RefpointAinside(j,2) RefpointCinside(j,3) 0];
                         M=cross(H(t,:)-RefpointcrossAi(cont,:),RefpointcrossBi(cont,:)-RefpointcrossAi(cont,:)); 
                         N=cross(H(t,:)-RefpointcrossBi(cont,:),RefpointcrossCi(cont,:)-RefpointcrossBi(cont,:));
                         O=cross(H(t,:)-RefpointcrossCi(cont,:),RefpointcrossAi(cont,:)-RefpointcrossCi(cont,:));
                         %Because the target node is outside of the triangle,
                         %points of the grid inside of the triangle should be
                         %decreased
                         if ((M(1,3)>0)&(N(1,3)>0)&(O(1,3)>0)) | ((M(1,3)<0)&(N(1,3)<0)&(O(1,3)<0))
                                     Insidethetrianglei(aux,:)=[i H(t,:) 1];
                                     aux=aux+1;
                                     Doesitexisti=1;
                         end
                         cont=cont+1;
            end
       end
   end
end
if Doesitexisto==0
     fprintf(1,'--Insidethetriangleo EMPTY\n');
     return;
else
    fprintf(1,'--Insidethetriangleo done!\n');
end
if Doesitexisti==0
     fprintf(1,'--Insidethetrianglei EMPTY\n');
     return;
else
    fprintf(1,'--Insidethetriangleo done!\n');
end
Doesitexisto=0;
Doesitexisti=0;    

Booleano_entranceo=0;
Booleano_entrancei=0;

[m n]=size(Insidethetriangleo);
[r s]=size(Insidethetrianglei);
[o p]=size(H); %H is very big in size in comparison to Insidethetriangleo

%All the points of the grid that are inside of the triangles in which the
for i=1:30
    for k=1:o
        for l=1:m
            if H(k,:)==Insidethetriangleo(l,2:4)
                if i==Insidethetriangleo(l,1)
                    %Format of Negativeareas=Negativeareas[TargetNode Point of the
                    %grid Counter]
                    Negativeareas(cont2,:)=[Insidethetriangleo(l,1) H(k,:) Counter_negativetriangle];
                    %We increase the negative counter (because it appears in
                    %another triangle, thus there is overlapping)
                    Counter_negativetriangle=Counter_negativetriangle-1;
                    Booleano_entranceo=1;
                end
            end
        end
               
        %Because another point of the grid is considered
        Counter_negativetriangle=-1;
        if Booleano_entranceo==1
            cont2=cont2+1;
            Booleano_entranceo=0;
        end
        %Reset cont2 for the other loop
        cont2=1;
        %---->INSERT Insidethetrianglei, Positiveareas
        for l=1:r
            if H(k,:)==Insidethetrianglei(l,2:4)
                if i==Insidethetrianglei(l,1)
                    %Format of Positiveareas=Positiveareas[TargetNode Point of the
                    %grid Counter]
                    Positiveareas(cont2,:)=[Insidethetrianglei(l,1) H(k,:) Counter_positivetriangle]
                    %We increase the negative counter (because it appears in
                    %another triangle, thus there is overlapping)
                     Counter_positivetriangle=Counter_positivetriangle+1;
                     Booleano_entrancei=1;
                end
               
            end
        end
        %Because another point of the grid is considered
        Counter_positivetriangle=1;
        if Booleano_entrancei==1
            cont2=cont2+1;
            Booleano_entrancei=0;
        end
    end
    
end
if (Booleano_entrancei==1)
    fprintf(1,'--Positiveareas done!\n');
end
if (Booleano_entranceo==1)
    fprintf(1,'--Negativeareas done!\n');
end

%Reset Booleano_entrances
Booleano_entranceo=0;
Booleano_entrancei=0;

%Reinitialization counters:
count=0;
cont=1;
cont2=1;
aux=1;

%Points in the grid (Decision Triangles target node is inside)
%---------->

Doesitexist=0;

%Check%out--------------------------------------------------------
%Tenemos definido solo un H(k,:)
[m n]=size(Positiveareas);
[o p]=size(Negativeareas);
cont=1;
for i=1:30
    for j=1:m
        if i==Positiveareas(j,1)
            for k=1:o
                if ((i==Negativeareas(k,1)) & (Positiveareas(j,2:4)==Negativeareas(k,2:4)))
                    %Format of Suma_total=Suma_total[TargetNode Gridpoint, Total value ]
                    Suma_total(aux2,:)=[Positiveareas(j,1) Positiveareas(j,2:4)  Positiveareas(j,5)+Negativeareas(k,5)];
                   % Elements_totakeoutPos(aux2,:)=[i j];
                   % Elements_totakeoutNeg(aux2,:)=[i k];
                    aux2=aux2+1;
                    Doesitexist=1;
                else
                    Positiveareas(cont,:)=[Positiveareas(j,1) Positiveareas(j,2:4)  Positiveareas(j,5)];
                    Negativeareas(cont,:)=[Negativeareas(k,1) Negativeareas(k,2:4)  Negativeareas(k,5)];
                    cont=cont+1;
                end
            end
        end
    end
end
cont=1;
%[m n]=size(Elements_totakeoutPos);

aux=1;
aux2=1;
% We should take out the rows of Positiveareas and Negativeareas that are
% already taken in Suma_total
%count=1;
%if Doesitexist==1

 %   for i=1:30
 %       for j=1:m
 %           if (i~=Elements_totakeoutPos(j,1)) | (j~=Elements_totakeoutPos(j,2))
 %               Positiveareas(count,:)=[Positiveareas(j,1) Positiveareas(j,2:4) Positiveareas(j,5)];
 %               count=count+1;
 %           end
 %       end
 %   end
 %   count=1;
 %   for i=1:30
 %       for k=1:o
 %           if (i~=Elements_totakeoutNeg(k,1)) | (k~=Elements_totakeoutNeg(k,2))
 %               Negativeareas(count,:)=[Negativeareas(k,1) Negativeareas(k,2:4) Negativeareas(k,5)];
 %               count=count+1;
 %           end
 %       end
 %   end
 %   count=1;
%end

%Concatenate matrices horizontally c=[A A A
%                                     -----
%                                     B B B]
%C = [A; B]                 % Vertically concatenate A and B
if Doesitexist==1
    Suma_total=[Suma_total;Positiveareas;Negativeareas];
    fprintf(1,'--Overlapping areas done!\n');
else
    Suma_total=[Positiveareas;Negativeareas];
    fprintf(1,'--Overlapping areas done!\n');
end
Doesitexist=0;
%At the end of the day we are going to have
%an array of points of the grid with the max value in the 4th column of
%Suma_total
%ArrayMaxArea does it has a shape of a triangle?
%---------------------------Checked out-----------------------------------
Booleano_entrance=0;
[m n]=size(Suma_total);
for i=1:30
    indiceinferior=aux;
    for j=1:m
        if i==Suma_total(j,1)
            Subset_suma(aux,:)=[Suma_total(j,2:4) Suma_total(j,5)];
            aux=aux+1;
            Booleano_entrance=1;
        end
    end
    indicesuperior=aux-1;
    %Subset_suma=[1 ... MAX  ---> r =5
    %             1 ... MAX
    %             1 ... a
    %             1 ... b
    %             1 ... c]
    if Booleano_entrance==1
        Booleano_entrance=0;
        valor_max_targeti=max(Subset_suma(indiceinferior:indicesuperior,4)); %which belongs to :,5 of Suma_total
        %[r s]=size(Subset_suma(indiceinferior:indicesuperior,:);
        for h=indiceinferior:indicesuperior
            if valor_max_targeti==Subset_suma(h,4) %which belongs to :,5 of Suma_total
                 %Format Target_GridMaxArea=Target_GridMaxArea[TargetNode PointinGrid w/ max value]
                 %Target_GridMaxArea=[1 Pointgridx Pointgridy Pointgridz=0  -> these
                 %are the rows with MAX value of counter of overlapping
                 %              1 Pointgridx Pointgridy Pointgridz=0] MAX
                 Target_GridMaxArea(aux2,:)=[i Subset_suma(h,1:3)]; %which belongs to 2:4 of Suma_total
                 aux2=aux2+1; 
            end
        end
    end
end

fprintf(1,'--Max overlapping area done!\n');

 %Divide the grid in 0.1 increments, we can refine this value later.In
 %addition, we have a grid of 10x10 as defined in deploy_nodes_random
 %function
 set(gca,'xlim',[0 10])
 set(gca,'ylim',[0 10])
 set(gca,'xTick',0:0.5:10)
 set(gca,'yTick',0:0.5:10)
 grid;
 
