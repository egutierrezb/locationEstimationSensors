tic
[m n]=size(Positiveareas);
[o p]=size(Negativeareas);
cont=1;
aux2=1;
%If neg and pos (4) values [1:4] match then sum and go for the next row
Sum_found=0;

for j=1:m
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

%We have already checked that elements in Suma_total does not repeat in
%Positiveareas_d, Indeed, the size of Suma_total (which has the repetitive elements of Positiveareas) plus the size of
%Positiveareas_d equals to the size of Positiveareas.
cont=1;

%%%%%%%%%%%%%%%%%%%CODIGO A PRUEBA%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%To accelarate process of search
%Search for rows indexes for particular nodes
aux=1;
for i=1:65 %M+N
    %Recognize which rows belongs to particular Nodes
    temp=find(Negativeareas(:,1)==i);
    if(isempty(temp)==0)
        [m n]=size(temp);
        Index(aux)=m;
        aux=aux+1;
    end
    temp=[];
end

aux=1;
[m n]=size(Suma_total);
[f g]=size(Negativeareas);

indiceinferior=0;
indicesuperior=Index(1);
for p=1:m
    for q=indiceinferior+1:indiceinferior+indicesuperior
        if Suma_total(p,1:4)==Negativeareas(q,1:4)
            doomy=1;
        else
            Negativeareas_d(cont,:)=Negativeareas(q,:);
            cont=cont+1;
        end
    end
    if p~=1
        if Suma_total(p-1,1)~=Suma_total(p,1)
            indiceinferior=Index(aux);
            indicesuperior=Index(aux+1);
            aux=aux+1;
        end
    end   
end
cont=1;
aux=1;
toc
