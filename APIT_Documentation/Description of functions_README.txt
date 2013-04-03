DOI=0 (i.e. NO NOISE)

FUNCTION APIT_RANDOM_NONOISE

%Calls the functions (1st run):
deploy_nodes_random (used for noise and nonoise)
matrixDist_and_Grid
connectivity_ANR
empmodel
drawtriangles_fst
APITAggregation_fst2
COG
drawlinesrealestpos
RMSE

%Calls functions (2nd run)

1. Using {estimated positions + old anchors}-> new anchors
-OR-
2. Using {estimated positions}-> new anchors


FUNCTION DEPLOY_NODES_RANDOM

%deploy_nodes_random computes the positions of random nodes knowing
%the number of anchors and blindfolded devices
%Output parameters: X-> positions of the nodes
%Indices-> nodes (e.g. 1, 3, 5, 7) which are anchors

FUNCTION EMPMODEL

%empmodel computes the power levels for each pair-wise interdistance
%Input parameters working: TrueDist-> pair-wise interdistances for all the
%nodes
%Output parameters: Pij-> power levels for each pair-wise interdistances


FUNCTION CONNECTIVITY_ANR

%connectivity_ANR the Audibleanchors and Neighborhood for each TargetNode
%It receives the parameters: X the array with the positions of the nodes
%and Indices - the Nodes (e.g. 1, 5, 9,..) that act as anchors.

FUNCTION DRAWTRIANGLES_FST

%drawtriangles_fst computes the tables of RSS for each targetNode and its
%Neighborhood. Computes which nodes are inside/outside for each combination of
%the anchors taking into account "determined nodes" (i.e. nodes that have 3
%audible anchors and at least fall in one triangle). Output variables of
%interest: TableNodesInside and TableNodesOutside.
%Input parameters: X-> array with the positions of the nodes
%Audibleanchors-> array with the list of audible anchors for each target
%node
%Neighborhood-> array with the list of neighbors for each target node
%Pij-> array with the power values for each pair-wise interdistance
%Indices-> nodes (e.g. 1, 3 5, 7) which are the anchors. 

FUNCTION APITAGGREGATION_FST2

%APITAggregation_fst2 computes the overlapping of positive and negative
%areas and then it obtains the maximum value with the node and the point of
%the grid.
%Input parameteres: X-> the positions of the nodes
%TableNodesInside-> Nodes which fall inside w/ a combination of a triangle
%TableNodesOutside->Nodes which fall outside w/ a combination of a triangle
%Indices->Nodes (e.g. 1, 4, 8) which are anchors
%Output parameters of interest: Target_GridMaxArea which has the node and
%the grid point with the maximum value.

FUNCTION COG

%COG computes the center of gravity for each area with the maximum value 
%Output Estimatedcoordinates-> Estimated positions for all the
%nodes
%Input parameteres: Indices: Nodes (e.g. 1, 2, 4,...) which are anchors.

FUNCTION DRAWLINESREALESTPOS

%drawlinesrealestpos is a function which draws lines between the estimated
%positions of the nodes and the true positions of the nodes
%Input coordinates: Estimatedcoordinates-> Estimated positions of the nodes
%X-> True positions of the nodes
%Xnodes-> True positions of the nodes (reallocation the columns)


FUNCTION RMSE

%RMSE computes the error from the estimated coordinates 
%and the true positions of the nodes
%Input parameters: Xnodes-> True positions of the nodes (node positionx
%positiony), Estimatedcoordinates-> Estimated position of the nodes (node
%positionx positiony).
%Output parameters: Error

M FILE DITERATION_APIT_NEWANCH-EST_OLDANCH

%M File which uses old anchors and the estimated nodes as anchors
%Assign which nodes we have to compute their position (XRemainingNodes) and which ones are
%going to work as anchors (NewAnchors)
%Matrix H should exist and all the remaining variables
%For this: we should have a Workspace already loaded with the first
%iteration already run.


M FILE DITERATION_APIT_NEWANCH-EST

%M Files which uses estimated nodes as anchors only
%Assign which nodes we have to compute their position (XRemainingNodes) and which ones are
%going to work as anchors (NewAnchors)
%Matrix H should exist and all the remaining variables
%For this: we should have a Workspace already loaded with the first
%iteration already run.
-Modules:
We include OldAnchors as input-parameter in the following modules 

assign_nodes_2c
drawtriangles_fst_2c 
APITAggregation_fst2_2c
drawlinesrealestpos_2c

STANDALONE APP. ~EXE FILE 
We have to compile the file in the Current Directory and under Matlab 

mcc -mv [file 1... file n] (m extensions)

NO_NOISE CASE:

mcc -mv APIT_random_nonoise.m deploy_nodes_random.m connectivity_ANR.m empmodel.m drawtriangles_fst.m APITAggregation_fst2.m COG.m drawlinesrealestpos.m RMSE.m

It is going to generate a name_mcr directory
and the following files
name.exe
name.ctf
name_mcc_component_data.c
name_main.c

Now we can execute the .exe file !
________________________________________________________________________________________________________________________________

Note drawlinesrealestpos do not plot the lines / estimated and true positions (we should uncomment this for APIT_Random_nonoise)
Note APITAggregation_fst2 do not plot the grid ( we should uncomment this for APIT_random_nonoise)
Note COG do not plot the estimated positions (we should uncomment this for APIT_random_nonoise)