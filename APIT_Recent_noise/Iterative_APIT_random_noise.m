%This program makes several iteration in the APIT_random_nonoise
%so we can have the results of the error estimations in an array
%for the first and second estimates,
%For each iteration we obtain
%Error_total= RMSE for all the estimated nodes
%Error=RMSE for the first set of estimated nodes
%Error_2=RMSE for the second set of estimated nodes
%size_Estimated1=Number of nodes estimated in the first round
%size_Estimated2=Number of nodes estimated in the second round

function [Error, Error_mult,size_Estimatedmult_row, size_EstimatedCoordinates_row, AH, ND]=Iterative_APIT_random_noise
%Problems with sub at time of running at sharcnet
%num_iterations=input('Number of iterations');

num_iterations=10;

%if (isdeployed) %isdeployed to check if the script is run as a standalone application.
%	num_iterations = str2num(num_iterations);
%    if (num_iterations==1)
%        Results_file = fopen('Results_RMSE.txt','w'); 
%    end
%end

Error=[];
Error_mult=[];
size_Estimatedmult_row=[];
size_EstimatedCoordinates_row=[];
AH=[];
ND=[];

for a=1:num_iterations
        [Error(a), Error_mult(a), size_EstimatedCoordinates_row(a), size_Estimatedmult_row(a), AH(a), ND(a)]=APIT_random_noise_mult;
    
 %    if(isdeployed)
 %        if (a==num_iterations)
 %              fclose(Results_file);
 %        end
 %    end
end

Error=Error';
Error_mult=Error_mult';
size_Estimatedmult_row=size_Estimatedmult_row';
size_EstimatedCoordinates_row=size_EstimatedCoordinates_row';
AH=AH';
ND=ND';

%if(isdeployed)
%     fprintf(Results_file,'%f\n',Error_total);
%end
