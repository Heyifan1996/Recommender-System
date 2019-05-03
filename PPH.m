%Preference Preserving Hashing for Efficient Recommendation
load movie;
usernumber=max(A(:,1));
itemnumber=max(A(:,2));
[test,train]=divide(A,0.2);
rmax=max(A(:,3));%�������ֵ
lambda=0.03;
D=40;
U=randn(usernumber,D);
V=randn(itemnumber,D);
%CFN����UV
learningrate=0.01;
maxiter=10;%����������
for iter=1:maxiter
    tic;
    for i=1:length(train)
        tempu=train(i,1);
        tempv=train(i,2);
        tempscore=train(i,3);
        vecu=U(tempu,:);
        vecv=V(tempv,:);
        error=tempscore-0.5*rmax-vecu*vecv';
        g_u=-2*error*vecv+2*lambda*(norm(vecu)^2-0.5*rmax)*vecu;
        g_v=-2*error*vecu+2*lambda*(norm(vecv)^2-0.5*rmax)*vecv;
        U(tempu,:)=U(tempu,:)-learningrate*g_u;
        V(tempv,:)=V(tempv,:)-learningrate*g_v;
    end
    toc;
end
% %��֤�Ƿ���Ч
% p=zeros(length(test),1);
% for i=1:length(p)
%     p(i)=U(test(i,1),:)*V(test(i,2),:)';
% end
% sum(abs(p+rmax/2-test(:,3)))/length(p);
%MPQ�������й�ϣ
U1=-1*ones(size(U));%���ڽǶȵ�������ֵ��
U1(U>=0)=1;
V1=-1*ones(size(V));
V1(V>=0)=1;
ExU=ones(usernumber,2);%����ģ�Ķ�ֵ������
U1=[U1,ExU];
ExV=zeros(itemnumber,2);
NOR=zeros(itemnumber,1);%�������Ʒ����������Febious����
for i=1:itemnumber
    NOR(i)=norm(V(i,:));
end
%���Ǵ˴�����68%���ǰ�2/3��
[~,index]=sort(NOR);
nn=floor(itemnumber/3);
ExV(index(1:nn),:)=repmat([-1,-1],nn,1);
ExV(index(nn+1:2*nn),:)=repmat([-1,1],nn,1);
ExV(index(2*nn+1:end),:)=repmat([1,1],itemnumber-2*nn,1);
V1=[V1,ExV];
%ѵ����U,V�����Ƽ��Ͳ�д��

