function [Error_total, Error, Error_2, Error_mult, size_EstimatedCoordinates_row, size_EstimatedCoordinatesr_row, size_Estimatedmult_row, AH, ND]=APIT_randomnonoise_repexp %Invoke function just for compilation if
% needed
tic
%Declare global variables in order to manipulate the code faster
global M N Res 
%Define number of blindfolded devices
%600 trials according to paper, we limited to 10, when we invoke
%Iterative_APIT_Aggregation
M=40; %100
%Define number of referene devices
N=20;
%Define resolution of the grid
Res=0.5; %0.1Dist_Neighborhood %0.17

[X, Indices, Radio_approx]=deploy_nodes_random_def();
%Radio_approx=4.57 %dth_RSS_Neighborhood
%load Topology.mat Indices M N Res X
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
   
    %Process of multilateration (if we want APIT+refinement+APIT) and
    %change of lines 99 and 112 by Estimatedcoordinates_mult
    
  %  Estimatedcoordinates_mult=multilateration(Estimatedcoordinates, Audibleanchors, dMLE, TrueDist, 0, BiasFactor, X);
  %  [size_Estimatedmult_row size_Estimatedmult_col]=size(Estimatedcoordinates_mult);
  %  hold on;
  %  plot(Estimatedcoordinates_mult(:,2),Estimatedcoordinates_mult(:,3),'d','MarkerEdgeColor','k','MarkerFaceColor','y');
  %  labels = num2str(Estimatedcoordinates_mult(:,1));
   % For labelling each sensor
  %  text(Estimatedcoordinates_mult(:,2)+.06,Estimatedcoordinates_mult(:,3),labels,'Color','k');
  %  Error_mult=RMSE(Xnodes, Estimatedcoordinates_mult);
  %  fprintf(1,'--RMSE_mult: %f.\n',Error_mult);
else
    Error_total=0;
    Error=0;
    Error_2=0;
    Error_mult=0;
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
%    [NewAnchors]=assign_nodes(Estimatedcoordinates_mult, Indices); %changed by Estimatedcoordinates
%    [AH_Remaining, ND_Remaining, Neighborhood_Remaining,Audibleanchors_Remaining, Dist_Anchor]=connectivity_ANR(X, NewAnchors, TrueDist, Radio_approx);
%    [InsideorOutside_Remaining, TableNodesOutside_Remaining, TableNodesInside_Remaining, TableNodesOutsidetempo_Remaining, Nodesnoposition_end, Endprogram]=drawtriangles_fst_prueba(X,Audibleanchors_Remaining,Pij, Neighborhood_Remaining,NewAnchors);
%    [TableNodesInside_Remaining TableNodesOutside_Remaining InOut_testinside_Remaining InOut_testoutside_Remaining  InOut_test_Remaining InOut_realinside_Remaining InOut_realoutside_Remaining InOut_real_Remaining Nodeswecanestimate_Remaining Endprogram]=RSScomparison_prueba(X, NewAnchors, Audibleanchors_Remaining,Neighborhood_Remaining, Pij, Dist_Anchor);
%    if(Endprogram==0)
%        [Insidethetriangleo_Remaining, Insidethetrianglei_Remaining, Target_GridMaxArea_Remaining, Suma_total_d_Remaining, Suma_total_Remaining, Positiveareas_Remaining, Negativeareas_Remaining]=APITAggregation_fst2(X,TableNodesOutside_Remaining, TableNodesInside_Remaining, NewAnchors, H);
%        Estimatedcoordinates_Remaining=COG(Target_GridMaxArea_Remaining, NewAnchors, 1);
%        [size_EstimatedCoordinatesr_row size_EstimatedCoordinatesr_column]=size(Estimatedcoordinates_Remaining);
%        Xw3col=drawlinesrealestpos(Estimatedcoordinates_Remaining,X);
     
%        Computes error only for the new nodes estimated.
%        Error_2=RMSE(Xw3col,Estimatedcoordinates_Remaining);
%        fprintf(1,'--RMSE_rem: %f.\n',Error_2);

%        First concatenates all estimated positions, from the 2nd run and 1st run
%        Estimatedcoordinates_all=[Estimatedcoordinates_mult; Estimatedcoordinates_Remaining]; %changed by Estimatedcoordinates
%        Computes the total error {estimated + new estimated} nodes
%        Error_total=RMSE(Xw3col,Estimatedcoordinates_all);
%        fprintf(1,'--RMSE_total: %f.\n',Error_total);
       
%        Process of multilateration (APIT 1 + APIT 2 + Refinement) and
%        change lines 99 and 112 by Estimatedcoordinates
%        Estimated_all_withanchors=[Estimatedcoordinates_all;[Indices X(Indices,1) X(Indices,2)]];
%        Estimatedcoordinates_mult=multilateration(Estimatedcoordinates_all, Audibleanchors, dMLE, TrueDist, 0, BiasFactor, X);
%        Estimatedcoordinates_mult=multilateration_modified(Estimated_all_withanchors, Audibleanchors, dMLE, TrueDist, 0, BiasFactor, Indices, X); %OK Working with Audibleanchors,changed by Audibleanchors_Remaining, because we have to consider those anchors of estimated nodes for the multilateration process
%        hold on;
%        plot(Estimatedcoordinates_mult(:,2),Estimatedcoordinates_mult(:,3),'d','MarkerEdgeColor','k','MarkerFaceColor','y');
%        [size_Estimatedmult_row size_Estimatedmult_col]=size(Estimatedcoordinates_mult);
%        labels = num2str(Estimatedcoordinates_mult(:,1));
%        For labelling each sensor
%        text(Estimatedcoordinates_mult(:,2)+.06,Estimatedcoordinates_mult(:,3),labels,'Color','k');
%        Error_mult=RMSE(Xnodes, Estimatedcoordinates_mult);
%        fprintf(1,'--RMSE_mult: %f.\n',Error_mult);
%        toc
%    else
%        Error_2=0;
%        size_EstimatedCoordinatesr_row=0;
%        size_Estimatedmult_row=0;
%        Error_total=Error_mult; %changed by Error
%   end
 toc