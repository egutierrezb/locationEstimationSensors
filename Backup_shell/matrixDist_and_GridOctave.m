function [TrueDist, H]=matrixDist_and_GridOctave(X)

global Res
%Compute True distance 
%We use pdist2 and squareform2 for Octave compatibility and we 
%use pdist and squareform for Matlab compatibility
TrueDist=pdist2(X);
TrueDist=squareform2(TrueDist);
cont=1;
for r=0:Res:10 %10R
    for s=0:Res:10
        %Matrix H contains the coordinates for each of the corners of the
        %squares of the grid
        H(cont,:)=[r s 0];
        cont=cont+1;
    end
end