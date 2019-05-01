function [RMSE,U,V] = MF( train,test,itertimes,usernumber,movienumber )
lanta=0.03;
r=0.01;
D=10;
rng(0);
U=rand(usernumber,D);
rng(1);
V=rand(movienumber,D);
RMSE=zeros(itertimes,1);
% E=zeros(itertimes,1);
for i=1:itertimes
    for j=1:length(train)%ÌÝ¶ÈÏÂ½µ 
        tempuser=train(j,1);
        tempmovie=train(j,2);
        tempscore=train(j,3);
        U(tempuser,:)=U(tempuser,:)+r*((tempscore-U(tempuser,:)*V(tempmovie,:)')*V(tempmovie,:)-lanta*U(tempuser,:));
        V(tempmovie,:)=V(tempmovie,:)+r*((tempscore-U(tempuser,:)*V(tempmovie,:)')*U(tempuser,:)-lanta*V(tempmovie,:));
    
    end 
       x=test(:,1);
       y=test(:,2);
       pre_out=sum(U(x,:).*V(y,:),2);
       error=pre_out-test(:,3);
       RMSE(i)=sqrt(sum(error.^2)/length(test));
end


end

