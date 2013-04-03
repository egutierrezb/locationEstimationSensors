function [Target_GridMaxArea]=APITAggregation_noise_def(X,TableNodesOutside, TableNodesInside, Indices, H);

%APITAggregation_noise_def computes the overlapping of positive and negative
%areas and then it obtains the maximum value with the node and the point of
%the grid, in noisy environments.
%Input parameteres: X-> the positions of the nodes
%TableNodesInside-> Nodes which fall inside w/ a combination of a triangle
%TableNodesOutside->Nodes which fall outside w/ a combination of a triangle
%Indices->Nodes (e.g. 1, 4, 8) which are anchors
%Output parameters of interest: Target_GridMaxArea which has the node and
%the grid point with the maximum value.

global M N Res 

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
for i=1:(M+N) %M+N
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
         if(isempty(TableNodesOutside)==0) %if TableNodesOutside has at least one element (no empty) we should proceed
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
         else
             RefpointAoutside=[];
         end
    end
end

fprintf(1,'--Referencepoints done!\n');

%Points in the grid (Decision Triangles outside of the target node)
%We use conditionals hereinafter for all those variables that refer to
%Outside since we can be in the situation that we can only have nodes
%inside of triangles
if(isempty(RefpointAoutside)==0)
    [u v]=size(RefpointAoutside);
end
[a b]=size(RefpointAinside);

cont=1;
counti=1;
counto=1;
auxo=1;
auxi=1;

fprintf(1,'--Matrix H with points of the grid done!\n');

[w x]=size(H);
Doesitexisto=0;
Doesitexisti=0;

%Keep value: Copy node to the first column of the matrices for which we are going to use 
%for computing nodes inside of the triangle
%(TriangleInside/TriangleOutside)
if(isempty(RefpointAoutside)==0)
    Mt(:,1)=RefpointAoutside(:,1);
    Nt(:,1)=RefpointAoutside(:,1);
    Ot(:,1)=RefpointAoutside(:,1);
end
Pt(:,1)=RefpointAinside(:,1);
Qt(:,1)=RefpointAinside(:,1);
Rt(:,1)=RefpointAinside(:,1);

for t=1:w %size of H
%RefpointAoutside(counto,:)=[i X(TableNodesOutside(j,2),1)
%X(TableNodesOutside(j,2),2) 0]
   if(isempty(RefpointAoutside)==0) 
        Hrepo=repmat(H(t,:),u,1); %Repeat H(t,:) u times in order to be congruent and it can be substracted from RefpointAoutside
        Mt(:,2:4)=cross(Hrepo-RefpointAoutside(:,2:4),RefpointBoutside(:,2:4)-RefpointAoutside(:,2:4)); 
        Nt(:,2:4)=cross(Hrepo-RefpointBoutside(:,2:4),RefpointCoutside(:,2:4)-RefpointBoutside(:,2:4));
        Ot(:,2:4)=cross(Hrepo-RefpointCoutside(:,2:4),RefpointAoutside(:,2:4)-RefpointCoutside(:,2:4));
        for j=1:u %size of RefpointAoutside
            if ((Mt(j,4)>0)&(Nt(j,4)>0)&(Ot(j,4)>0)) | ((Mt(j,4)<0)&(Nt(j,4)<0)&(Ot(j,4)<0))
                         Insidethetriangleo(auxo,:)=[Mt(j,1) Hrepo(1,:) 0]; %As all the matrix has all the same values we choose the first row
                         auxo=auxo+1;
                         Doesitexisto=1;
            end
        end
        fprintf(1,'--Checking GRID POINT H=[%f %f] for outside cases\n',Hrepo(1,1),Hrepo(1,2)); %Only for reference we choose the first row
   end
   %RefpointAoutside=[i X(TableNodesInside(j,2),1) X(TableNodesInside(j,2),2) 0]
   %RefpointBoutside=[i X(TableNodesInside(j,3),1) X(TableNodesInside(j,3),2) 0]
   %RefpointCoutside=[i X(TableNodesInside(j,4),1) X(TableNodesInside(j,4),2) 0]

    Hrepi=repmat(H(t,:),a,1);
    Pt(:,2:4)=cross(Hrepi-RefpointAinside(:,2:4),RefpointBinside(:,2:4)-RefpointAinside(:,2:4)); 
    Qt(:,2:4)=cross(Hrepi-RefpointBinside(:,2:4),RefpointCinside(:,2:4)-RefpointBinside(:,2:4));
    Rt(:,2:4)=cross(Hrepi-RefpointCinside(:,2:4),RefpointAinside(:,2:4)-RefpointCinside(:,2:4));
    for j=1:a
        if ((Pt(j,4)>0)&(Qt(j,4)>0)&(Rt(j,4)>0)) | ((Pt(j,4)<0)&(Qt(j,4)<0)&(Rt(j,4)<0))
                     Insidethetrianglei(auxi,:)=[Pt(j,1) Hrepi(1,:) 0]; %As all the matrix has all the same values we choose the first row
                     auxi=auxi+1;
                     Doesitexisti=1;
        end
    end
    fprintf(1,'--Checking GRID POINT H=[%f %f] for inside cases\n',Hrepi(1,1),Hrepi(1,2));
    Hrepo=[];
    Hrepi=[];
