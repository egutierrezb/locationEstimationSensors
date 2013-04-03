function [NewAnchors]=assign_nodes_2c(Estimatedcoordinates)
%Indices (2nd argument of NewAnchors)
%If we just consider the Estimatedcoordinates as anchors we have the
%problem that we may build tables for Indices... we can ignore them in the
%best of the cases.
NewAnchors=[Estimatedcoordinates(:,1)];
%XRemainingNodes=[X(Nodeswecannotestimate(:),1) X(Nodeswecannotestimate(:),2); Estimatedcoordinates(:,2) Estimatedcoordinates(:,3)];