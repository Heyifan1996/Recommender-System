%Large-scale Collaborative Ranking in Near-Linear Time
load movie;
[test,train]=divide(A,0.2);
usernumber=max(A(:,1));
itemnumber=max(A(:,2));
D=10;%��������ά��
U=randn(usernumber,D);%��ʼ����������
V=randn(itemnumber,D);
R=zeros(usernumber,itemnumber);%���־���
for i=1:length(train)
    R(train(i,1),train(i,2))=train(i,3);
end
vaild=cell(usernumber,1);%������֤��
for i=1:usernumber%ÿ���û����ѡ10������֤��
    temp=find(R(i,:)>0);
    t=temp(randperm(length(temp),10));
    vaild{i}=t;
end

x=Tru_New( R,U,V );%����ݶ�
V=linesearch(R,vaild,U,V,x);%����V
%U�е��ڳɶ���ʧ������ÿһ�����໥�����ģ�����ranksvm���¡