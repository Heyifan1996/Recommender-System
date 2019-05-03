%Learning Binary Codes for Collaborative Filtering
load movie;
[test,train]=divide(A,0.2);
usernumber=max(A(:,1));
itemnumber=max(A(:,2));
lambda=0.05;%���Ų���
B=30;
R=zeros(usernumber,itemnumber);
for i=1:length(train)
    R(train(i,1),train(i,2))=train(i,3);
end
R=R/max(A(:,3));%��һ��
%��ʼ����Ʒ��������
U=randn(usernumber,B);
V=randn(itemnumber,B);
U1=-ones(size(U));%��ֵ��U
for i=1:usernumber
    temp=U(i,:);
    t=median(temp);
    index=find(temp>t);
    U1(i,index)=1;
end
V1=-ones(size(V));%��ֵ��V
for i=1:itemnumber
    temp=V(i,:);
    t=median(temp);
    index=find(temp>t);
    V1(i,index)=1;
end
%����Q
M=U1'*U+V1'*V;%������FF~^T+HH~^T��
[X,~,Y]=svd(M);
Q=X*Y';
maxiter=1;%����������
learningrate=0.005;%����ݶ��½���ѧϰ��
for iter=1:maxiter
    for t=1:10%���Ҿ���ѧϰ���е�С�����������
        tic;
    for i=1:length(train)
        tempu=train(i,1);
        tempv=train(i,2);
        g_u=-(1/B)*(R(tempu,tempv)-0.5-(1/2/B)*U1(tempu,:)*V1(tempv,:)')*V1(tempv,:)+2*lambda*U1(tempu,:);
        g_v=-(1/B)*(R(tempu,tempv)-0.5-(1/2/B)*U1(tempu,:)*V1(tempv,:)')*U1(tempu,:)+2*lambda*V1(tempv,:);
        U1(tempu,:)=U1(tempu,:)-learningrate*g_u;
        V1(tempv,:)=V1(tempv,:)-learningrate*g_v;
    end
        toc;
    end
    U=U1;
    V=V1;
    U1=-ones(size(U));%��ֵ��U
    for i=1:usernumber
    temp=U(i,:);
    temp=Q*temp';%�˴�������������Q
    t=median(temp);
    index=find(temp>t);
    U1(i,index)=1;
    end
    V1=-ones(size(V));%��ֵ��V
    for i=1:itemnumber
    temp=V(i,:);
    temp=Q*temp';
    t=median(temp);
    index=find(temp>t);
    V1(i,index)=1;
    end
    %����Q
    M=U1'*U+V1'*V;%������FF~^T+HH~^T��
    [X,~,Y]=svd(M);
    Q=X*Y';
end
%����ָ��
pre=zeros(usernumber,1);%����pre
for i=1:usernumber
    tic
    relevant=find(R(i,:)==1);
    S=zeros(itemnumber,1);
    vecu=U1(i,:);
    for j=1:itemnumber
        vecv=V1(j,:);
        S(j)=pdist2(vecu,vecv,'hamming');
    end
    S_u=find(S<=0.1);
    tempset=intersect(S_u,relevant);
    if isempty(S_u)
        pre(i)=0;
    else
        pre(i)=length(tempset)/length(S_u);
    end
    toc;
end


