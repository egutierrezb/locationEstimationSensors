%This variable will divide the area in gridSize x gridSize
gridSize=3;
%Lets define a triangle
A(1,:)=[0.2 0.4];
A(2,:)=[0.5 0.9];
A(3,:)=[0.7 0.1];
%Define the second triangle
A(4,:)=[0.3 0.7];
A(5,:)=[0.4 0.1];
A(6,:)=[1.0 0.4];
%delta    = 1/(gridSize-1);
%coords   = 0:delta:1;
%xMatrix  = ones(gridSize,1)*coords; %Coordinates for all the devices in x coordinate
%yMatrix  = xMatrix'; %Coordinates for all the devices in y in y coordinate
%The first element of xMatrix and the first element of the yMatrix
%constitutes a point of the grid (i.e. P(xMatrix,yMatrix))
%plot(xMatrix,yMatrix, 'ro')
 line([A(1,1) A(2,1)],[A(1,2) A(2,2)],'Color','b','LineStyle','-');
 line([A(2,1) A(3,1)],[A(2,2) A(3,2)],'Color','b','LineStyle','-');
 line([A(3,1) A(1,1)],[A(3,2) A(1,2)],'Color','b','LineStyle','-');
 line([A(4,1) A(5,1)],[A(4,2) A(5,2)],'Color','b','LineStyle','-');
 line([A(5,1) A(6,1)],[A(5,2) A(6,2)],'Color','b','LineStyle','-');
 line([A(6,1) A(4,1)],[A(6,2) A(4,2)],'Color','b','LineStyle','-');
 %This procedure defines the grid limits for the triangle
 %for a=1:3
 %       if (A(1,1)<A(2,1))& (A(1,1)<A(3,1))
 %           xmenor=A(1,1);
 %       elseif (A(2,1)<A(1,1))& (A(2,1)<A(3,1))
 %           xmenor=A(2,1);
 %       elseif (A(3,1)<A(1,1))& (A(3,1)<A(2,1))
 %           xmenor=A(3,1);
 %       end
 %       if (A(1,2)<A(2,2))& (A(1,2)<A(3,2))
 %           ymenor=A(1,2);
 %       elseif (A(2,2)<A(1,2))& (A(2,2)<A(3,2))
 %           ymenor=A(2,2);
 %       elseif (A(3,2)<A(1,2))& (A(3,2)<A(2,2))
 %           ymenor=A(3,2);
 %       end
 %        if (A(1,1)>A(2,1))& (A(1,1)>A(3,1))
 %           xmayor=A(1,1);
 %       elseif (A(2,1)>A(1,1))& (A(2,1)>A(3,1))
 %           xmayor=A(2,1);
 %       elseif (A(3,1)>A(1,1))& (A(3,1)>A(2,1))
 %           xmayor=A(3,1);
 %        end
 %        if (A(1,2)>A(2,2))& (A(1,2)>A(3,2))
 %           ymayor=A(1,2);
 %       elseif (A(2,2)>A(1,2))& (A(2,2)>A(3,2))
 %           ymayor=A(2,2);
 %       elseif (A(3,2)>A(1,2))& (A(3,2)>A(2,2))
 %           ymayor=A(3,2);
 %       end
 %end
 cont=1;
 %We take reference points 
 for i=1:6
    Refpoint(i,:)=[A(i,1) A(i,2) 0];
 end
 
 %Refpoint1=[A(1,1) A(1,2) 0];
 %B=[A(2,1) A(2,2) 0];
 %C=[A(3,1) A(3,2) 0];
 
 for r=0:0.1:1
     for s=0:0.1:1
         %Matrix H contains the coordinates for each of the corners of the
         %squares of the grid
         H(cont,:)=[r s 0];
         cont=cont+1;
     end
 end
 
 %Test to know if each point of matrix H is outside or inside of the triangle
 lim_inf=1;
 lim_sup=3;
 i=1;
 [m n]=size(H);
 cont2=1;
 %j refers to the number of triangles
 for j=1:2
     for cont=1:m
         M=cross(H(cont,:)-Refpoint(i,:),Refpoint(i+1,:)-Refpoint(i,:));
         N=cross(H(cont,:)-Refpoint(i+1,:),Refpoint(i+2,:)-Refpoint(i+1,:));
         O=cross(H(cont,:)-Refpoint(i+2,:),Refpoint(i,:)-Refpoint(i+2,:));
         %M=cross(H(i,:)-Refpoint,B-Refpoint);
         %N=cross(H(i,:)-B,C-B);
         %O=cross(H(i,:)-C,Refpoint-C);
         if ((M(1,3)>0)&(N(1,3)>0)&(O(1,3)>0)) | ((M(1,3)<0)&(N(1,3)<0)&(O(1,3)<0))
             %Format of the Insidethetriangle [coordinates of the corner
             %#oftriangle inside/outside counterofoverlapping] 
             Insidethetriangle(cont2,:)=[H(cont,:) j  1 0];
         else
             Insidethetriangle(cont2,:)=[H(cont,:) j  0 0];
         end
         cont2=cont2+1;
     end
     i=i+3; %Because of the number of anchors or vertices of the triangle
 end
 hold on;
 [m n]=size(Insidethetriangle);
 temp=1;
 for a=(m/2)+1:m
     %Just to check if the corners of the squares of the grids belong to
     %a specific triangle
     if Insidethetriangle(a,5)==1
          plot(H(temp,1),H(temp,2),'ro');
     else
          plot(H(temp,1),H(temp,2),'go');  
     end
     temp=temp+1;    
 end
% counteroverlapping=0;
% [p q]=size(H)
 %Search in the vector Insidethetriangle
% for b=1:p
     %If the coordinates of the grid are found in Insidethetriangle and
     %matrix H
%    for a=1:m
%        if(Insidethetriangle(a,1:3)==H(a,:)) 
%            if Insidethetriangle(a,5)==1
%                counterincrease=counterincrease+1;
%                j=Insidethetriangle(a,4);
%                Insidethetriangle(cont2,:)=[H(a,:) j  1 counteroverlapping]; 
%            elseif Insidethetriangle(a,5)==0
%                counterdecrease=counteroverlapping-1;
%                j=Insidethetriangle(a,4);
%                Insidethetriangle(cont2,:)=[H(a,:) j  1 counteroverlapping]; 
%            end
%        end
%    end
%    counterincrease=0
%    counterin
% end
     
 
 set(gca,'xlim',[0 1])
 set(gca,'ylim',[0 1])
 set(gca,'xTick',0:0.1:1)
 set(gca,'yTick',0:0.1:1)
 grid;
 
