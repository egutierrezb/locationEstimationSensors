%This program makes several iteration in the APIT_random_nonoise
%so we can have the results of the error estimations in an array
%for the first and second estimates,
%For each iteration we obtain
%Error_total= RMSE for all the estimated nodes
%Error=RMSE for the first set of estimated nodes
%Error_2=RMSE for the second set of estimated nodes
%size_Estimated1=Number of nodes estimated in the first round
%size_Estimated2=Number of nodes estimated in the second round

function [Error_total, Error, Error_2, Error_mult, size_Estimated1, size_Estimated2, size_Estimatedmult, AH, ND]=Iterative_APIT_random_nonoise

%Problems with sub at time of running at sharcnet
%num_iterations=input('Number of iterations');

num_iterations=10;

%if (isdeployed) %isdeployed to check if the script is run as a standalone application.
%	num_iterations = str2num(num_iterations);
%    if (num_iterations==1)
%        Results_file = fopen('Results_RMSE.txt','w'); 
%    end
%end

Error_total=[];
Error=[];
Error_2=[];
Error_mult=[];
size_Estimated1=[];
size_Estimated2=[];
size_Estimatedmult=[];
AH=[];
ND=[];

for a=1:num_iterations
     [Error_total(a), Error(a), Error_2(a),  Error_mult(a), size_Estimated1(a), size_Estimated2(a), size_Estimatedmult(a), AH(a), ND(a)]=APIT_randomnonoise_repexp;
 %    if(isdeployed)
 %        if (a==num_iterations)
 %              fclose(Results_file);
 %        end
 %    end
end

Error_total=Error_total';
Error=Error';
Error_2=Error_2';
Error_mult=Error_mult';
size_Estimated1=size_Estimated1';
size_Estimated2=size_Estimated2';
size_Estimatedmult=size_Estimatedmult';
AH=AH';
ND=ND';

%if(isdeployed)
%     fprintf(Results_file,'%f\n',Error_total);
%end
