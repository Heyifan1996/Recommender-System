function [ g ] =  Compute_Gradadd( R,U,V)
%ͨ�������㷨5ʵ���ݶȼ���
g=zeros(size(V));
D=size(V,2);
[usernumber,itemnumber]=size(R);%���������ݵõ��û��Ͳ�Ʒ����
for i=1:usernumber
    Itemset=find(R(i,:)>0);
    m=zeros(length(Itemset),1);
    for j=1:length(m)
        m(i)=U(i,:)*V(Itemset(j),:)';
    end
    [sortm,index]=sort(m);
    pi=Itemset(index);%�Ѳ�Ʒ��Ԥ��������������
    s=zeros(5,1);%���ݼ�ֻ����1~5�����ֵȼ�
    c=zeros(5,1);
    p=1;
    TO=zeros(itemnumber,1);
    TN=zeros(itemnumber,1);
    for j=1:length(Itemset)%����T+
        while sortm(p)<=m(j)+1 &&(p<length(m))
            s(R(i,pi(p)))=s(R(i,pi(p)))+sortm(p);
            c(R(i,pi(p)))=c(R(i,pi(p)))+1;
            p=p+1;
        end
        rpip=R(i,pi(p));
        S=sum(s(rpip:end));
        C=sum(c(rpip:end));
        TO(pi(j))=2*(C*(sortm(j)+1)-S);   
    end 
    p=1;
    for j=1:length(Itemset)%����T-��ȷ���Ƿ���ȷ
        while sortm(p)>=m(j)-1 &&(p<length(m))
            s(R(i,pi(p)))=s(R(i,pi(p)))+sortm(p);
            c(R(i,pi(p)))=c(R(i,pi(p)))+1;
            p=p+1;
        end
        rpip=R(i,pi(p));
        S=sum(s(1:rpip));
        C=sum(c(1:rpip));
        TN(pi(j))=2*(C*(sortm(j)-1)-S);
    end
    for j=1:length(Itemset)%���������ݶ�
        g(Itemset(j),:)=g(Itemset(j),:)+(TO(Itemset(j))+TN(Itemset(j)))*U(i,:);
    end
end
g=g+0.01*V;%����������
g=reshape(g',itemnumber*D,1);%��Ϊ����
end

