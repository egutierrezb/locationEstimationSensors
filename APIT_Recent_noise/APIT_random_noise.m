function [Error_total, Error, Error_2, Error_mult, size_EstimatedCoordinates_row, size_EstimatedCoordinatesr_row, size_Estimatedmult_row, AH, ND]=APIT_random_noise %Invoke function just for compilation if
% needed
tic
%Deploy xx nodes with the same configuration that Neal Patwari made his
%experiments.
%Declare global variables in order to manipulate the code faster
global M N Res DOIv
%Define number of blindfolded devices
M=100;
%Define number of referene devices
N=40;
%Define resolution of the grid
Res=0.5;
%Index for DOI in the RIM Model (noise)
DOIv=0.1;

[X, Indices, Radio_approx]=deploy_nodes_random_def();
%load Topology.mat Indices M N Res X
%Compute TrueDist and matrix for the Grid
[TrueDist, H]=matrixDist_and_Grid(X);
%Characterization of the medium (Use of the RIM model)
[Pij, RSS_noise, dth_RSS_Neighborhood]=empmodel_DOI(X, TrueDist);
%Define connectivity and neighbors between nodes in the graph
[AH, ND, Neighborhood,Audibleanchors]=connectivity_DOI(X, Indices, RSS_noise, dth_RSS_Neighborhood);
%Function for drawing triangles
[TableNodesOutside, TableNodesInside, Endprogram]=drawtriangles_noise_def(X,Audibleanchors,RSS_noise,Neighborhood,Indices);
%Function which computes the triangles and decide if a node is inside of a
%triangle computing the density of RSS.
%[TableNodesOutside, TableNodesInside, Estimatedcoord_density, InOut_realinside, InOut_realoutside, Endprogram]=APITtest_surface(X,Audibleanchors,RSS_noise,Neighborhood,Indices,H,dth_RSS_Neighborhood);
%Function to make the aggregation
if(Endprogram==0)
    [Target_GridMaxArea, Endprogram]=APITAggregation_noise_def(X,TableNodesOutside, TableNodesInside, Indices, H);
    %Function to compute the COG for each node with the maximum overlapping
    %area
    if(Endprogram==0)
            Estimatedcoordinates=COG(Target_GridMaxArea, Indices, 0);
            [size_EstimatedCoordinates_row size_EstimatedCoordinates_column]=size(Estimatedcoordinates);
            %Function to draw lines between the true and the estimated position
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
    else %means that we did not compute TargetGridMaxArea because probably, we dont have a matrix of points inside due to the resolution.
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
toc