end

fprintf(1,'Checked all grid points inside/outside cases\n');
if(isempty(RefpointAoutside)==0)
    if Doesitexisto==0
         fprintf(1,'--Insidethetriangleo EMPTY\n');
         return;
    else
        fprintf(1,'--Insidethetriangleo done!\n');
    end
end
if Doesitexisti==0
     fprintf(1,'--Insidethetrianglei EMPTY\n');
     return;
else
    fprintf(1,'--Insidethetrianglei done!\n');
end

Doesitexisti=0;    
Booleano_entrancei=0;
if(isempty(RefpointAoutside)==0)
    Doesitexisto=0;
    Booleano_entranceo=0;
    [m n]=size(Insidethetriangleo);
end

[r s]=size(Insidethetrianglei);
[o p]=size(H); %H is very big in size in comparison to Insidethetriangleo
cont_neg=1;
cont_pos=1;

%Sort matrices
if(isempty(RefpointAoutside)==0)
    Insidethetriangleo=sortrows(Insidethetriangleo);
    indiceinferioro=0;
    temp2o=[];
end
Insidethetrianglei=sortrows(Insidethetrianglei);
indiceinferiori=0;
temp2i=[];

%Compute Negativeareas
if(isempty(RefpointAoutside)==0)
    while(indiceinferioro <= m) 
                if temp2o==1
                    break;
                end
                for l=indiceinferioro+1:m %size Insidethetriangleo
                    %Format of Negativeareas=Negativeareas[TargetNode Point of the
                    %grid Counter]
                    temp1o=[];
                    temp2o=[];
                    temp1o=Insidethetriangleo(l,:);
                    if l < m
                        temp2o=Insidethetriangleo(l+1,:);
                    else
                        temp2o=1; %doomy
                    end
                    Negativeareas(cont_neg,:)=[Insidethetriangleo(l,1) Insidethetriangleo(l,2:4) Counter_negativetriangle];
                    %We increase the negative counter (because it appears in
                    %another triangle, thus there is overlapping)
                    Counter_negativetriangle=Counter_negativetriangle-1;
                    Booleano_entranceo=1;
                    if temp1o==temp2o
                        doomy=1;
                    else
                        indiceinferioro=l;
                        break;
                    end
                end

                %Because another point of the grid is considered
                Counter_negativetriangle=-1;
                if Booleano_entranceo==1
                    cont_neg=cont_neg+1;
                    Booleano_entranceo=0;
                end
    end
end

%Compute positive areas
while(indiceinferiori <= r)
           
           if temp2i==1
               break;
           end
            for l=indiceinferiori+1:r %size of Insidethetrianglei
                   temp1i=[];
                   temp2i=[];
                   temp1i=Insidethetrianglei(l,:);
                   if l < r
                       temp2i=Insidethetrianglei(l+1,:);
                   else
                       temp2i=1; %doomy
                   end
                   %Format of Positiveareas=Positiveareas[TargetNode Point of the
                   %grid Counter]
                   Positiveareas(cont_pos,:)=[Insidethetrianglei(l,1) Insidethetrianglei(l,2:4) Counter_positivetriangle];
                   %We increase the positive counter (because it appears in
                   %another triangle, thus there is overlapping)
                   Counter_positivetriangle=Counter_positivetriangle+1;
                   Booleano_entrancei=1;
                   if temp1i==temp2i
                        doomy=1;
                   else
                        indiceinferiori=l;
                        break;
                   end
            end
            %Because another point of the grid is considered
            Counter_positivetriangle=1;
            if Booleano_entrancei==1
                cont_pos=cont_pos+1;
                Booleano_entrancei=0;
            end
 end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(1,'--Positiveareas done!\n');
if(isempty(RefpointAoutside)==0) %If no nodes in TableNodesoutside, we dont have RefpointAoutside, imposible to have negative areas
    fprintf(1,'--Negativeareas done!\n');
end

%Reset Booleano_entrances
if(isempty(RefpointAoutside)==0)
    Booleano_entranceo=0;
end

Booleano_entrancei=0;

%Reinitialization counters:
count=0;
cont=1;
cont2=1;
aux=1;
Doesitexist=0;

[m n]=size(Positiveareas);
if(isempty(RefpointAoutside)==0)
    [o p]=size(Negativeareas);
    Doesnegativeexist=0;
end
Doespositiveexist=0;
cont=1;
Sum_found=0;

