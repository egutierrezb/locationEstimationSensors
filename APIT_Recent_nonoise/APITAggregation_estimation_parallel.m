%Load matrices which consider the General Topology of the network
load("-text", "GeneralTopology.mat", "M", "N", "Res", "X", "Audibleanchors", "Pij", "Neighborhood", "Indices","H");
%Load matrices previous saved in the method of concatenation
load ("-text", "TINSIDE.mat", "TINSIDE");
load ("-text", "TOUTSIDE.mat", "TOUTSIDE");
%Rename the matrices so they can be used in APITAggregation_fst_def and
%further
TableNodesInside=TINSIDE;
TableNodesOutside=TOUTSIDE;
%Run the rest of the program
[Target_GridMaxArea]=APITAggregation_fst_def(X,TableNodesOutside, TableNodesInside, Indices,H);
%Function to compute the COG for each node with the maximum overlapping
%area
Estimatedcoordinates=COG(Target_GridMaxArea, Indices, 0);
[size_EstimatedCoordinates_row size_EstimatedCoordinates_column]=size(Estimatedcoordinates);
%Function to draw lines between the true and the estimated positions
Xnodes=drawlinesrealestpos(Estimatedcoordinates,X);
%Function to compute the RMSE for estimated positions
Error=RMSE(Xnodes,Estimatedcoordinates);
fprintf(1,'--RMSE_est: %f.\n',Error);
%In case of one APIT iteration (computation of one set of estimated
%nodes)
Error_total=Error;
Error_2=0;
size_EstimatedCoordinatesr_row=0;
size_Estimatedmult_row=0;
Error_mult=0;
%Save the statistics (RMSE and number of estimated nodes) in Statistics.mat
save("-text", "Statistics.mat","Error_total","size_EstimatedCoordinates_row");
   