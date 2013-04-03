%Transition between simple APIT and Iterative APIT
%We have to assign the newanchors (New Indices) and obtain in base of this
%the New AudibleAnchors and New Neighborhood, 
load("-text", "GeneralTopology.mat", "M", "N", "Res", "X", "Audibleanchors", "Pij", "Neighborhood", "Indices" ,"H", "TrueDist");
%We have to obtain the estimated coordinates
load("-text","Statistics1.mat","Error_total","size_EstimatedCoordinates_row");
[NewAnchors]=assign_nodes(Estimatedcoordinates, Indices);
[AH_Remaining, ND_Remaining, Neighborhood_Remaining,Audibleanchors_Remaining, Dist_Anchor]=connectivity_ANR(X, NewAnchors, TrueDist, Radio_approx);
%Assign new values for which we are going to work: To be coherent with drawtriangles_parallel
Audibleanchors=Audibleanchors_Remaining;
Neighborhood=Neighborhood_Remaining;
Indices=NewAnchors;
save("-text", "GeneralTopology.mat","M","N","Res","X","Audibleanchors", "Pij", "Neighborhood", "Indices" ,"H", "TrueDist");