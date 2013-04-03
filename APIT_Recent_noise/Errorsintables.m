function [ErrorAPITt ErrorRFt ERRORINSIDEANGLE ERROROUTSIDEANGLE PercErrorAPIT PercErrorRF]=Errorsintables(InOut_realinside, InOut_realoutside, TableNodesInside, TableNodesOutside, TableNodesInsideSurf, TableNodesOutsideSurf)

%Counters
ErrorAPITi=0; %Number of no-errors for inside cases 
ErrorRFi=0;
ErrorAPITo=0; %Number of no-errors for outside cases 
ErrorRFo=0;

if(isempty(InOut_realinside)==0)
    [sizerealinside y]=size(InOut_realinside);
end
if(isempty(TableNodesInside)==0)
    [sizeTNInside y]=size(TableNodesInside);
end
if(isempty(TableNodesInsideSurf)==0)
    [sizeTNSurfInside y]=size(TableNodesInsideSurf);
end

%%%%%%%%%%%%%%%%%%%INSIDE
if(isempty(TableNodesInside)==0 & isempty(InOut_realinside)==0)
%Both tables exist, therefore:
total_comparisonsAPIT=sizerealinside+sizeTNInside;
    for i=1:sizerealinside
        Encontrado=find(TableNodesInside(:,1)==InOut_realinside(i,1) & TableNodesInside(:,2)==InOut_realinside(i,2) & TableNodesInside(:,3)==InOut_realinside(i,3) & TableNodesInside(:,4)==InOut_realinside(i,4));
        if(isempty(Encontrado)==1)
            ErrorAPITi=ErrorAPITi+1;
        end
    end
    for i=1:sizeTNInside
        Encontrado=find(InOut_realinside(:,1)==TableNodesInside(i,1) & InOut_realinside(:,2)==TableNodesInside(i,2) & InOut_realinside(:,3)==TableNodesInside(i,3) & InOut_realinside(:,4)==TableNodesInside(i,4));
        if(isempty(Encontrado)==1)
            ErrorAPITi=ErrorAPITi+1;
        end
    end
elseif(isempty(TableNodesInside)==1 & isempty(InOut_realinside)==0)
    [ErrorAPITi y]=size(InOut_realinside);
    total_comparisonsAPIT=ErrorAPITi;
elseif(isempty(TableNodesInside)==0 & isempty(InOut_realinside)==1)
     ErrorAPITi=sizeTNInside;
     total_comparisonsAPIT=ErrorAPITi;
elseif(isempty(TableNodesInside)==1 & isempty(InOut_realinside)==1)
     ErrorAPITi=0;
     total_comparisonsAPIT=ErrorAPITi;
end

if(isempty(TableNodesInsideSurf)==0 & isempty(InOut_realinside)==0)
%Both tables exist, therefore:
total_comparisonsRF=sizerealinside+sizeTNSurfInside;
    for i=1:sizerealinside
        Encontrado=find(TableNodesInsideSurf(:,1)==InOut_realinside(i,1) & TableNodesInsideSurf(:,2)==InOut_realinside(i,2) & TableNodesInsideSurf(:,3)==InOut_realinside(i,3) & TableNodesInsideSurf(:,4)==InOut_realinside(i,4));
        if(isempty(Encontrado)==1)
            ErrorRFi=ErrorRFi+1;
        end
    end
    for i=1:sizeTNSurfInside
        Encontrado=find(InOut_realinside(:,1)==TableNodesInsideSurf(i,1) & InOut_realinside(:,2)==TableNodesInsideSurf(i,2) & InOut_realinside(:,3)==TableNodesInsideSurf(i,3) & InOut_realinside(:,4)==TableNodesInsideSurf(i,4));
        if(isempty(Encontrado)==1)
            ErrorRFi=ErrorRFi+1;
        end
    end
elseif(isempty(TableNodesInsideSurf)==1 & isempty(InOut_realinside)==0)
    [ErrorRFi y]=size(InOut_realinside);
    total_comparisonsRF=ErrorRFi;
elseif(isempty(TableNodesInsideSurf)==0 & isempty(InOut_realinside)==1)
    ErrorRFi=sizeTNSurfInside;
    total_comparisonsRF=ErrorRFi;
elseif(isempty(TableNodesInsideSurf)==1 & isempty(InOut_realinside)==1)
    ErrorRFi=0;
    total_comparisonsRF=ErrorRFi;
end

ERRORINSIDEANGLE=ErrorRFi/total_comparisonsRF;
%%%%%%%%%%%%%%%%%%%%%OUTSIDE
if(isempty(InOut_realoutside)==0)
    [sizerealoutside y]=size(InOut_realoutside);
