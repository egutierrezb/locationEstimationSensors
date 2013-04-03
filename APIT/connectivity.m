function [TrueDist,Neighborhood,Audibleanchors]=connectivity(X,Indices)
%Compute True distance 
TrueDist=pdist(X);
TrueDist=squareform(TrueDist);

%Based in the experiments of Whitehouse we define a threshold of 4.57m
threshold=4.52;
aux=1;
aux2=1;
for x=1:45 %M+N
    for y=1:45 %M+N
       if (TrueDist(x,y)<threshold) & (TrueDist(x,y)~=0)
            Node1=x; 
            Node2=y; %si encontro un anchor node (if 0)    %Node1 no debe estar entre los anchors (tons la matriz debe estar vacia (if 1)                                                                                      %Node2 == Number of Anchor Anchor
            if ((isempty(find(Indices==Node2))==0) & (isempty(find(Indices==Node1))==1))                          %Node2 == 1 | Node2 == 11 | Node2 == 4 | Node2 == 15 | Node2==14 | Node2==28 | Node2 == 9 | Node2 == 7 | Node2 == 20 | Node2 == 30 | Node2 == 26 | Node2 == 29
                fprintf(1,'--Target node %d has Anchor %d as an audible one.\n',Node1,Node2);
                %Audibleanchors has the following format:
                %Target node -- Audible anchor
                %In order to form a triangle then:
                %[1 a]
                %[1 b]
                %[1 c]
                Audibleanchors(aux,:)=[Node1 Node2];
                aux=aux+1;
            end
            %Neighborhood has the following format: 
            %Target node -- Neighbor within a radius of 4.57
            %e.g. 1-4
            %     1-11
            %     1-23
            %     1-33
            %     2-3
            %     2-7
            %     2-39
            
            Neighborhood(aux2,:)=[Node1 Node2];
            % Draw a line between two nodes if they are connected (i.e.
            % interdistance is less than the value of the threshold).
            % line([X(Node1,1) X(Node2,1)],[X(Node1,2) X(Node2,2)],'Color','g','LineStyle','--');
            aux2=aux2+1;
       end
    end
end