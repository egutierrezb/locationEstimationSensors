function [Pij, dMLE, BiasFactor]=empmodel(TrueDist,Noise)

%empmodel computes the power levels for each pair-wise interdistance
%Input parameters working: TrueDist-> pair-wise interdistances for all the
%nodes
%Output parameters: Pij-> power levels for each pair-wise interdistances

%Parameters of the medium
%Deviation standard of the medium (in the caise of noise)
dev_standard=3.92; %[dB] %3.92

%Propagation exponent
np=2.3;

%Reference distance
di=1; %[m]

%Reference power at do
P0=-37.466; %[dBm]

%Compute the matrix of the mean power for every pair [i,j] of nodes. 
Pij=P0-(10*np*log10(TrueDist.*(1/di)));
[m n]=size(Pij);
if(Noise==1)
    Unit_GaussianRandom=dev_standard*randn(m,n);
else
    Unit_GaussianRandom=zeros(m,n);
end
%RSS measurements with noise/ without noise
Pij=Pij+Unit_GaussianRandom;

%Distances computes from RSS, if noise is null therefore, the distances
%matches with true distances
dMLE=di*(10.^((P0-Pij)./(10*np)));
[m n]=size(dMLE);
for i=1:m
    for j=1:n
        dMLE(i,i)=0;
    end
end

%We compute this values in order to use them for computing the variances of the distances. These variances are used for
%the least squares when the weight matrix is introduced . This Bias Factor
%is implemented as Neal Patwari refers to its paper
Gamma=(10*np/(dev_standard*log(10)))^2;
BiasFactor=exp(1/(2*Gamma));

%Just to define that for distances < do, the Pij should be the one of P0
[m n]=size(TrueDist);
for i=1:m
    for j=1:m
        if TrueDist(i,j)<=di %if the distance / two sensors is equal or less that 1 m
            Pij(i,j)=P0; %in order to not get power levels that do not agree with the model since it is valid just for P where d>=1m
        end
    end
end


