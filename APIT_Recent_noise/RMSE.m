function Error=RMSE(Xnodes,Estimatedcoordinates)
%RMSE computes the error from the estimated coordinates 
%and the true positions of the nodes
%Input parameters: Xnodes-> True positions of the nodes (node positionx
%positiony), Estimatedcoordinates-> Estimated position of the nodes (node
%positionx positiony).
%Output parameters: Error

global M N
Suma=0;
[m n]=size(Estimatedcoordinates);
for i=1:(M+N)
    Match_e=find(Estimatedcoordinates(:,1)==i); %The node is in Estimatedcoordinates matrix
    Match_x=find(Xnodes(:,1)==i); %The node is in Xnodes 
    if (isempty(Match_e)==0 & isempty(Match_x)==0) %Both values have to exist in both matrices
        Suma=Suma+((Estimatedcoordinates(Match_e,2)-Xnodes(Match_x,2))^2)+((Estimatedcoordinates(Match_e,3)-Xnodes(Match_x,3))^2);
    end
end
Error=sqrt(Suma/m);
