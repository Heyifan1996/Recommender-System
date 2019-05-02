load movie;
[test,train]=divide(A,0.2);%划分数据集
usernumber=max(A(:,1));
itemnumber=max(A(:,2));
%构造已知评分矩阵
R=zeros(usernumber,itemnumber);
for i=1:length(train)
    R(train(i,1),train(i,2))=train(i,3);
end
Item_sim=zeros(itemnumber);%构造产品相似矩阵
for i=1:itemnumber
    tic;
    for j=i+1:itemnumber
        Item_sim(i,j)=cos_sim(R(:,i),R(:,j));
    end
    toc;
end
Item_sim=Item_sim'+Item_sim+eye(itemnumber);
%预计算每个用户的Profile
User_Item=cell(usernumber,1);
for i=1:length(train)
    User_Item{train(i,1)}=[User_Item{train(i,1)},train(i,2)];
end
%产生预测评分
neighbornum=20;%选择邻居数
predict=zeros(length(test),1);
for i=1:length(test)
    u=test(i,1);
    v=test(i,2);
    Itemset=User_Item{u};%用户u的Profile
    s=Item_sim(v,Itemset);%Profile中产品与v的相似度
    [~,index]=sort(s,'descend');%按相似度降序排序
    if length(index)>=neighbornum
        index=index(1:neighbornum);
    end
    Itemset=Itemset(index);
    s=s(index);
    rat=R(u,Itemset);
    predict(i)=rat*s'/sum(s); 
end
predict(isnan(predict))=mean(train(:,3));
RMSE=sqrt(sum((predict-test(:,3)).^2)/length(test));
E=sum(abs(predict-test(:,3)))/length(test);
