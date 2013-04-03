function [Insidethetriangleo, Insidethetrianglei, Target_GridMaxArea, Suma_total_d, Suma_total, Positiveareas, Negativeareas]=APITAggregation(X,TableNodesOutside, TableNodesInside, Indices);
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
counti=1;
counto=1;
cont=1;
cont2=1;
aux=1;
aux2=1;
Booleano_entrance=0; %in order to not have a lot of zeros in rows of Negativeareas and Positiveareas
Doesitexist=0;

 %Computing reference points
[m n]=size(TableNodesInside);
[p q]=size(TableNodesOutside);
%We have to consider only the blindfolded devices (to save runtime
%execution)
for i=1:45 %M+N
    %Check out progress of the simulation w/ the number of Target node
    %Only consider target nodes, not anchors  (if 1= mean that it is not an
    %anchor node, it is a target node)
    if (isempty(find(Indices==i))==1)
         for j=1:m
             if i==TableNodesInside(j,1)
                 %Format of TableNodesInside[TargetNode Anchor1 Anchor2
                 %Anchor3]
                 %For the first anchor
                  RefpointAinside(counti,:)=[i X(TableNodesInside(j,2),1) X(TableNodesInside(j,2),2) 0];
                 %For the second anchor 
                  RefpointBinside(counti,:)=[i X(TableNodesInside(j,3),1) X(TableNodesInside(j,3),2) 0];
                  %For the thrid anchor
                  RefpointCinside(counti,:)=[i X(TableNodesInside(j,4),1) X(TableNodesInside(j,4),2) 0];
                  counti=counti+1;
             end
         end

         for j=1:p
             if i==TableNodesOutside(j,1)
                 %Format of TableNodesInside[TargetNode Anchor1 Anchor2
                 %Anchor3]
                 %For the first anchor
                  RefpointAoutside(counto,:)=[i X(TableNodesOutside(j,2),1) X(TableNodesOutside(j,2),2) 0];
                 %For the second anchor 
                  RefpointBoutside(counto,:)=[i X(TableNodesOutside(j,3),1) X(TableNodesOutside(j,3),2) 0];
                  %For the third anchor
                  RefpointCoutside(counto,:)=[i X(TableNodesOutside(j,4),1) X(TableNodesOutside(j,4),2) 0];
                  counto=counto+1;
             end
         end
    end
end

fprintf(1,'--Referencepoints done!\n');

%Points in the grid (Decision Triangles outside of the target node)
[u v]=size(RefpointAoutside);
[a b]=size(RefpointAinside);
for r=0:1:10
    for s=0:1:10
        %Matrix H contains the coordinates for each of the corners of the
        %squares of the grid
        H(cont,:)=[r s 0];
        cont=cont+1;
    end
end
cont=1;
counti=1;
counto=1;
auxo=1;
auxi=1;

fprintf(1,'--Matrix H with points of the grid done!\n');

%cross lo hace por columnas
%cross para este caso lo haria renglon a renglon
%Idea: hacerlo todo de un jalon desde RefpointAoutside pero sin tomar la
%primera columna que hace referencia al nodo
%guardar los valores en matrices M N O y tomar en cuenta la tercera columna
%solo necesitariamos un for para la matriz H
%problema H y RefpointAoutside no son del mismo size
%


