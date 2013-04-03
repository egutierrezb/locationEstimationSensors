function [TableNodesOutside, TableNodesInside, InOut_realinside, InOut_realoutside]=Testangles(X,Audibleanchors,RSS_noise,Neighborhood,Indices)

global M N DOIv
[m n]=size(Audibleanchors);
Anchorstriangle=zeros(1,3);
TableNodesInside=[];
TableNodesOutside=[];
CombinationTriangles=[];
InOut_realinside=[];
InOut_realoutside=[];
epsilon=200;

%Counters
Anchorscounter=0;
temp=1;
reali=1; %Used for real tables inside/outside
realo=1;
conti=1;
conto=1;


%X2 is going to have the same columns as X plus a third column of zeros in
%order to be feasible to operate w. cross
X2=X;
[Xsizex Xsizey]=size(X);
X2(:,3)=zeros(Xsizex,1);

beta=1.01*ones((M+N)*360,1); 
alfa=0.17*ones((M+N)*360,1); 
RANDt=rand((M+N)*360,1);
RAND=alfa.*((-log(1-RANDt)).^(1./beta));

Num_node=1;
%We are going to generate 360 values which belong to the different 360 i
%directions
%At the end of the for cycle we may have Kis for all the nodes of the
%network

%Generation of the Kis values according to formula (3) of the paper of RIM
%In this code we are missing to compute K values when i is not an integer.
K=zeros((M+N)*360,3); %M+N
%Format of K=K[Node K_Value Direction_in_degrees]
%Reference distance
do=0.1; %[m]
%Reference power at do
P0=-37.466; %[dBm]
%Propagation exponent
np=2.3;

for i=1:((M+N)*360)
    if i==1 | mod(i,360)==1
        if i==360 %This belongs truly to i=359 (since i begins at 1)
            K(i,:)=[Num_node K(i-1,2)+(RAND(i,1)*DOIv) Grades];
        end
        if i~=360
            Grades=0;
            if i~=1
                Num_node=Num_node+1; %Increase the num_node since we are in another cycle
            end
            K(i,:)=[Num_node 1 Grades]; %Ki=1, i=1 (truly this value belongs to i=0)
            Grades=Grades+1;
        end
    else
       if mod(i,2)~=0
            K(i,:)=[Num_node K(i-1,2)+(RAND(i,1)*DOIv) Grades]; %Ki, for i~=1
            Grades=Grades+1;
       else
            K(i,:)=[Num_node K(i-1,2)-(RAND(i,1)*DOIv) Grades]; %Ki, for i~=1
            Grades=Grades+1;
       end
    end
end

