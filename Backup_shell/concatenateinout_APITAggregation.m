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
    Name_file=strcat('TargetGridMaxArea',number,'.mat');
    res=fopen(Name_file,'r');
    if res~=-1 %means that it could open the file
        Succopenedinside=[Succopenedinside;i];
        fclose(res);
        countinside=countinside+1; %helps to count the number of files opened
    end
end

%Mother matrix which will contain the concatenations
TARGETMAXAREA_TOTAL=[];

for i=1:countinside
    number=num2str(Succopenedinside(i));
    Name_file=strcat('TargetGridMaxArea',number,'.mat');
    load("-text",Name_file,"Target_GridMaxArea");
    TARGETMAXAREA_TOTAL=[TARGETMAXAREA_TOTAL;Target_GridMaxArea];
end

%Save matrices TINSIDE and TOUTSIDE for being processed by APIT_Aggregation
save ("-text", "TARGETGRIDMAXAREA.mat", "TARGETMAXAREA_TOTAL");