end
if(isempty(TableNodesOutside)==0)
    [sizeTNOutside y]=size(TableNodesOutside);
end
if(isempty(TableNodesOutsideSurf)==0)
    [sizeTNSurfOutside y]=size(TableNodesOutsideSurf);
end
if(isempty(TableNodesOutside)==0 & isempty(InOut_realoutside)==0)
    total_comparisonsAPIT=total_comparisonsAPIT+sizerealoutside+sizeTNOutside
    for i=1:sizerealoutside
        Encontrado=find(TableNodesOutside(:,1)==InOut_realoutside(i,1) & TableNodesOutside(:,2)==InOut_realoutside(i,2) & TableNodesOutside(:,3)==InOut_realoutside(i,3) & TableNodesOutside(:,4)==InOut_realoutside(i,4));
        if(isempty(Encontrado)==1)
            ErrorAPITo=ErrorAPITo+1;
        end
    end
    for i=1:sizeTNOutside
        Encontrado=find(InOut_realoutside(:,1)==TableNodesOutside(i,1) & InOut_realoutside(:,2)==TableNodesOutside(i,2) & InOut_realoutside(:,3)==TableNodesOutside(i,3) & InOut_realoutside(:,4)==TableNodesOutside(i,4));
        if(isempty(Encontrado)==1)
            ErrorAPITo=ErrorAPITo+1;
        end
    end 
elseif(isempty(TableNodesOutside)==1 & isempty(InOut_realoutside)==0)
    [ErrorAPITo y]=size(InOut_realoutside);
    total_comparisonsAPIT=total_comparisonsAPIT+ErrorAPITo;
elseif(isempty(TableNodesOutside)==0 & isempty(InOut_realoutside)==1)
     ErrorAPITo=sizeTNOutside;
     total_comparisonsAPIT=total_comparisonsAPIT+ErrorAPITo;
elseif(isempty(TableNodesOutside)==1 & isempty(InOut_realoutside)==1)
     ErrorAPITo=0;
     total_comparisonsAPIT=total_comparisonsAPIT+ErrorAPITo;
end

if(isempty(TableNodesOutsideSurf)==0 & isempty(InOut_realoutside)==0)
    total_comparisonsRF=total_comparisonsRF+sizerealoutside+sizeTNSurfOutside;
    total_RFo=sizerealoutside+sizeTNSurfOutside;
    for i=1:sizerealoutside
        Encontrado=find(TableNodesOutsideSurf(:,1)==InOut_realoutside(i,1) & TableNodesOutsideSurf(:,2)==InOut_realoutside(i,2) & TableNodesOutsideSurf(:,3)==InOut_realoutside(i,3) & TableNodesOutsideSurf(:,4)==InOut_realoutside(i,4));
        if(isempty(Encontrado)==1)
            ErrorRFo=ErrorRFo+1;
        end
    end
    for i=1:sizeTNSurfOutside
        Encontrado=find(InOut_realoutside(:,1)==TableNodesOutsideSurf(i,1) & InOut_realoutside(:,2)==TableNodesOutsideSurf(i,2) & InOut_realoutside(:,3)==TableNodesOutsideSurf(i,3) & InOut_realoutside(:,4)==TableNodesOutsideSurf(i,4));
        if(isempty(Encontrado)==1)
            ErrorRFo=ErrorRFo+1;
        end
    end      
elseif(isempty(TableNodesOutsideSurf)==1 & isempty(InOut_realoutside)==0)
    [ErrorRFo y]=size(InOut_realoutside);
    total_comparisonsRF=total_comparisonsRF+ErrorRFo;
    total_RFo=ErrorRFo;
elseif(isempty(TableNodesOutsideSurf)==0 & isempty(InOut_realoutside)==1)
    ErrorRFo=sizeTNSurfOutside;
    total_comparisonsRF=total_comparisonsRF+ErrorRFo;
    total_RFo=ErrorRFo;
elseif(isempty(TableNodesOutsideSurf)==1 & isempty(InOut_realoutside)==1)
    ErrorRFo=0;
    total_comparisonsRF=total_comparisonsRF+ErrorRFo;
    total_RFo=ErrorRFo;
end
ERROROUTSIDEANGLE=ErrorRFo/total_RFo;
ErrorAPITt=ErrorAPITi+ErrorAPITo;
PercErrorAPIT=ErrorAPITt/total_comparisonsAPIT;
ErrorRFt=ErrorRFi+ErrorRFo;
PercErrorRF=ErrorRFt/total_comparisonsRF;
