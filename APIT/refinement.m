function [TableNodesInside_ref TableNodesOutside_ref]=refinement(InOut_test,X, Nodeswecanestimate, Estimatedcoordinates)

global M N
%InOut_test=InOut_test[i SetofAnchors from 1 to 3]
%Estimatedcoordinates=Estimatedcoordinates[i X(:,1) X(:,2)]
count=1;
count2=1;

X2=X;
[r s]=size(X);
X2(:,3)=zeros(r,1);

for i=1:(M+N)
    if(isempty(find(InOut_test(:,1)==i))==0) & (isempty(find(Nodeswecanestimate(:,1)==i))==0)
        Match=find(InOut_test(:,1)==i);
        Xest=find(Estimatedcoordinates(:,1)==i);
        [a b]=size(Match);
        for j=1:a
            Mt=cross([Estimatedcoordinates(Xest,2) Estimatedcoordinates(Xest,3) 0]-X2(InOut_test(Match(j,1),2),:),X2(InOut_test(Match(j,1),3),:)-X2(InOut_test(Match(j,1),2),:)); %H-A,B-A 
            Nt=cross([Estimatedcoordinates(Xest,2) Estimatedcoordinates(Xest,3) 0]-X2(InOut_test(Match(j,1),3),:),X2(InOut_test(Match(j,1),4),:)-X2(InOut_test(Match(j,1),3),:)); % H-B,C-B
            Ot=cross([Estimatedcoordinates(Xest,2) Estimatedcoordinates(Xest,3) 0]-X2(InOut_test(Match(j,1),4),:),X2(InOut_test(Match(j,1),2),:)-X2(InOut_test(Match(j,1),4),:)); % H-C,A-C
            if ((Mt(1,3)>0)&(Nt(1,3)>0)&(Ot(1,3)>0)) | ((Mt(1,3)<0)&(Nt(1,3)<0)&(Ot(1,3)<0))
                      % Means that target node is effectively inside of
                      % the triangle
                      TableNodesInside_ref(count,:)=[i InOut_test(Match(j,1),2) InOut_test(Match(j,1),3) InOut_test(Match(j,1),4)];
                      count=count+1;
            else
                    TableNodesOutside_ref(count2,:)=[i InOut_test(Match(j,1),2) InOut_test(Match(j,1),3) InOut_test(Match(j,1),4)];
                    count2=count2+1;
            end
        end
        Match=[];
    end
      
end