[w x]=size(H);
Doesitexisto=0;
Doesitexisti=0;
for t=1:w %size of H
    for i=1:45 %M+N
            %Check out progress of the simulation w/ the number of Target node
            %Only consider target nodes, not anchors  (if 1= mean that it is not an
            %anchor node, it is a target node)
            if (isempty(find(Indices==i))==1)
                for j=1:u %size of RefpointAoutside
                    if i==RefpointAoutside(j,1)     %RefpointAoutside(j,2:3)->Refers to the same anchor
                             RefpointcrossAo(counto,:)=[RefpointAoutside(j,2) RefpointAoutside(j,3) 0];
                             RefpointcrossBo(counto,:)=[RefpointBoutside(j,2) RefpointBoutside(j,3) 0];
                             RefpointcrossCo(counto,:)=[RefpointCoutside(j,2) RefpointCoutside(j,3) 0];

                             %M=cross(H(cont,:)-Refpoint(i,:),Refpoint(i+1,:)-Refpoint(i,:));
                             %N=cross(H(cont,:)-Refpoint(i+1,:),Refpoint(i+2,:)-Refpoint(i+1,:));
                             %O=cross(H(cont,:)-Refpoint(i+2,:),Refpoint(i,:)-Refpoint(i+2,:));

                             M=cross(H(t,:)-RefpointcrossAo(counto,:),RefpointcrossBo(counto,:)-RefpointcrossAo(counto,:)); 
                             N=cross(H(t,:)-RefpointcrossBo(counto,:),RefpointcrossCo(counto,:)-RefpointcrossBo(counto,:));
                             O=cross(H(t,:)-RefpointcrossCo(counto,:),RefpointcrossAo(counto,:)-RefpointcrossCo(counto,:));
                             %Because the target node is outside of the triangle,
                             %points of the grid inside of the triangle should be
                             %decreased
                             if ((M(1,3)>0)&(N(1,3)>0)&(O(1,3)>0)) | ((M(1,3)<0)&(N(1,3)<0)&(O(1,3)<0))
                                         Insidethetriangleo(auxo,:)=[i H(t,:) 0];
                                         auxo=auxo+1;
                                         Doesitexisto=1;
                             end
                             counto=counto+1;
                    end
                end
                fprintf(1,'--Checking GRID POINT H=[%f %f] inside of triangle for the TargetNodeOutside [%d]!\n',H(t,1),H(t,2),i);
                aux=1;
                %-->INSERT RefointAinside (size RefpointAinside)
                for j=1:a
                    if i==RefpointAinside(j,1)
                                 RefpointcrossAi(counti,:)=[RefpointAinside(j,2) RefpointAinside(j,3) 0];
                                 RefpointcrossBi(counti,:)=[RefpointBinside(j,2) RefpointBinside(j,3) 0];
                                 RefpointcrossCi(counti,:)=[RefpointCinside(j,2) RefpointCinside(j,3) 0];
                                 M=cross(H(t,:)-RefpointcrossAi(counti,:),RefpointcrossBi(counti,:)-RefpointcrossAi(counti,:)); 
                                 N=cross(H(t,:)-RefpointcrossBi(counti,:),RefpointcrossCi(counti,:)-RefpointcrossBi(counti,:));
                                 O=cross(H(t,:)-RefpointcrossCi(counti,:),RefpointcrossAi(counti,:)-RefpointcrossCi(counti,:));
                                 %Because the target node is outside of the triangle,
                                 %points of the grid inside of the triangle should be
                                 %decreased
                                 if ((M(1,3)>0)&(N(1,3)>0)&(O(1,3)>0)) | ((M(1,3)<0)&(N(1,3)<0)&(O(1,3)<0))
                                             Insidethetrianglei(auxi,:)=[i H(t,:) 1];
                                             auxi=auxi+1;
                                             Doesitexisti=1;
                                 end
                                 counti=counti+1;
                    end
                end
               fprintf(1,'--Checking GRID POINT H=[%f %f] inside of triangle for the TargetNodeInside [%d]!\n',H(t,1),H(t,2),i);
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
    fprintf(1,'--Insidethetrianglei done!\n');
end
Doesitexisto=0;
Doesitexisti=0;    

Booleano_entranceo=0;
Booleano_entrancei=0;

[m n]=size(Insidethetriangleo);
[r s]=size(Insidethetrianglei);
[o p]=size(H); %H is very big in size in comparison to Insidethetriangleo

cont_neg=1;
cont_pos=1;
%Consider negative areas (points inside of the triangles that are outside
%of a target node)
for i=1:45 %M+N
    %Check out progress of the simulation w/ the number of Target node
    %Only consider target nodes, not anchors  (if 1= mean that it is not an
    %anchor node, it is a target node)
    if (isempty(find(Indices==i))==1)
        for k=1:o
            for l=1:m
                if H(k,:)==Insidethetriangleo(l,2:4)
                    if i==Insidethetriangleo(l,1)
                        %Format of Negativeareas=Negativeareas[TargetNode Point of the
                        %grid Counter]
                        Negativeareas(cont_neg,:)=[Insidethetriangleo(l,1) H(k,:) Counter_negativetriangle];
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
                cont_neg=cont_neg+1;
                Booleano_entranceo=0;
            end

            %---->INSERT Insidethetrianglei, Positiveareas
            for l=1:r
                if H(k,:)==Insidethetrianglei(l,2:4)
                    if i==Insidethetrianglei(l,1)
                        %Format of Positiveareas=Positiveareas[TargetNode Point of the
                        %grid Counter]
                        Positiveareas(cont_pos,:)=[Insidethetrianglei(l,1) H(k,:) Counter_positivetriangle];
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
                cont_pos=cont_pos+1;
                Booleano_entrancei=0;
            end
        end
    end
