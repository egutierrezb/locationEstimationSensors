%Load and save are in format of Octave, not recognized by Matlab

%For loading M and N
load("-text", "GeneralTopology.mat", "M", "N");

%M=100;
%N=13;

%Variables to know the number of the files that could be successfully
%opened
Succopenedinside=[];
Succopenedoutside=[];
%Loading matrices which were saved for drawtriangles_parallel
%For tables inside

countinside=0;
for i=1:M+N
    number=num2str(i);
    Name_file=strcat('Tinside',number,'.mat');
    res=fopen(Name_file,'r');
    if res~=-1 %means that it could open the file
        Succopenedinside=[Succopenedinside;i];
        fclose(res);
        countinside=countinside+1; %helps to count the number of files opened
    end
end

%Mother matrix which will contain the concatenations
TOUTSIDE=[];
TINSIDE=[];

for i=1:countinside
    number=num2str(Succopenedinside(i));
    Name_file=strcat('Tinside',number,'.mat');
    Name_matrix=strcat('TableNodesInside',number);
    load("-text",Name_file,"TableNodesInside");
    TINSIDE=[TINSIDE;TableNodesInside];
end

%For tables outside
countoutside=0;
for i=1:M+N
    number=num2str(i);
    Name_file=strcat('Toutside',number,'.mat');
    res=fopen(Name_file,'r');
    if res~=-1
        Succopenedoutside=[Succopenedoutside;i];
        fclose(res);
        countoutside=countoutside+1;
    end
end

for i=1:countoutside
    number=num2str(Succopenedoutside(i));
    Name_file=strcat('Toutside',number,'.mat');
    Name_matrix=strcat('TableNodesOutside',number);
    load("-text",Name_file,"TableNodesOutside");
    TOUTSIDE=[TOUTSIDE;TableNodesOutside]
end

%Save matrices TINSIDE and TOUTSIDE for being processed by APIT_Aggregation
save ("-text", "TINSIDE.mat", "TINSIDE");
save ("-text", "TOUTSIDE.mat", "TOUTSIDE");