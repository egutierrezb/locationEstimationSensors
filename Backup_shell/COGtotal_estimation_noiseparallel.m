iter=input('Number of iteration ','s');
%Load the topology of the network
load("-text", "GeneralTopology.mat", "M", "N", "Res", "X", "Audibleanchors", "Pij", "Neighborhood", "Indices" ,"H");
load("-text", "Statistics1.mat","Estimatedcoordinates");
%Load the TargetGridMaxArea so it can be manipulated
load ("-text", "TARGETGRIDMAXAREA.mat", "TARGETMAXAREA_TOTAL");
Target_GridMaxArea=TARGETMAXAREA_TOTAL;
Estimatedcoordinates2=COG(Target_GridMaxArea, Indices, 0);
Estimatedcoordinates_tot=[Estimatedcoordinates;Estimatedcoordinates2];
[size_EstimatedCoordinates_row size_EstimatedCoordinates_column]=size(Estimatedcoordinates2);
%Function to draw lines between the true and the estimated position
%Xnodes=drawlinesrealestpos(Estimatedcoordinates,X);
nodes=1:1:(M+N);
X(:,3)=nodes';
%Xnodes has the following format Xnodes=[Num_node Xpos Ypos] 
Xnodes(:,1)=X(:,3);
Xnodes(:,2)=X(:,1);
Xnodes(:,3)=X(:,2); 
%Function to compute the RMSE for estimated positions
Error_total=RMSE(Xnodes,Estimatedcoordinates_tot);
Error_2=RMSE(Xnodes,Estimatedcoordinates2);
fprintf(1,'--RMSE_tot: %f.\n',Error_total);
fprintf(1,'--RMSE_2: %f.\n',Error_2);
%In case of one APIT iteration (computation of one set of estimated
%nodes)
size_EstimatedCoordinatesr_row=0;
size_Estimatedmult_row=0;
Error_mult=0;
%Save the statistics (RMSE and number of estimated nodes) in Statistics.mat
letter1i='Statistics'
letter2i='.mat'
Statistics_name=strcat(letter1i,iter,letter2i); %It concatenates: Tinside(Name_file).mat
save("-text",Statistics_name,"Estimatedcoordinates_tot","Estimatedcoordinates2","Error_2","Error_total","size_EstimatedCoordinates_row");
