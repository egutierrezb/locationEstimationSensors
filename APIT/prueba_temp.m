   min=0; %Counter in order to know which is the minimum common set between the neighbors
            tempmin=min;
            counter=1;
            flag_if=1;
            Neighborhood_shared=[]; 
for ii=1:(M+N)
                Counter_question_three=[];
                Counter_question_three=find(Anchorstriangle_neighborandtarget(:,2)==ii); %Check for neighbor, if there are 3 or more repetitions of the same neighbor, it means that hears to three anchors or more
                if(isempty(Counter_question_three)==0)
                    [mc nc]=size(Counter_question_three);
                    if mc>=3 %Means that it has more or equal than three anchors
                        for t=1:mc %Format of Neighborhood_shared=[Neighborhood Audibleanchor]
                            Neighborhood_shared(counter,:)=[Anchorstriangle_neighborandtarget(Counter_question_three(t),2) Anchorstriangle_neighborandtarget(Counter_question_three(t),3)]; %Saves the audibleanchor and the neighbor
                            counter=counter+1;
                            min=min+1;
                        end
                    end
                    if flag_if==1 & (isempty(Counter_question_three)==0)                                                          
                        tempmin=min;
                        flag_if=0;
                    end
                    if flag_if==0 & (min<tempmin) & (mc>=3)
                        tempmin=min; %tempmin will indicate the number of common anchors that the neighbors and anchor i share.
                    end
                    Counter_question_three=[];
                    min=0; %Reinitialization of counter
                end
            end