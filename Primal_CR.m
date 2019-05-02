%Large-scale Collaborative Ranking in Near-Linear Time
load movie;
[test,train]=divide(A,0.2);
usernumber=max(A(:,1));
itemnumber=max(A(:,2));
D=10;%特征向量维度
U=randn(usernumber,D);%初始化特征矩阵
V=randn(itemnumber,D);
R=zeros(usernumber,itemnumber);%评分矩阵
for i=1:length(train)
    R(train(i,1),train(i,2))=train(i,3);
end
vaild=cell(usernumber,1);%产生验证集
for i=1:usernumber%每个用户随机选10个当验证集
    temp=find(R(i,:)>0);
    t=temp(randperm(length(temp),10));
    vaild{i}=t;
end

x=Tru_New( R,U,V );%算出梯度
V=linesearch(R,vaild,U,V,x);%更新V
%U中的在成对损失函数中每一行是相互独立的，可用ranksvm更新。