for i=1:(M+N) %M+N
    %Check out progress of the simulation w/ the number of Target node
    %Only consider target nodes, not anchors  (if 1= mean that it is not an
    %anchor node, it is a target node), and it should check that the target
    %node is a node considered in the Neighborhood, in order to avoid
    %problems with bounds of Index
    if (isempty(find(Indices==i))==1)  & (isempty(find(Neighborhood(:,1)==i))==0) 
        Anchorstriangle=[];
        fprintf(1,'--Deciding if Target Node [%d] is inside or outside in basis of angles \n',i);
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
                 %Check if it is Inside of a triangle or outside of a
                 %triangle in the real sense
                 [isinsidereal]=checkrealinsideoroutside(X2,CombinationTriangles(SetofAnchors,:),i);
                 if(isinsidereal==1)
                     %Means that it is inside
                     InOut_realinside(reali,:)=[i CombinationTriangles(SetofAnchors,1) CombinationTriangles(SetofAnchors,2) CombinationTriangles(SetofAnchors,3)];
                     reali=reali+1;
                 else
                     InOut_realoutside(realo,:)=[i CombinationTriangles(SetofAnchors,1) CombinationTriangles(SetofAnchors,2) CombinationTriangles(SetofAnchors,3)];
                     realo=realo+1;
                 end
                 Vx=complex(X(i,1),X(i,2));
                 %Vector for the anchor
                 V1=complex(X(CombinationTriangles(SetofAnchors,1),1),X(CombinationTriangles(SetofAnchors,1),2));
                 V2=complex(X(CombinationTriangles(SetofAnchors,2),1),X(CombinationTriangles(SetofAnchors,2),2));
                 V3=complex(X(CombinationTriangles(SetofAnchors,3),1),X(CombinationTriangles(SetofAnchors,3),2));
                 %Vector that points to the target node
                 V=Vx-V1;
                 RE=real(V);
                 IM=imag(V);
                if RE>0 & IM >0 %1Q
                   ANGLE1=angledim(angle(V),'radians','degrees');
                elseif RE<0 & IM>0 %2Q
                   ANGLE1=abs(angledim(angle(V),'radians','degrees'));
                elseif RE<0 & IM<0 %3Q
                   ANGLE1=360+angledim(angle(V),'radians','degrees');
                elseif RE>0 & IM<0 %4Q
                   ANGLE1=360-abs(angledim(angle(V),'radians','degrees'));
                end
                ANGLE1=round(ANGLE1);
                if ANGLE1==360
                      ANGLE1=0;
                end
                V=Vx-V2;
                RE=real(V);
                IM=imag(V);
                if RE>0 & IM >0 %1Q
                   ANGLE2=angledim(angle(V),'radians','degrees');
                elseif RE<0 & IM>0 %2Q
                   ANGLE2=abs(angledim(angle(V),'radians','degrees'));
                elseif RE<0 & IM<0 %3Q
                   ANGLE2=360+angledim(angle(V),'radians','degrees');
                elseif RE>0 & IM<0 %4Q
                   ANGLE2=360-abs(angledim(angle(V),'radians','degrees'));
                end
                ANGLE2=round(ANGLE2);
                if ANGLE2==360
                      ANGLE2=0;
                end
                V=Vx-V3;
                RE=real(V);
                IM=imag(V);
                if RE>0 & IM >0 %1Q
                   ANGLE3=angledim(angle(V),'radians','degrees');
                elseif RE<0 & IM>0 %2Q
                   ANGLE3=abs(angledim(angle(V),'radians','degrees'));
                elseif RE<0 & IM<0 %3Q
                   ANGLE3=360+angledim(angle(V),'radians','degrees');
                elseif RE>0 & IM<0 %4Q
                   ANGLE3=360-abs(angledim(angle(V),'radians','degrees'));
                end
                ANGLE3=round(ANGLE3);
                if ANGLE3==360
                      ANGLE3=0;
                end
                %Check if it is Inside of a triangle or outside of a
                %triangle in the real sense
                %Sacar coordenadas de los anchors
                %X(CombinationTriangles(SetofAnchors,1),:),X(CombinationTrian
                %gles(SetofAnchors,2),:),X(CombinationTriangles(SetofAnchors,
                %3),:)-> llamar distancias d1,d2,d3
                d1=pdist([X(CombinationTriangles(SetofAnchors,1),:); X(CombinationTriangles(SetofAnchors,2),:)]);
                d2=pdist([X(CombinationTriangles(SetofAnchors,2),:); X(CombinationTriangles(SetofAnchors,3),:)]);
                d3=pdist([X(CombinationTriangles(SetofAnchors,3),:); X(CombinationTriangles(SetofAnchors,1),:)]);
                %Area for the main triangle by Heron's formula
                S=0.25*sqrt(2*((d1^2*d2^2)+(d1^2*d3^2)+(d2^2*d3^2))-(d1^4+d2^4+d3^4));
                MatchSS1=find(RSS_noise(:,1)==CombinationTriangles(SetofAnchors,1) & RSS_noise(:,2)==i);
                MatchANG1=find(K(:,3)==ANGLE1 & K(:,1)==CombinationTriangles(SetofAnchors,1));
                MatchSS2=find(RSS_noise(:,1)==CombinationTriangles(SetofAnchors,2) & RSS_noise(:,2)==i);
                MatchANG2=find(K(:,3)==ANGLE2 & K(:,1)==CombinationTriangles(SetofAnchors,2));
                MatchSS3=find(RSS_noise(:,1)==CombinationTriangles(SetofAnchors,3) & RSS_noise(:,2)==i);
                MatchANG3=find(K(:,3)==ANGLE3 & K(:,1)==CombinationTriangles(SetofAnchors,3));
                r1=do*(10.^((P0-RSS_noise(MatchSS1,3))/(10.*np.*K(MatchANG1,2))));
                r2=do*(10.^((P0-RSS_noise(MatchSS2,3))/(10.*np.*K(MatchANG2,2))));
                r3=do*(10.^((P0-RSS_noise(MatchSS3,3))/(10.*np.*K(MatchANG3,2))));
                S1=0.25*sqrt(2*((d1^2*r1^2)+(d1^2*r2^2)+(r1^2*r2^2))-(d1^4+r1^4+r2^4));
                S2=0.25*sqrt(2*((d2^2*r2^2)+(d2^2*r3^2)+(r2^2*r3^2))-(d2^4+r2^4+r3^4));
                S3=0.25*sqrt(2*((d3^2*r1^2)+(d3^2*r3^2)+(r1^2*r3^2))-(d3^4+r1^4+r3^4));
                %Values between 0 and 180
                ANGLEint1_deg=acosd((r1^2+r2^2-d1^2)/(2*r1*r2));
                ANGLEint2_deg=acosd((r3^2+r1^2-d3^2)/(2*r3*r1));
                ANGLEint3_deg=acosd((r2^2+r3^2-d2^2)/(2*r2*r3));
                %VALUE=(cos(ANGLEint1)*cos(ANGLEint2)*cos(ANGLEint3))-(sin(ANGLEint1)*sin(ANGLEint2)*cos(ANGLEint3))-(sin(ANGLEint1)*cos(ANGLEint2)*sin(ANGLEint3))-(cos(ANGLEint1)*sin(ANGLEint2)*sin(ANGLEint3));
                %ANGLEint1_deg=angledim(ANGLEint1,'radians','degrees');
                %ANGLEint2_deg=angledim(ANGLEint2,'radians','degrees');
                %ANGLEint3_deg=angledim(ANGLEint3,'radians','degrees');
                if ((ANGLEint1_deg >180) | (ANGLEint2_deg >180) | (ANGLEint3_deg >180))
                    fprintf(1,'ERROR!!!!!');
                    pause(2);
                end
              %if ((VALUE>=1-0.3) & (VALUE<=1))
              %     TableNodesInside(conti,:)=[i CombinationTriangles(SetofAnchors,1) CombinationTriangles(SetofAnchors,2) CombinationTriangles(SetofAnchors,3)];
              %     conti=conti+1;
              %else
              %     TableNodesOutside(conto,:)=[i CombinationTriangles(SetofAnchors,1) CombinationTriangles(SetofAnchors,2) CombinationTriangles(SetofAnchors,3)];
              %     conto=conto+1;
              %end
               %We leave an interval to decide that the sum is 360
                %because360-150=210
                %otherwise it is difficult that it would be 'exactly' 360
             %  if(((S1+S2+S3)>=(S)) & ((S1+S2+S3)<=(S+(0.5*S))))
             %       TableNodesInside(conti,:)=[i CombinationTriangles(SetofAnchors,1) CombinationTriangles(SetofAnchors,2) CombinationTriangles(SetofAnchors,3)];
             %       conti=conti+1;
             %  else
             %        TableNodesOutside(conto,:)=[i CombinationTriangles(SetofAnchors,1) CombinationTriangles(SetofAnchors,2) CombinationTriangles(SetofAnchors,3)];
             %        conto=conto+1;
             %  end
                if ((ANGLEint1_deg+ANGLEint2_deg+ANGLEint3_deg)<=(360+epsilon) & (ANGLEint1_deg+ANGLEint2_deg+ANGLEint3_deg)>=(360-epsilon))
                    SUM_ANGLES=360;
                else
                    SUM_ANGLES=ANGLEint1_deg+ANGLEint2_deg+ANGLEint3_deg;
                 end 
               if (SUM_ANGLES==360)
                    %Means that the node is inside of the triangle
                    %determined by the anchors
                    TableNodesInside(conti,:)=[i CombinationTriangles(SetofAnchors,1) CombinationTriangles(SetofAnchors,2) CombinationTriangles(SetofAnchors,3)];
                    conti=conti+1;
               else
                    TableNodesOutside(conto,:)=[i CombinationTriangles(SetofAnchors,1) CombinationTriangles(SetofAnchors,2) CombinationTriangles(SetofAnchors,3)];
                    conto=conto+1;
                end
            end
        end
    end 
    Anchorscounter=0;
end
