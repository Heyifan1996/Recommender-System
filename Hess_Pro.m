function [Ha] = Hess_Pro(R,a,TotalM,U,V)
%���㺣ɭ������
D=size(V,2);
[usernumber,itemnumber]=size(R);
Ha=zeros(itemnumber,D);%Ϊ��ɭ����������λ��
a=reshape(a,D,itemnumber);%a�е�����������һ����������
for i=1:usernumber
    Itemset=find(R(i,:)>0);
    b=zeros(length(Itemset),1);%����������
    for j=1:length(Itemset)
        b(i)=U(i,:)*a(:,Itemset(j));
    end
    m=TotalM{i};
    t=zeros(itemnumber,1);
    for j=1:length(Itemset)
        for k=j+1:length(Itemset)
            y=Yijk(R,i,Itemset(j),Itemset(k));%����Yijkֵ
            temp=y*(m(j)-m(k));
            if temp<1
                s=2*(b(j)-b(k));
                t(Itemset(j))=t(Itemset(j))+s;
                t(Itemset(k))=t(Itemset(k))-s;
            end
        end
    end
    for j=1:length(Itemset)%���㺣ɭ������
        Ha(Itemset(j),:)=Ha(Itemset(j),:)+t(Itemset(j))*U(i,:);
    end
end
Ha=reshape(Ha',itemnumber*D,1);%��Ϊ����
end

