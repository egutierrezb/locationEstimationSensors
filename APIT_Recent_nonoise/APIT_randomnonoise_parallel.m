tic
%Declare global variables in order to manipulate the code faster
global M N Res 
%Define number of blindfolded devices
%600 trials according to paper, we limited to 10, when we invoke
%Iterative_APIT_Aggregation
M=100; %100
%Define number of referene devices
N=13;
%Define resolution of the grid
Res=0.17; %0.1Dist_Neighborhood %0.17
[X, Indices, Radio_approx]=deploy_nodes_random_def();
%Compute TrueDist and matrix for the Grid
[TrueDist, H]=matrixDist_and_GridOctave(X);
%Define connectivity and neighbors between nodes in the graph
[AH, ND, Neighborhood,Audibleanchors, Dist_Anchor]=connectivity_ANR(X,Indices,TrueDist,Radio_approx);
%Characterization of the medium
[Pij, dMLE, BiasFactor]=empmodel(TrueDist,0);
%Save matrices for the GeneralTopology
save ("-text", "GeneralTopology.mat", "M", "N", "Res", "X", "Audibleanchors", "Pij", "Neighborhood", "Indices","H");
