tic
%Declare global variables in order to manipulate the code faster
global M N Res 
%Define number of blindfolded devices
M=30;
%Define number of referene devices
N=15;
%Define resolution of the grid
Res=0.5; %0.1Dist_Neighborhood
%[X, Indices]=deploy_nodes_random();
%Compute TrueDist and matrix for the Grid
%[TrueDist, H]=matrixDist_and_Grid(X);
%Define connectivity and neighbors between nodes in the graph
%[AH, ND, Neighborhood,Audibleanchors]=connectivity_ANR(X,Indices,TrueDist);
%Characterization of the medium
%Pij=empmodel(TrueDist);
%Function for drawing triangles
[InsideorOutside, TableNodesOutside, TableNodesInside, TableNodesOutsidetempo, Nodeswecannotestimate]=drawtriangles_fst(X,Audibleanchors,Pij,Neighborhood,Indices);
