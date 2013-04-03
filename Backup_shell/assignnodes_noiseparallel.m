%Transition between simple APIT and Iterative APIT
%We have to assign the newanchors (New Indices) and obtain in base of this
%the New AudibleAnchors and New Neighborhood, 
load("-text", "GeneralTopology.mat", "M", "N", "Res", "X", "Audibleanchors", "Pij", "Neighborhood", "Indices","H","RSS_noise","TrueDist","dth_RSS_Neighborhood");
%We have to obtain the estimated coordinates
load("-text","Statistics1.mat","Estimatedcoordinates","Error_total","size_EstimatedCoordinates_row");
[NewAnchors]=assign_nodes(Estimatedcoordinates, Indices);
[AH_Remaining, ND_Remaining, Neighborhood_Remaining,Audibleanchors_Remaining]=connectivity_DOI(X, NewAnchors, RSS_noise, dth_RSS_Neighborhood);
%Assign new values for which we are going to work: To be coherent with drawtriangles_parallel
Audibleanchors=Audibleanchors_Remaining;
Neighborhood=Neighborhood_Remaining;
Indices=NewAnchors;
save("-text", "GeneralTopology.mat","M", "N", "Res", "X", "Audibleanchors", "Pij", "Neighborhood", "Indices","H","RSS_noise","TrueDist","dth_RSS_Neighborhood");
