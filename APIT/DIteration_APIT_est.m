%Assign which nodes we have to compute their position (XRemainingNodes) and which ones are
%going to work as anchors (NewAnchors)
global M N Res 
%Define number of blindfolded devices
M=20;
%Define number of referene devices
N=10; %AP=15%
%Define resolution of the grid
Res=0.5; %0.1Dist_Neighborhood
OldAnchors=Indices;
[NewAnchors]=assign_nodes_2c(Estimatedcoordinates);
[Neighborhood_Remaining,Audibleanchors_Remaining]=connectivity_ANR(X, NewAnchors, TrueDist);
[InsideorOutside_Remaining, TableNodesOutside_Remaining, TableNodesInside_Remaining, TableNodesOutsidetempo_Remaining, Nodesnoposition_end]=drawtriangles_fst_2c(X,Audibleanchors_Remaining,Pij, Neighborhood_Remaining,NewAnchors,OldAnchors);
[Insidethetriangleo_Remaining, Insidethetrianglei_Remaining, Target_GridMaxArea_Remaining, Suma_total_d_Remaining, Suma_total_Remaining, Positiveareas_Remaining, Negativeareas_Remaining]=APITAggregation_fst2_2c(X,TableNodesOutside_Remaining, TableNodesInside_Remaining, NewAnchors, H, OldAnchors);
Estimatedcoordinates_Remaining=COG_2c(Target_GridMaxArea_Remaining, NewAnchors, OldAnchors);
XRemainingNodes=drawlinesrealestpos_2c(Estimatedcoordinates_Remaining,X);
Error_2=RMSE(XRemainingNodes,Estimatedcoordinates_Remaining);
