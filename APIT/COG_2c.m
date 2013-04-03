function [Estimatedcoordinates]=COG_2c(Target_GridMaxArea, Indices, OldAnchors)

%COG computes the center of gravity for each area with the maximum value 
%Output parameters: Estimatedcoordinates-> Estimated positions for all the
%nodes
%Input parameteres: Indices: Nodes (e.g. 1, 2, 4,...) which are anchors.

global M N 
%Format Target_GridMaxArea=[TargetNode PointinGrid w/ max value]
[m n]=size(Target_GridMaxArea);
cont2=1;
aux=0;
aux2=1;
temp=0;
cont=1;
for h=1:(M+N) %M+N
   %Check out progress of the simulation w/ the number of Target node
    %Only consider target nodes, not anchors  (if 1= mean that it is not an
    %anchor node, it is a target node)
    if (isempty(find(Indices==h))==1) & (isempty(find(OldAnchors==h))==1)
        for j=1:m %Checking in the first column the target node 
            if h==Target_GridMaxArea(j,1)
                for k=1:m
                    if Target_GridMaxArea(j,:)==Target_GridMaxArea(k,:)
                        aux=aux+1;   
                        if aux>=2
                               Target_GridMaxArea(k,:)=[0 0 0 0]; 
                               %Duplicate Target_GridMaxArea in order to check that  if we have
                               %two rows w/ same values in differents parts
                               %of the array we may take only one in order
                               %to not affect the COG.
                               cont=cont+1;
                         end
                     end
                end
                aux=0;
            end
        end
    end
end
for i=1:m
    if Target_GridMaxArea(i,:)==[0 0 0 0]
        doomy=1; %Just a doomy alg
    else
        Target_GridMaxArea2(aux2,:)=Target_GridMaxArea(i,:);
        aux2=aux2+1;
    end
end
[m n]=size(Target_GridMaxArea2);
count=0;
count2=1;
temp=0;
Booleano=0;
aux=1;
for i=1:(M+N) %M+N
    %Check out progress of the simulation w/ the number of Target node
    %Only consider target nodes, not anchors  (if 1= mean that it is not an
    %anchor node, it is a target node)
    if (isempty(find(Indices==i))==1) & (isempty(find(OldAnchors==i))==1)
        indiceinferior=aux;
        for j=1:m
            if i==Target_GridMaxArea2(j,1) %Search for a target node in Target_GridMaxArea
                ForComputingCx(count+1,:)=[Target_GridMaxArea2(count+1,2)]; %2 for x 3 for y (remember that z=0)
                ForComputingCy(count+1,:)=[Target_GridMaxArea2(count+1,3)];
                count=count+1;
                aux=aux+1;
                temp=temp+1;
                Booleano=1;
            end
        end
          indicesuperior=aux-1;
        %Compute Cx and Cy
        if Booleano==1
            Booleano=0;
            Cx=sum(ForComputingCx(indiceinferior:indicesuperior))/temp;
            Cy=sum(ForComputingCy(indiceinferior:indicesuperior))/temp;
            %Format Estimatedcoordinates=Estimatedcoordinates[i Cx Cy]
            Estimatedcoordinates(count2,:)=[i Cx Cy];
            count2=count2+1;
        end
        temp=0; %Because we are changing of node
    end
end
%Plot estimated coordinates
%plot(Estimatedcoordinates(:,2),Estimatedcoordinates(:,3),'s','MarkerEdgeColor','k','MarkerFaceColor','g');
%labels = num2str(Estimatedcoordinates(:,1));
%For labelling each sensor
%text(Estimatedcoordinates(:,2)+.06,Estimatedcoordinates(:,3),labels,'Color','r');


