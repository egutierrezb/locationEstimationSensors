%This program makes several iteration in the APIT_random_nonoise
%so we can have the results of the error estimations in an array
%for the first and second estimates,
%For each iteration we obtain
%Error_total= RMSE for all the estimated nodes
%Error=RMSE for the first set of estimated nodes
%Error_2=RMSE for the second set of estimated nodes
%size_Estimated1=Number of nodes estimated in the first round
%size_Estimated2=Number of nodes estimated in the second round

function [ErrorAPITt ErrorRFt PercErrorAPIT PercErrorRF avgAPIT avgRF]=Iterative_TableComparisonsRFAPIT

%Problems with sub at time of running at sharcnet
%num_iterations=input('Number of iterations');

num_iterations=10;

ErrorAPITt=[];
ErrorRFt=[];
PercErrorAPIT=[];
PercErrorRF=[];

for a=1:num_iterations
      [ErrorAPITt(a) ErrorRFt(a) PercErrorAPIT(a) PercErrorRF(a)]=TablecomparisonRFAPIT;
end

ErrorAPITt=ErrorAPITt';
ErrorRFt=ErrorRFt';
PercErrorAPIT=PercErrorAPIT';
PercErrorRF=PercErrorRF';
avgAPIT=mean(PercErrorAPIT);
avgRF=mean(PercErrorRF);