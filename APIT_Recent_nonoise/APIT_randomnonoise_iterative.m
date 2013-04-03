function [Error_total, Error, Error_2, Error_mult, size_EstimatedCoordinates_row, size_EstimatedCoordinatesr_row, size_Estimatedmult_row, AH, ND]=APIT_randomnonoise_repexp %Invoke function just for compilation if
% needed
tic
%Declare global variables in order to manipulate the code faster
global M N Res 
%Define number of blindfolded devices
%600 trials according to paper, we limited to 10, when we invoke
%Iterative_APIT_Aggregation
M=30; %100
%Define number of referene devices
N=20;
%Define resolution of the grid
Res=0.5; %0.1Dist_Neighborhood %0.17

[X, Indices, Radio_approx]=deploy_nodes_random_def();
Radio_approx=4.57 %equivalent to dth_RSS_Neighborhood in APIT_noise
%Compute TrueDist and matrix for the Grid
[TrueDist, H]=matrixDist_and_Grid(X);
%Define connectivity and neighbors between nodes in the graph
[AH, ND, Neighborhood,Audibleanchors, Dist_Anchor]=connectivity_ANR(X,Indices,TrueDist,Radio_approx);
%Characterization of the medium
[Pij, dMLE, BiasFactor]=empmodel(TrueDist,0);
%Function for drawing triangles
[TableNodesOutside, TableNodesInside, Endprogram]=drawtriangles_fst_def(X,Audibleanchors,Pij,Neighborhood,Indices);
%[TableNodesInside TableNodesOutside InOut_testinside InOut_testoutside  InOut_test InOut_realinside InOut_realoutside InOut_real Nodeswecanestimate Endprogram]=RSScomparison_prueba(X, Indices, Audibleanchors,Neighborhood, Pij, Dist_Anchor);
%Function to make the aggregation
if(Endprogram==0)
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
else
    Error_total=0;
    Error=0;
    Error_2=0;
    size_EstimatedCoordinates_row=0;
    size_EstimatedCoordinatesr_row=0;
    size_Estimatedmult_row=0;
    toc
    return;
end
    
    %------------------------Second set of Estimated Nodes (Iterative APIT)----
    %At the end of the algorithm we may have the Estimatedcoordinates of some
    %nodes and the True Positions of all nodes (blindfolded devices + anchors)
    %In the second stage, we may take the Estimatedcoordinates as anchors
    %(plus Indices) for the connectivity_ANR function.
    %We do not have to run the empmodel function again
    %We may run drawtriangles_fst with X and Indices as stated before.. we have
    %Audibleanchors and Neighborhood the outputs of connectivity_ANR. At the
    %end of the run of drawtriangles_fst we probably have Nodeswecannotestimate
    %again (make the algorithm recursive?). Run APITAggregation_fst2 with X and
    %Indices as stated before, COG the same and we obtain new
    %Estimatedcoordinates. These estimatedcoordinates should be compared with X
    %and we obtain Error for the second run of the algorithm
    %--------------------------------------------------------------------------
    
%    Assign which nodes are going to work as anchors (NewAnchors)
    [NewAnchors]=assign_nodes(Estimatedcoordinates, Indices); %changed by Estimatedcoordinates_mult
    [AH_Remaining, ND_Remaining, Neighborhood_Remaining,Audibleanchors_Remaining, Dist_Anchor]=connectivity_ANR(X, NewAnchors, TrueDist, Radio_approx);
    [InsideorOutside_Remaining, TableNodesOutside_Remaining, TableNodesInside_Remaining, TableNodesOutsidetempo_Remaining, Nodesnoposition_end, Endprogram]=drawtriangles_fst_def(X,Audibleanchors_Remaining,Pij, Neighborhood_Remaining,NewAnchors);
    if(Endprogram==0)
        [Target_GridMaxArea_Remaining]=APITAggregation_fst_def(X,TableNodesOutside_Remaining, TableNodesInside_Remaining, NewAnchors, H);
        Estimatedcoordinates_Remaining=COG(Target_GridMaxArea_Remaining, NewAnchors, 1);
        [size_EstimatedCoordinatesr_row size_EstimatedCoordinatesr_column]=size(Estimatedcoordinates_Remaining);
        Xw3col=drawlinesrealestpos(Estimatedcoordinates_Remaining,X);
     
%        Computes error only for the new nodes estimated.
        Error_2=RMSE(Xw3col,Estimatedcoordinates_Remaining);
        fprintf(1,'--RMSE_rem: %f.\n',Error_2);

%        First concatenates all estimated positions, from the 2nd run and 1st run
        Estimatedcoordinates_all=[Estimatedcoordinates; Estimatedcoordinates_Remaining]; %changed by Estimatedcoordinates
%        Computes the total error {estimated + new estimated} nodes
        Error_total=RMSE(Xw3col,Estimatedcoordinates_all);
        fprintf(1,'--RMSE_total: %f.\n',Error_total);

   else
        Error_2=0;
        size_EstimatedCoordinatesr_row=0;
        size_Estimatedmult_row=0;
        Error_total=Error;%changed by Error_mult
        toc
    end
    toc
 