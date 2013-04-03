function [Percentage_correct_decisions]=correctdecisions(TableNodesInside, TableNodesOutside)
for i=1:(M+N) %M+N
    %Check out progress of the simulation w/ the number of Target node
    %Only consider target nodes, not anchors  (if 1= mean that it is not an
    %anchor node, it is a target node), and it should check that the target
    %node is a node considered in the Neighborhood, in order to avoid
    %problems with bounds of Index
    if (isempty(find(Indices==i))==1)  & (isempty(find(Neighborhood(:,1)==i))==0) 
        Anchorstriangle=[];
        fprintf(1,'--Making RSS comparisons for Target Node %d\n',i);
        for j=1:m        
            if i==Audibleanchors(j,1) %Format of audibleanchors: audibleanchors(targetnode,anchor) we want the first column
                Anchorscounter=Anchorscounter+1;
                Anchorstriangle(temp)=Audibleanchors(j,2); %We want the anchor
                temp=temp+1;
            end
        end
        %To fix the size of the anchorstriangle array and prevent bugs
        limit_anchors=temp-1;
        temp=1;
        if Anchorscounter>=3
            %If number of anchors>=3 then we should form a triangle between the
            %anchors
            CombinationTriangles=[];
            CombinationTriangles=nchoosek(Anchorstriangle(1:limit_anchors),3); %Combinations=nchoosek(n,k)
            [u v]=size(CombinationTriangles);
            for SetofAnchors=1:u %size of CombinationTriangles
                %Draw triangle among the anchors
            %    line([X(CombinationTriangles(SetofAnchors,1),1) X(CombinationTriangles(SetofAnchors,2),1)],[X(CombinationTriangles(SetofAnchors,1),2) X(CombinationTriangles(SetofAnchors,2),2)],'Color','b','LineStyle','-');
            %    line([X(CombinationTriangles(SetofAnchors,2),1) X(CombinationTriangles(SetofAnchors,3),1)],[X(CombinationTriangles(SetofAnchors,2),2) X(CombinationTriangles(SetofAnchors,3),2)],'Color','b','LineStyle','-');
            %    line([X(CombinationTriangles(SetofAnchors,3),1) X(CombinationTriangles(SetofAnchors,1),1)],[X(CombinationTriangles(SetofAnchors,3),2) X(CombinationTriangles(SetofAnchors,1),2)],'Color','b','LineStyle','-');
                %Is TargetNode inside or outside for the setofanchors?
                Mt=cross(X2(i,:)-X2(CombinationTriangles(SetofAnchors,1),:),X2(CombinationTriangles(SetofAnchors,2),:)-X2(CombinationTriangles(SetofAnchors,1),:)); %H-A,B-A 
                Nt=cross(X2(i,:)-X2(CombinationTriangles(SetofAnchors,2),:),X2(CombinationTriangles(SetofAnchors,3),:)-X2(CombinationTriangles(SetofAnchors,2),:)); % H-B,C-B
                Ot=cross(X2(i,:)-X2(CombinationTriangles(SetofAnchors,3),:),X2(CombinationTriangles(SetofAnchors,1),:)-X2(CombinationTriangles(SetofAnchors,3),:)); % H-C,A-C
                if ((Mt(1,3)>0)&(Nt(1,3)>0)&(Ot(1,3)>0)) | ((Mt(1,3)<0)&(Nt(1,3)<0)&(Ot(1,3)<0))
                          % Means that target node is effectively inside of
                          % the triangle
                         InOut_real(count,:)=[i CombinationTriangles(SetofAnchors,1) CombinationTriangles(SetofAnchors,2) CombinationTriangles(SetofAnchors,3) 1];
                         InOut_realinside(count4,:)=[i CombinationTriangles(SetofAnchors,1) CombinationTriangles(SetofAnchors,2) CombinationTriangles(SetofAnchors,3)];
                         count4=count4+1;
                         
                else
                        %Means that target node is effectively outside of the
                        %triangle
                        InOut_real(count,:)=[i CombinationTriangles(SetofAnchors,1) CombinationTriangles(SetofAnchors,2) CombinationTriangles(SetofAnchors,3) 0];
                        InOut_realoutside(count5,:)=[i CombinationTriangles(SetofAnchors,1) CombinationTriangles(SetofAnchors,2) CombinationTriangles(SetofAnchors,3)];
                        count5=count5+1;
                end
                %New theorem: if RSSxy>RSSxi then target node is outside of triangle.
                %We have to check if the anchors are in the communication
                %range, if all are in the communication range, then proceed
                %with the comparisons of RSSs.
                Connected_1=0;
                Connected_2=0;
                Connected_3=0;
                    if ((X(CombinationTriangles(SetofAnchors,1),1)-X(CombinationTriangles(SetofAnchors,2),1)).^2+(X(CombinationTriangles(SetofAnchors,1),2)-X(CombinationTriangles(SetofAnchors,2),2)).^2)<=Dist_Anchor
                       %If it is found in the list of audibleanchors then 1
                       Connected_1=1;
                    end
                    if ((X(CombinationTriangles(SetofAnchors,2),1)-X(CombinationTriangles(SetofAnchors,3),1)).^2+(X(CombinationTriangles(SetofAnchors,2),2)-X(CombinationTriangles(SetofAnchors,3),2)).^2)<=Dist_Anchor
                       %If it is found in the list of audibleanchors then 2
                       %and 3 are connected
                       Connected_2=1;
                    end
                    if ((X(CombinationTriangles(SetofAnchors,3),1)-X(CombinationTriangles(SetofAnchors,1),1)).^2+(X(CombinationTriangles(SetofAnchors,3),2)-X(CombinationTriangles(SetofAnchors,1),2)).^2)<=Dist_Anchor
                       %If it is found in the list of audibleanchors then 1
                       %and 3 are connected
                       Connected_3=1;
                    end
                
                 %If the three Connected_x are not empty means that the
                 %anchors are in communication and can proceed with
                 %interchanging RSS values
                 %x(RSS_A1 > RSS_T1)  & (xRSS_A2 > RSS_T1) & x(RSS_A1 > RSS_T3) & x(RSS_A3 > RSS_T3) & x(RSS_A2 > RSS_T2) & (xRSS_A3 > RSS_T2)
                if ((Connected_1==1) & (Connected_2==1) & (Connected_3==1))       
                if (Pij(CombinationTriangles(SetofAnchors,1),CombinationTriangles(SetofAnchors,2))<Pij(CombinationTriangles(SetofAnchors,1),i)) & (Pij(CombinationTriangles(SetofAnchors,1),CombinationTriangles(SetofAnchors,3))<Pij(CombinationTriangles(SetofAnchors,1),i)) & (Pij(CombinationTriangles(SetofAnchors,1),CombinationTriangles(SetofAnchors,2))<Pij(CombinationTriangles(SetofAnchors,2),i)) & (Pij(CombinationTriangles(SetofAnchors,3),CombinationTriangles(SetofAnchors,1))<Pij(CombinationTriangles(SetofAnchors,3),i)) & (Pij(CombinationTriangles(SetofAnchors,2),CombinationTriangles(SetofAnchors,3))<Pij(CombinationTriangles(SetofAnchors,2),i)) & (Pij(CombinationTriangles(SetofAnchors,2),CombinationTriangles(SetofAnchors,3))<Pij(CombinationTriangles(SetofAnchors,3),i))  
                        InOut_test(count,:)=[i CombinationTriangles(SetofAnchors,1) CombinationTriangles(SetofAnchors,2) CombinationTriangles(SetofAnchors,3) 1];
                        InOut_testinside(count2,:)=[i CombinationTriangles(SetofAnchors,1) CombinationTriangles(SetofAnchors,2) CombinationTriangles(SetofAnchors,3)];             
                        count2=count2+1;
                        Acombinationinside=1;
                    else 
                        %Means that node possibly is outside of the triangle
                        InOut_test(count,:)=[i CombinationTriangles(SetofAnchors,1) CombinationTriangles(SetofAnchors,2) CombinationTriangles(SetofAnchors,3) 0];
                        InOut_testoutside(count3,:)=[i CombinationTriangles(SetofAnchors,1) CombinationTriangles(SetofAnchors,2) CombinationTriangles(SetofAnchors,3)]; 
                        count3=count3+1;
                    end
                    count=count+1;
                end
                         
            end
        end
    end 
    Anchorscounter=0;
    if Acombinationinside==1
        Nodeswecanestimate(aux,:)=i;
        aux=aux+1;
        Acombinationinside=0;
    end
end