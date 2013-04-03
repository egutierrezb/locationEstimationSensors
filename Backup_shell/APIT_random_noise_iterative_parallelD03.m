function [Error_total, Error, Error_2, Error_mult, size_EstimatedCoordinates_row, size_EstimatedCoordinatesr_row, size_Estimatedmult_row, AH, ND]=APIT_random_noise_iterative_parallelD03(n)
% needed
tic
%Deploy xx nodes with the same configuration that Neal Patwari made his
%experiments.
%Declare global variables in order to manipulate the code faster
global M N Res DOIv
%Define number of blindfolded devices
M=30;
%Define number of referene devices
N=n;
%Define resolution of the grid
Res=0.5;
%Index for DOI in the RIM Model (noise)
DOIv=0.3;

[X, Indices, Radio_approx]=deploy_nodes_random_def();
%Compute TrueDist and matrix for the Grid
[TrueDist, H]=matrixDist_and_GridOctave(X);
%Characterization of the medium (Use of the RIM model)
[Pij, RSS_noise, dth_RSS_Neighborhood]=empmodel_DOI(X, TrueDist);
%Define connectivity and neighbors between nodes in the graph
[AH, ND, Neighborhood,Audibleanchors]=connectivity_DOI(X, Indices, RSS_noise, dth_RSS_Neighborhood);
%Function for drawing triangles
[TableNodesOutside, TableNodesInside, Endprogram]=drawtriangles_noise_def(X,Audibleanchors,RSS_noise,Neighborhood,Indices);
%Function which computes the triangles and decide if a node is inside of a
%triangle computing the density of RSS. [Function in test]
%[TableNodesOutside, TableNodesInside, Endprogram]=APITtest_surface(X,Audibleanchors,RSS_noise,Neighborhood,Indices,H);
%Function to make the aggregation
if(Endprogram==0)
    [Target_GridMaxArea]=APITAggregation_noise_def(X,TableNodesOutside, TableNodesInside, Indices, H);
    %Function to compute the COG for each node with the maximum overlapping
    %area
    Estimatedcoordinates=COG(Target_GridMaxArea, Indices, 0);
    [size_EstimatedCoordinates_row size_EstimatedCoordinates_column]=size(Estimatedcoordinates);
    nodes=1:1:(M+N);
    X(:,3)=nodes';
    Xnodes(:,1)=X(:,3);
    Xnodes(:,2)=X(:,1);
    Xnodes(:,3)=X(:,2);
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
    [AH_Remaining, ND_Remaining, Neighborhood_Remaining,Audibleanchors_Remaining]=connectivity_DOI(X, NewAnchors, RSS_noise, dth_RSS_Neighborhood);
    [TableNodesOutside_Remaining, TableNodesInside_Remaining, Endprogram]=drawtriangles_noise_def(X,Audibleanchors_Remaining,RSS_noise, Neighborhood_Remaining,NewAnchors);
    if(Endprogram==0)
        [Target_GridMaxArea_Remaining]=APITAggregation_noise_def(X,TableNodesOutside_Remaining, TableNodesInside_Remaining, NewAnchors, H);
        Estimatedcoordinates_Remaining=COG(Target_GridMaxArea_Remaining, NewAnchors, 1);
        [size_EstimatedCoordinatesr_row size_EstimatedCoordinatesr_column]=size(Estimatedcoordinates_Remaining);
        nodes=1:1:(M+N);
	X(:,3)=nodes';
	Xw3col(:,1)=X(:,3);
	Xw3col(:,2)=X(:,1);
	Xw3col(:,3)=X(:,2);
	     
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
        Error_total=Error; %changed by Error_mult
        toc
    end
    toc 
