tic
[m n]=size(Positiveareas);
[o p]=size(Negativeareas);
cont=1;
%If neg and pos (4) values [1:4] match then sum and go for the next row
Sum_found=0;
aux2=1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%FOR POSITIVE NO REPETITIVE%%%%%%%%%%%%%%%%%%%%
for j=1:m %size of Positiveareas
    no_reppos=0;
    for k=1:o                                                %TargetNode          %Gridpoint[x y z]
        Compare_positivenegative=find(Positiveareas(j,1:4)==[Negativeareas(k,1) Negativeareas(k,2:4)]); %Check in the matrix of Negativeareas elements that are equal to Positiveareas
        [q r]=size(Compare_positivenegative); %if size equals to 4 then it has found
        if r==4
            Compare_positivenegative=[];
            Suma_total(aux2,:)=[Positiveareas(j,1) Positiveareas(j,2:4)  Positiveareas(j,5) + Negativeareas(k,5)];
            aux2=aux2+1;
            Doesitexist=1;
            no_reppos=1;
            Sum_found=1;
        end
        if Sum_found==1
            Sum_found=0;
            break; %Terminate the for (k) loop in order to continue with the conditional no_reppos=0? and the next j (to save time)
        end
    end
    if no_reppos==0
            Positiveareas_d(cont,:)=[Positiveareas(j,1) Positiveareas(j,2:4)  Positiveareas(j,5)];
            cont=cont+1;
    end
   
end

cont=1;
Sum_found=0;
Compare_positivenegative=[];

%%%%%%%%%%%%%CODIGO A PRUEBA: FOR NEGATIVE NO REPETITIVE%%%%%%%%%%%%%%%%
for j=1:o %size of Negativeareas
    no_reppos=0;
    for k=1:m                                                %TargetNode          %Gridpoint[x y z]
        Compare_positivenegative=find(Negativeareas(j,1:4)==[Positiveareas(k,1) Positiveareas(k,2:4)]); %Check in the matrix of Negativeareas elements that are equal to Positiveareas
        [q r]=size(Compare_positivenegative); %if size equals to 4 then it has found
        if r==4
            Compare_positivenegative=[];
            no_reppos=1;
            Sum_found=1;
        end
        if Sum_found==1
            Sum_found=0;
            break; %Terminate the for (k) loop in order to continue with the conditional no_reppos=0? and the next j (to save time)
        end
        
    end
    if no_reppos==0
            Negativeareas_d(cont,:)=[Negativeareas(j,1) Negativeareas(j,2:4)  Negativeareas(j,5)];
            cont=cont+1;
    end
   
end
toc