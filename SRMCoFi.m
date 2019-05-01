clear;clc;
load movie;
usernumber=max(A(:,1));
itemnumber=max(A(:,2));
[Tr,Te]=datadivide(A,0.2);%�������ݼ�20%Ϊ���Լ���ʣ���Ϊѵ����
clear A;
%construct observed rating matrix
R=zeros(usernumber,itemnumber);
for i=1:size(Tr,1)
    R(Tr(i,1),Tr(i,2))=Tr(i,3);
end
%����ÿ���û������ֵĲ�Ʒ����
Uset=cell(usernumber,1);
%����ÿ����Ʒ�������ֵ��û�����
Iset=cell(itemnumber,1);
for i=1:length(Tr)
    tempuser=Tr(i,1);
    tempitem=Tr(i,2);
    Uset{tempuser}=[Uset{tempuser},tempitem];
    Iset{tempitem}=[Iset{tempitem},tempuser];
end

%��ʼ��mu��a,b,U,V
mu=mean(Tr(:,3));
a=zeros(usernumber,1);
for i=1:usernumber
    a(i)=sum(R(i,:))/length(find(R(i,:)>0));
end
a(isnan(a))=mu;
a=a-mu;
b=zeros(itemnumber,1);
for i=1:itemnumber
    b(i)=sum(R(:,i))/length(find(R(:,i)>0));
end
b(isnan(b))=mu;
b=b-mu;
D=30;
U=randn(usernumber,D);
V=randn(itemnumber,D);
%��ʼ��xigama
p=zeros(size(Tr,1),1);
for i=1:size(Tr,1)
    p(i)=mu+a(Tr(i,1))+b(Tr(i,2))+U(Tr(i,1),:)*V(Tr(i,2),:)';
end
xigama=sum((Tr(:,3)-p).^2)/size(Tr,1);
xigama_mu=mu^2;
xigama_a=sum(a.^2)/usernumber;
xigama_b=sum(b.^2)/itemnumber;
xigama_U=sum(sum(U.^2))/usernumber/D;
xigama_V=sum(sum(V.^2))/itemnumber/D;
%��������
maxiter=100;
for k=1:maxiter
    tic;
    %����lambdas
    lambda_U=xigama/xigama_U;
    lambda_V=xigama/xigama_V;
    lambda_mu=xigama/xigama_mu;
    lambda_a=xigama/xigama_a;
    lambda_b=xigama/xigama_b;
    %����parameters
    %����mu
    temp=0;
    for i=1:length(Tr)
        temp=temp+(Tr(i)-a(Tr(i,1))-b(Tr(i,2))-U(Tr(i,1),:)*V(Tr(i,2),:)');
    end
    mu=temp/(lambda_mu+length(Tr));
    %����a
    for i=1:usernumber
        tempv=Uset{i};%��ǰ�û��Ĳ�Ʒ����
        temp=0;
        for j=1:length(tempv)
            temp=temp+(R(i,tempv(j))-mu-b(tempv(j))-U(i,:)*V(tempv(j),:)');
        end
        a(i)=temp/(lambda_a+length(tempv));
    end
    %����b
    for i=1:itemnumber
        tempu=Iset{i};%��ǰ��Ʒ���û�����
        temp=0;
        for j=1:length(tempu)
            temp=temp+(R(tempu(j),i)-mu-a(tempu(j))-U(tempu(j),:)*V(i,:)');
        end
        b(i)=temp/(lambda_b+length(tempu));
        
    end
    %����U
    for i=1:usernumber
        tempv=Uset{i};
        matrix=lambda_U*eye(D);
        vect=zeros(D,1);
        for j=1:length(tempv)
            matrix=matrix+V(tempv(j),:)'*V(tempv(j),:);
            vect=vect+(R(i,tempv(j))-mu-a(i)-b(tempv(j)))*V(tempv(j),:)';
        end
        U(i,:)=(matrix^-1*vect)';
    end
    %����V
    for i=1:itemnumber
        tempu=Iset{i};
        matrix=lambda_V*eye(D);
        vect=zeros(D,1);
        for j=1:length(tempu)
             matrix=matrix+U(tempu(j),:)'*U(tempu(j),:);
            vect=vect+(R(tempu(j),i)-mu-a(tempu(j))-b(i))*U(tempu(j),:)';
        end
     V(i,:)=(matrix^-1*vect)';
    end
    %����Hyperparameters
    p=zeros(size(Tr,1),1);
    for i=1:size(Tr,1)
        p(i)=mu+a(Tr(i,1))+b(Tr(i,2))+U(Tr(i,1),:)*V(Tr(i,2),:)';
    end
    xigama=sum((Tr(:,3)-p).^2)/size(Tr,1);
    xigama_mu=mu^2;
    xigama_a=sum(a.^2)/usernumber;
    xigama_b=sum(b.^2)/itemnumber;
    xigama_U=sum(sum(U.^2))/usernumber/D;
    xigama_V=sum(sum(V.^2))/itemnumber/D;
    toc;
end
  p1=zeros(size(Te,1),1);
    for i=1:size(Te,1)
        p1(i)=mu+a(Te(i,1))+b(Te(i,2))+U(Te(i,1),:)*V(Te(i,2),:)';
    end
    p1(p1>5)=5;
    p1(p1<1)=1;
%     p1=ones(length(Te),1)*mean(Tr(:,3));
    RMSE=sum((Te(:,3)-p1).^2)/length(p1);