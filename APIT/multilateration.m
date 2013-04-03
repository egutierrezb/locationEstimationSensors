function [Estimatedcoordinates_mult]=multilateration(Estimatedcoordinates, Audibleanchors, dMLE, TrueDist, Noise, BiasFactor, X)

%Estimatedcoordinates are the initial positions, we are going to use
%Newton-Raphson/least-squares within the paper of Localization of Sensors
%First we are going to use TrueDist, after we have to consider an approach
%to consider noisy measurements.

%A refers to the anchor
%so to the initial point
%we should need the 
%D_A1 distance from A1 to i
Estimatedcoordinates_mult=[];
Num_iteraciones=0;

global M N
epsilon=0.1; %accuracy between estimated coordinates and true coordinates, in order to break the cycle
cont=1;
%flag=1; %Just for entering the while the first time

for i=1:(M+N)
    Findtarget=[];
    Nodesforanchor=[];
    Aiter=[]; %initialization of arrays
    b=[];
    Weights=[];
    Findtarget=find(Estimatedcoordinates(:,1)==i);
    E_So=1000; %dummies
    E_Soprime=1;
    if (isempty(Findtarget)==0)
           fprintf(1,'--Refining position of node %d\n',i);
           So=Estimatedcoordinates(Findtarget(1),2:3); %retrieves {x,y} from the estimated node to be considered as a seed.
           Nodesforanchor=find(Audibleanchors(:,1)==i); %Search for the rows for the particular target node, from the rows we can obtain the anchors.
           [m n]=size(Nodesforanchor);
           %Create weights for the process of multilateration, variance of
           %the distance is multiplicative
           if Noise==1
               for k=1:m
                   for l=1:m
                       if k==l
                           Weights(l,k)=1/(1+(((BiasFactor^4)-BiasFactor)*(TrueDist(i,Audibleanchors(Nodesforanchor(k),2)))^2)); %variance between anchor and target node
                       else
                           Weights(l,k)=0;
                       end
                   end
               end
           else
                for k=1:m
                   for l=1:m
                       if k==l
                           Weights(l,k)=1;
                       else
                           Weights(l,k)=0;
                       end
                   end
                end
           end
               
           while(abs(E_Soprime-E_So)>epsilon)
               Num_iteraciones=Num_iteraciones+1;
               Aiter=[];
               b=[];
               E_Soprime=0;
               E_So=0;
               for j=1:m %Now we are in the phase of the anchors of a specific EStimatedcoordinated
                    Aiter_concat=[(So(1,1)-X(Audibleanchors(Nodesforanchor(j),2),1))/sqrt((So(1,1)-X(Audibleanchors(Nodesforanchor(j),2),1))^2+(So(1,2)-X(Audibleanchors(Nodesforanchor(j),2),2))^2) (So(1,2)-X(Audibleanchors(Nodesforanchor(j),2),2))/sqrt((So(1,1)-X(Audibleanchors(Nodesforanchor(j),2),1))^2+(So(1,2)-X(Audibleanchors(Nodesforanchor(j),2),2))^2)];
                    Aiter=[Aiter; Aiter_concat]; %the size of Aiter will depend of the number of anchors for the particular estimated node    
                    b_concat=[[(So(1,1)-X(Audibleanchors(Nodesforanchor(j),2),1))/sqrt((So(1,1)-X(Audibleanchors(Nodesforanchor(j),2),1))^2+(So(1,2)-X(Audibleanchors(Nodesforanchor(j),2),2))^2) ((So(1,2)-X(Audibleanchors(Nodesforanchor(j),2),2))/sqrt((So(1,1)-X(Audibleanchors(Nodesforanchor(j),2),1))^2+(So(1,2)-X(Audibleanchors(Nodesforanchor(j),2),2))^2))]*So' - ((sqrt((So(1,1)-X(Audibleanchors(Nodesforanchor(j),2),1))^2+(So(1,2)-X(Audibleanchors(Nodesforanchor(j),2),2))^2))-dMLE(Audibleanchors(Nodesforanchor(j),2),i))];
                    b=[b; b_concat];
                    E_So_concat=(power((sqrt((So(1,1)-X(Audibleanchors(Nodesforanchor(j),2),1))^2+(So(1,2)-X(Audibleanchors(Nodesforanchor(j),2),2))^2))-dMLE(Audibleanchors(Nodesforanchor(j),2),i),2));
                    E_So=E_So+E_So_concat;
               end
               Soprime=pinv((Aiter')*Weights*Aiter)*(Aiter')*Weights*b; %New So computed
               Soprime=Soprime';
               for j=1:m
                    E_Soprime_concat=(power((sqrt((Soprime(1,1)-X(Audibleanchors(Nodesforanchor(j),2),1))^2+(Soprime(1,2)-X(Audibleanchors(Nodesforanchor(j),2),2))^2))-dMLE(Audibleanchors(Nodesforanchor(j),2),i),2)); %Compute the squared error between the observed ranges ri and the predicted distancies for Soprime
                    E_Soprime=E_Soprime+E_Soprime_concat;
               end
               So=Soprime; %Update values
           end
           fprintf(1,'--Num_iteraciones %d\n',Num_iteraciones);
           Num_iteraciones=0;
           Estimatedcoordinates_mult(cont,:)=[i So];
          % flag=1;
           cont=cont+1;
    end
end
%We need the Audibleanchors
   % so=x(i,:);
   % while(abs(Esoprime-Eso)>0.01)
   %     Aiter=[(so(1,1)-A(1,1))/sqrt((so(1,1)-A(1,1))^2+(so(1,2)-A(1,2))^2) (so(1,2)-A(1,2))/sqrt((so(1,1)-A(1,1))^2+(so(1,2)-A(1,2))^2); (so(1,1)-A(2,1))/sqrt((so(1,1)-A(2,1))^2+(so(1,2)-A(2,2))^2) (so(1,2)-A(2,2))/sqrt((so(1,1)-A(2,1))^2+(so(1,2)-A(2,2))^2); (so(1,1)-A(3,1))/sqrt((so(1,1)-A(3,1))^2+(so(1,2)-A(3,2))^2) (so(1,2)-A(3,2))/sqrt((so(1,1)-A(3,1))^2+(so(1,2)-A(3,2))^2)];
   %     b=[[(so(1,1)-A(1,1))/sqrt((so(1,1)-A(1,1))^2+(so(1,2)-A(1,2))^2) ((so(1,2)-A(1,2))/sqrt((so(1,1)-A(1,1))^2+(so(1,2)-A(1,2))^2))]*y - ((sqrt((so(1,1)-A(1,1))^2+(so(1,2)-A(1,2))^2))-D_A1); [(so(1,1)-A(2,1))/sqrt((so(1,1)-A(2,1))^2+(so(1,2)-A(2,2))^2) (so(1,2)-A(2,2))/sqrt((so(1,1)-A(2,1))^2+(so(1,2)-A(2,2))^2)]*y - ((sqrt((so(1,1)-A(2,1))^2+(so(1,2)-A(2,2))^2))-D_A2); [(so(1,1)-A(3,1))/sqrt((so(1,1)-A(3,1))^2+(so(1,2)-A(3,2))^2) ((so(1,2)-A(3,2))/sqrt((so(1,1)-A(3,1))^2+(so(1,2)-A(3,2))^2))]*y - ((sqrt((so(1,1)-A(3,1))^2+(so(1,2)-A(3,2))^2))-D_A3)];
   %     soprime=pinv((Aiter')*Aiter)*(Aiter')*b;
   %     soprime=soprime';
   %     Esoprime=(power((sqrt((soprime(1,1)-A(1,1))^2+(soprime(1,2)-A(1,2))^2))-D_A1,2)+power((sqrt((soprime(1,1)-A(2,1))^2+(soprime(1,2)-A(2,2))^2))-D_A2,2)+power((sqrt((soprime(1,1)-A(3,1))^2+(soprime(1,2)-A(3,2))^2))-D_A3,2));
   %     Eso=(power((sqrt((so(1,1)-A(1,1))^2+(so(1,2)-A(1,2))^2))-D_A1,2)+power((sqrt((so(1,1)-A(2,1))^2+(so(1,2)-A(2,2))^2))-D_A2,2)+power((sqrt((so(1,1)-A(3,1))^2+(so(1,2)-A(3,2))^2))-D_A3,2));
   %     so=soprime;
   % end
   