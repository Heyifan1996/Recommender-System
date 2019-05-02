function [Ha] = Hess_Pro(R,a,TotalM,U,V)
%计算海森向量积
D=size(V,2);
[usernumber,itemnumber]=size(R);
Ha=zeros(itemnumber,D);%为海森向量积分配位置
a=reshape(a,D,itemnumber);%a中的列向量代表一个特征向量
for i=1:usernumber
    Itemset=find(R(i,:)>0);
    b=zeros(length(Itemset),1);%计算向量积
    for j=1:length(Itemset)
        b(i)=U(i,:)*a(:,Itemset(j));
    end
    m=TotalM{i};
    t=zeros(itemnumber,1);
    for j=1:length(Itemset)
        for k=j+1:length(Itemset)
            y=Yijk(R,i,Itemset(j),Itemset(k));%计算Yijk值
            temp=y*(m(j)-m(k));
            if temp<1
                s=2*(b(j)-b(k));
                t(Itemset(j))=t(Itemset(j))+s;
                t(Itemset(k))=t(Itemset(k))-s;
            end
        end
    end
    for j=1:length(Itemset)%计算海森向量机
        Ha(Itemset(j),:)=Ha(Itemset(j),:)+t(Itemset(j))*U(i,:);
    end
end
Ha=reshape(Ha',itemnumber*D,1);%化为向量
end

