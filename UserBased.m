load movie;
[test,train]=divide(A,0.2);%划分数据集
usernumber=max(A(:,1));
itemnumber=max(A(:,2));
%构造已知评分矩阵
R=zeros(usernumber,itemnumber);
for i=1:length(train)
    R(train(i,1),train(i,2))=train(i,3);
end
User_sim=zeros(usernumber);
for i=1:usernumber%计算用户间相似度
    for j=i+1:usernumber
        User_sim(i,j)=cos_sim(R(i,:)',R(j,:)');%也可使用Pearson_sim 和ConstrainedP_sim
    end
end
User_sim=User_sim'+User_sim+eye(usernumber);

%产生预测评分
neighbornum=20;
predict=zeros(length(test),1);
for i=1:length(test)
    tic;
    u=test(i,1);
    v=test(i,2);
    userset=find(R(:,v)>0);%对产品v评分过的用户
    s=User_sim(u,userset);%用户u对userset的相似度
    [~,index]=sort(s,'descend');%按相似度排序
    if length(s)>=neighbornum
        index=index(1:20);
    end
    userset=userset(index);%前neighbornum个相似用户集合
    s=s(index);%对应的相似度
    rat=R(userset,v);%对应的评分
    predict(i)=s*rat/sum(s);
    toc;
end
predict(isnan(predict))=mean(train(:,3));
RMSE=sqrt(sum((predict-test(:,3)).^2)/length(test));
E=sum(abs(predict-test(:,3)))/length(test);



