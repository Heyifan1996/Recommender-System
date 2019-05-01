load movie;
[test,train]=divide(A,0.2);%�������ݼ�
usernumber=max(A(:,1));
itemnumber=max(A(:,2));
%������֪���־���
R=zeros(usernumber,itemnumber);
for i=1:length(train)
    R(train(i,1),train(i,2))=train(i,3);
end
User_sim=zeros(usernumber);
for i=1:usernumber%�����û������ƶ�
    for j=i+1:usernumber
        User_sim(i,j)=cos_sim(R(i,:)',R(j,:)');%Ҳ��ʹ��Pearson_sim ��ConstrainedP_sim
    end
end
User_sim=User_sim'+User_sim+eye(usernumber);

%����Ԥ������
neighbornum=20;
predict=zeros(length(test),1);
for i=1:length(test)
    tic;
    u=test(i,1);
    v=test(i,2);
    userset=find(R(:,v)>0);%�Բ�Ʒv���ֹ����û�
    s=User_sim(u,userset);%�û�u��userset�����ƶ�
    [~,index]=sort(s,'descend');%�����ƶ�����
    if length(s)>=neighbornum
        index=index(1:20);
    end
    userset=userset(index);%ǰneighbornum�������û�����
    s=s(index);%��Ӧ�����ƶ�
    rat=R(userset,v);%��Ӧ������
    predict(i)=s*rat/sum(s);
    toc;
end
predict(isnan(predict))=mean(train(:,3));
RMSE=sqrt(sum((predict-test(:,3)).^2)/length(test));
E=sum(abs(predict-test(:,3)))/length(test);



