function [TrueDist, H]=matrixDist_and_Grid(X)

global Res
%Compute True distance 
TrueDist=pdist(X);
TrueDist=squareform(TrueDist);
cont=1;
for r=0:Res:10 %10R
    for s=0:Res:10
        %Matrix H contains the coordinates for each of the corners of the
        %squares of the grid
        H(cont,:)=[r s 0];
        cont=cont+1;
    end
end