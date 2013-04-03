function [isinsidereal]=checkrealinsideoroutside(X2,CombinationTriangles,i)

Mt=cross(X2(i,:)-X2(CombinationTriangles(1,1),:),X2(CombinationTriangles(1,2),:)-X2(CombinationTriangles(1,1),:)); %Point-A,B-A 
Nt=cross(X2(i,:)-X2(CombinationTriangles(1,2),:),X2(CombinationTriangles(1,3),:)-X2(CombinationTriangles(1,2),:)); %Point-B,C-B
Ot=cross(X2(i,:)-X2(CombinationTriangles(1,3),:),X2(CombinationTriangles(1,1),:)-X2(CombinationTriangles(1,3),:)); %Point-C,A-C
if ((Mt(1,3)>0)&(Nt(1,3)>0)&(Ot(1,3)>0)) | ((Mt(1,3)<0)&(Nt(1,3)<0)&(Ot(1,3)<0))
          % Means that target node is effectively inside of
          % the triangle
          isinsidereal=1;
                         
else
           %Means that target node is effectively outside of the
           %triangle
           isinsidereal=0;
           
end