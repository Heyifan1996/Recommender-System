function [ g,TotalM ] = Compute_Grad( R,U,V)
%�����ݶ�
g=zeros(size(V));
D=size(V,2);
[usernumber,itemnumber]=size(R);%���������ݵõ��û��Ͳ�Ʒ����
TotalM=cell(usernumber,1);
for i=1:usernumber
    Itemset=find(R(i,:)>0);
    m=zeros(length(Itemset),1);%Ԥ����Ԥ������
    for j=1:length(Itemset)
        m(j)=U(i,:)*V(Itemset(j),:)';       
    end
    TotalM{i}=m;
    t=zeros(itemnumber,1);%�����ۻ��ݶ�ֵ
    for j=1:length(Itemset)
        for k=j+1:length(Itemset)
            y=Yijk(R,i,Itemset(j),Itemset(k));%����Yijkֵ
            temp=y*(m(j)-m(k));
            if temp<1%�������в��õ���L(a)=2min(a-1,0)�б���
                s=2*(temp-1);
                t(Itemset(j))=t(Itemset(j))+y*s;
                t(Itemset(k))=t(Itemset(k))-y*s;
            end      
        end
    end
    for j=1:length(Itemset)%���������ݶ�
        g(Itemset(j),:)=g(Itemset(j),:)+t(Itemset(j))*U(i,:);
    end
end
g=g+0.01*V;%����������
g=reshape(g',itemnumber*D,1);%��Ϊ����
end

