load movie;
[test,train]=divide(A,0.2);%�������ݼ�
usernumber=max(A(:,1));
itemnumber=max(A(:,2));
%������֪���־���
R=zeros(usernumber,itemnumber);
for i=1:length(train)
    R(train(i,1),train(i,2))=train(i,3);
end
Item_sim=zeros(itemnumber);%�����Ʒ���ƾ���
for i=1:itemnumber
    tic;
    for j=i+1:itemnumber
        Item_sim(i,j)=cos_sim(R(:,i),R(:,j));
    end
    toc;
end
Item_sim=Item_sim'+Item_sim+eye(itemnumber);
%Ԥ����ÿ���û���Profile
User_Item=cell(usernumber,1);
for i=1:length(train)
    User_Item{train(i,1)}=[User_Item{train(i,1)},train(i,2)];
end
%����Ԥ������
neighbornum=20;%ѡ���ھ���
predict=zeros(length(test),1);
for i=1:length(test)
    u=test(i,1);
    v=test(i,2);
    Itemset=User_Item{u};%�û�u��Profile
    s=Item_sim(v,Itemset);%Profile�в�Ʒ��v�����ƶ�
    [~,index]=sort(s,'descend');%�����ƶȽ�������
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
