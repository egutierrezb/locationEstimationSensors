iter=input('Number of iteration ','s');
%Load the topology of the network
load("-text", "GeneralTopology.mat", "M", "N", "Res", "X", "Audibleanchors", "Pij", "Neighborhood", "Indices" ,"H");
%Load the TargetGridMaxArea so it can be manipulated
load ("-text", "TARGETGRIDMAXAREA.mat", "TARGETMAXAREA_TOTAL");
Target_GridMaxArea=TARGETMAXAREA_TOTAL;
Estimatedcoordinates=COG(Target_GridMaxArea, Indices, 0);
[size_EstimatedCoordinates_row size_EstimatedCoordinates_column]=size(Estimatedcoordinates);
%Function to draw lines between the true and the estimated positions
%Xnodes=drawlinesrealestpos(Estimatedcoordinates,X);
nodes=1:1:(M+N);
X(:,3)=nodes';
%Xnodes has the following format Xnodes=[Num_node Xpos Ypos] 
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
%Save the statistics (RMSE and number of estimated nodes) in Statistics.mat
letter1i='Statistics'
letter2i='.mat'
Statistics_name=strcat(letter1i,iter,letter2i); %It concatenates: Tinside(Name_file).mat
save("-text",Statistics_name,"Error_total","size_EstimatedCoordinates_row");
   