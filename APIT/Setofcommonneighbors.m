count=1;
[an bn]=size(Anchorstriangle);

for u=1:bn 
	Anchornotshared=0;
	for i=1:(M+N)
		Neighbor=[];
		Anchorbusqueda=[];
		Neighbor=find(Neighborhood_shared(:,1)==i)
		if(isempty(Neighbor)==0)
            [mn nn]=size(Neighbor);
            Anchorbusqueda=find(Neighborhood_shared(Neighbor(1,1):Neighbor(mn,1),2)==Anchorstriangle(u));
            if(isempty(Anchorbusqueda)==1) %if it is empty
                Anchornotshared=1;
                 %because the anchor is not shared, break the for and we can go with the next anchortriangle without supervising the remaining blocks of neighbors and anchors
            end
        end
	end
	if Anchornotshared==0 %means that the anchortriangle was found in all the blocks of the neighbor
		Definiteanchors(count)=Anchorstriangle(u);
		count=count+1;
	end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CODE TO BE CHANGED------->
%            [mn nn]=size(Neighborhood_shared);
%            count=1;
%            count2=1;
%            for jj=1:(M+N)
%                Number=[];
%                Number=find(Neighborhood_shared(:,1)==jj); %Search in the neighbors column
%                [mr nr]=size(Number);
%                if(isempty(Number)==0)
%                    DefiniteNeighbors(count2)=jj;
%                    count2=count2+1;
%                end
%                if(mr==tempmin) %Here we use tempmin
%                    for kk=1:mr
%                       DefiniteAnchors_rep(count)=Neighborhood_shared(Number(kk),2); %Search in the anchors column
%                       count=count+1;
%                    end    
%                end
%            end
            %DefiniteAnchors_rep is going to have repetitive elements, so we
            %have to eliminate them and then form the DefiniteAnchors
%            if(isempty(DefiniteAnchors_rep)==0)
%                [mtemp ntemp]=size(DefiniteAnchors_rep);
%                count=1;
%                for ll=1:ntemp
%                    Repetition=[];
%                    Repetition=find(DefiniteAnchors_rep==DefiniteAnchors_rep(ll));
%                    [mrep nrep]=size(Repetition);
%                    if nrep>=2 %It means that two elements are repited at least
%                        for mm=2:nrep
%                            DefiniteAnchors_rep(Repetition(mm))=0;
%                        end
%                    end
%                end
%                count=1;
%                for ll=1:ntemp
%                    if(DefiniteAnchors_rep(ll)~=0)
%                        DefiniteAnchors(count)=DefiniteAnchors_rep(ll);
%                        count=count+1;
%                    end
%                end
%            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         