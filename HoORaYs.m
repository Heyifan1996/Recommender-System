load 'movie.mat'
%数据集分割
usernumber=max(A(:,1));
itemnumber=max(A(:,2));
[B,C]=divide(A,0.9);%B为训练集，C为测试集
%初始化各参数
learningrate=0.005;
lambda_u=0.1;
lambda_v=0.1;
lambda_d=0.01;
tic;
user_score=zeros(usernumber,5);
item_score=zeros(itemnumber,5);
for i=1:length(B)
    user_score(B(i,1),B(i,3))=user_score(B(i,1),B(i,3))+1;
    item_score(B(i,2),B(i,3))=item_score(B(i,2),B(i,3))+1;
end
score_number=zeros(length(B),5);
for i=1:length(B)
    for j=1:5
        score_number(i,j)=user_score(B(i,1),j)+item_score(B(i,2),j);
    end
    score_number(i,B(i,3))=score_number(i,B(i,3))-1;
end
toc;
rng(0);
D=30;
U=rand(usernumber,D);
V=rand(itemnumber,D);

itermax=100;%迭代次数
mean=zeros(itermax,1);
 RMSE=zeros(itermax,1);
for iter=1:itermax
    tic;
    for i=1:length(B)
        tempuser=B(i,1);
        tempitem=B(i,2);
        tempscore=B(i,3);
        %更新U
        U(tempuser,:)=U(tempuser,:)+learningrate*(-lambda_u*U(tempuser,:)+(tempscore-U(tempuser,:)*V(tempitem,:)')*V(tempitem,:)+lambda_d*(score_number(i,1)*twoorder(U(tempuser,:),V(tempitem,:),tempscore,1)+score_number(i,2)*twoorder(U(tempuser,:),V(tempitem,:),tempscore,2)+score_number(i,3)*twoorder(U(tempuser,:),V(tempitem,:),tempscore,3)+score_number(i,4)*twoorder(U(tempuser,:),V(tempitem,:),tempscore,4)+score_number(i,5)*twoorder(U(tempuser,:),V(tempitem,:),tempscore,5)));
        %更新V
        V(tempitem,:)=V(tempitem,:)+learningrate*(-lambda_v*V(tempitem,:)+(tempscore-U(tempuser,:)*V(tempitem,:)')*U(tempuser,:)+lambda_d*(score_number(i,1)*twoorder(V(tempitem,:),U(tempuser,:),tempscore,1)+score_number(i,2)*twoorder(V(tempitem,:),U(tempuser,:),tempscore,2)+score_number(i,3)*twoorder(V(tempitem,:),U(tempuser,:),tempscore,3)+score_number(i,4)*twoorder(V(tempitem,:),U(tempuser,:),tempscore,4)+score_number(i,5)*twoorder(V(tempitem,:),U(tempuser,:),tempscore,5)));
    end
    toc;
       x=C(:,1);
       y=C(:,2);
       pre_out=sum(U(x,:).*V(y,:),2);
       error=pre_out-C(:,3);
       mean(iter)=sum(abs(error))/length(C);
       RMSE(iter)=sqrt(sum(error.^2)/length(C));
end

figure(1);
plot(RMSE);
xlabel('itertimes');
ylabel('RMSE');