%Check if positive and negative are the same, in this case we overlapp
%(sum) the values
if(isempty(RefpointAoutside)==0)
    %Do the procedure of considering positive and negative areas when we have
    %the two arrays, if we do not have TableNodesOutside we do not have Negativeareas and therefore we can not run the following lines 
    for j=1:m %size of Positiveareas
        no_reppos=0;
        for k=1:o                                                %TargetNode          %Gridpoint[x y z]
            Compare_positivenegative=find(Positiveareas(j,1:4)==[Negativeareas(k,1) Negativeareas(k,2:4)]); %Check in the matrix of Negativeareas elements that are equal to Positiveareas
            [q r]=size(Compare_positivenegative); %if size equals to 4 then it has found
            if r==4
                Compare_positivenegative=[];
                Suma_total(aux2,:)=[Positiveareas(j,1) Positiveareas(j,2:4)  Positiveareas(j,5) + Negativeareas(k,5)];
                aux2=aux2+1;
                Doesitexist=1;
                no_reppos=1;
                Sum_found=1;
            end
            if Sum_found==1
                Sum_found=0;
                break; %Terminate the for (k) loop in order to continue with the conditional no_reppos=0? and the next j (to save time)
            end
        end
        if no_reppos==0
                Doespositiveexist=1;
                Positiveareas_d(cont,:)=[Positiveareas(j,1) Positiveareas(j,2:4)  Positiveareas(j,5)];
                cont=cont+1;
        end

    end

    cont=1;
    Sum_found=0;
    Compare_positivenegative=[];
    
    %Check if positive and negative are the same, in this case we overlapp
    %the values, but in the process above we have already sum the values,
    %so we are only interested on obtaining the negative values which are
    %not repeated: Negativeareas_d
    
    for j=1:o %size of Negativeareas
        no_reppos=0;
        for k=1:m                                                %TargetNode          %Gridpoint[x y z]
            Compare_positivenegative=find(Negativeareas(j,1:4)==[Positiveareas(k,1) Positiveareas(k,2:4)]); %Check in the matrix of Negativeareas elements that are equal to Positiveareas
            [q r]=size(Compare_positivenegative); %if size equals to 4 then it has found
            if r==4
                Compare_positivenegative=[];
                no_reppos=1;
                Sum_found=1;
            end
            if Sum_found==1
                Sum_found=0;
                break; %Terminate the for (k) loop in order to continue with the conditional no_reppos=0? and the next j (to save time)
            end

        end
        if no_reppos==0
                Doesnegativeexist=1;
                Negativeareas_d(cont,:)=[Negativeareas(j,1) Negativeareas(j,2:4)  Negativeareas(j,5)];
                cont=cont+1;
        end

    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Reinitialize counters
cont=1;
aux=1;
aux2=1;

%Suma_total_d will contain the TOTAL SUM and its value will depend on the
%situation of having or not positive and negative values

if Doesitexist==1 & Doespositiveexist==1 & Doesnegativeexist==1
    Suma_total_d=[Suma_total; Positiveareas_d; Negativeareas_d]; %Concatenate matrices
elseif Doesitexist==1 & Doespositiveexist==0 & Doesnegativeexist==0
    Suma_total_d=[Suma_total];
elseif Doesitexist==1 & Doespositiveexist==1 & Doesnegativeexist==0
    Suma_total_d=[Suma_total; Positiveareas_d];
elseif Doesitexist==1 & Doespositiveexist==0 & Doesnegativeexist==1
    Suma_total_d=[Suma_total; Negativeareas_d];
elseif Doesitexist==0 & (isempty(RefpointAoutside)==0) %Suma_total does not exist but there are elements outside of the triangle, in order to have Negativeareas
    Suma_total_d=[Positiveareas; Negativeareas];
elseif (isempty(RefpointAoutside)==1) %We do not have Negativeareas, we have to consider only the Positiveareas
    Suma_total_d=[Positiveareas];
end
fprintf(1,'--Overlapping areas done!\n');
Doesitexist=0;

%At the end of the day we are going to have
%an array of points of the grid with the max value in the 4th column of
%Subset_suma for a particular target node
%Subset_suma=[1 .. value; 1 .. value;...]

Booleano_entrance=0;
[m n]=size(Suma_total_d);
for i=1:(M+N) %M+N
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
            valor_max_targeti=max(Subset_suma(indiceinferior:indicesuperior,4)); %4->which belongs to :,5 of Suma_total
            for h=indiceinferior:indicesuperior
                if valor_max_targeti==Subset_suma(h,4) %which belongs to :,5 of Suma_total
                     %Target_GridMaxArea=Target_GridMaxArea[TargetNode
                     %PointinGrid w/ max value], PointinGrid is the point
                     %with the MAX value of the counter of overlapping
                     %(MAX)
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
 set(gca,'xTick',0:Res:10)
 set(gca,'yTick',0:Res:10)
 grid;
 
