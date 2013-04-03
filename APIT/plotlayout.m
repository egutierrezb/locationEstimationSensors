function plotlayout(X,Indices,Estimatedcoordinates_ref)
global M N
hold off;
for i=1:N
    A(i,:)=X(Indices(i,:),:);
end
%Anchors in square and red
figure(2);
plot(A(:,1),A(:,2),'rs','MarkerFaceColor','r')
hold on;
plot(X(:,1),X(:,2),'bo');
labels = num2str((1:(M+N))'); %M+N
%For labelling each sensor
text(X(:,1)+.06,X(:,2),labels,'Color','r');
plot(Estimatedcoordinates_ref(:,2),Estimatedcoordinates_ref(:,3),'v','MarkerEdgeColor','k','MarkerFaceColor','b');
labels = num2str(Estimatedcoordinates_ref(:,1));
%For labelling each sensor
text(Estimatedcoordinates_ref(:,2)+.06,Estimatedcoordinates_ref(:,3),labels,'Color','r');
drawlinesrealestpos(Estimatedcoordinates_ref,X);