end
fprintf(1,'--Positiveareas done!\n');
fprintf(1,'--Negativeareas done!\n');

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
for i=1:45 %M+N
    %Check out progress of the simulation w/ the number of Target node
    %Only consider target nodes, not anchors  (if 1= mean that it is not an
    %anchor node, it is a target node)
    if (isempty(find(Indices==i))==1)
        for j=1:m
            no_reppos=0;
            if i==Positiveareas(j,1)
                for k=1:o
                    if ((i==Negativeareas(k,1)) & (Positiveareas(j,2:4)==Negativeareas(k,2:4)))
                        %Format of Suma_total=Suma_total[TargetNode Gridpoint, Total value ]
                        Suma_total(aux2,:)=[Positiveareas(j,1) Positiveareas(j,2:4)  Positiveareas(j,5) + Negativeareas(k,5)];
                       % Elements_totakeoutPos(aux2,:)=[i j];
                       % Elements_totakeoutNeg(aux2,:)=[i k];
                        aux2=aux2+1;
                        Doesitexist=1;
                        no_reppos=1;
                  %  else 
                  %      Positiveareas(cont,:)=[Positiveareas(j,1) Positiveareas(j,2:4)  Positiveareas(j,5)];
                   %     Negativeareas(cont,:)=[Negativeareas(k,1) Negativeareas(k,2:4)  Negativeareas(k,5)];
                   %     cont=cont+1;
                    end
                end
            end
            if no_reppos==0
                Positiveareas_d(cont,:)=[Positiveareas(j,1) Positiveareas(j,2:4)  Positiveareas(j,5)];
               % Negativeareas(cont,:)=[Negativeareas(k,1) Negativeareas(k,2:4)  Negativeareas(k,5)];
                cont=cont+1;
            end
        end
    end
end
cont=1;
%To eliminate repetitive elements
[m n]=size(Suma_total);
[f g]=size(Negativeareas);
for p=1:m
    for q=1:f
        if Suma_total(p,1:4)==Negativeareas(q,1:4)
            doomy=1;
        else
            Negativeareas_d(cont,:)=Negativeareas(q,:);
            cont=cont+1;
        end
    end
end
cont=1;

%[m n]=size(Elements_totakeoutPos);
aux=1;
aux2=1;

%Concatenate matrices horizontally c=[A A A
%                                     -----
%                                     B B B]
%C = [A; B]                 % Vertically concatenate A and B
if Doesitexist==1
    Suma_total_d=[Suma_total;Positiveareas_d;Negativeareas_d];
    fprintf(1,'--Overlapping areas done!\n');
else
    Suma_total_d=[Positiveareas_d;Negativeareas_d];
    fprintf(1,'--Overlapping areas done!\n');
end
Doesitexist=0;
%At the end of the day we are going to have
%an array of points of the grid with the max value in the 4th column of
%Suma_total
%ArrayMaxArea does it has a shape of a triangle?
%---------------------------Checked out-----------------------------------
Booleano_entrance=0;
[m n]=size(Suma_total_d);
for i=1:45 %M+N
    %Check out progress of the simulation w/ the number of Target node
    %Only consider target nodes, not anchors  (if 1= mean that it is not an
    %anchor node, it is a target node)
    if (isempty(find(Indices==i))==1)
        indiceinferior=aux;
        for j=1:m
            if i==Suma_total_d(j,1)
                Subset_suma(aux,:)=[Suma_total_d(j,2:4) Suma_total_d(j,5)];
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
end

fprintf(1,'--Max overlapping area done!\n');

 %Divide the grid in 0.1 increments, we can refine this value later.In
 %addition, we have a grid of 10x10 as defined in deploy_nodes_random
 %function
 set(gca,'xlim',[0 10])
 set(gca,'ylim',[0 10])
 set(gca,'xTick',0:1:10)
 set(gca,'yTick',0:1:10)
 grid;
 
