%Deploy 44 nodes with the same configuration that Neal Patwari made his
%experiments.
X=deploy_nodes();
%Define connectivity and neighbors between nodes in the graph
[TrueDist,Neighborhood,Audibleanchors]=connectivity(X);
%Characterization of the medium
Pij=empmodel(TrueDist,Neighborhood);
%Function for drawing triangles
InsideorOutside=drawtriangles(X,Audibleanchors,Pij,Neighborhood);
