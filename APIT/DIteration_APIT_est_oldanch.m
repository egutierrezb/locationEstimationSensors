%Assign which nodes we have to compute their position (XRemainingNodes) and which ones are
%going to work as anchors (NewAnchors)
%Matrix H should exist and all the remaining variables
%For this: we should have a Workspace already loaded with the first
%iteration already run.
global M N Res 
%Define number of blindfolded devices
M=20;
%Define number of referene devices
N=10; %AP=15%
%Define resolution of the grid
Res=0.5; %0.1Dist_Neighborhood
[NewAnchors]=assign_nodes(Estimatedcoordinates, Indices);
[Neighborhood_Remaining,Audibleanchors_Remaining]=connectivity_ANR(X, NewAnchors, TrueDist);
[InsideorOutside_Remaining, TableNodesOutside_Remaining, TableNodesInside_Remaining, TableNodesOutsidetempo_Remaining, Nodesnoposition_end]=drawtriangles_fst(X,Audibleanchors_Remaining,Pij, Neighborhood_Remaining,NewAnchors);
[Insidethetriangleo_Remaining, Insidethetrianglei_Remaining, Target_GridMaxArea_Remaining, Suma_total_d_Remaining, Suma_total_Remaining, Positiveareas_Remaining, Negativeareas_Remaining]=APITAggregation_fst2(X,TableNodesOutside_Remaining, TableNodesInside_Remaining, NewAnchors, H);
Estimatedcoordinates_Remaining=COG(Target_GridMaxArea_Remaining, NewAnchors);
XRemainingNodes=drawlinesrealestpos(Estimatedcoordinates_Remaining,X);
Error_2=RMSE(XRemainingNodes,Estimatedcoordinates_Remaining);
