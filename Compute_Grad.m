function [ g,TotalM ] = Compute_Grad( R,U,V)
%计算梯度
g=zeros(size(V));
D=size(V,2);
[usernumber,itemnumber]=size(R);%从输入数据得到用户和产品个数
TotalM=cell(usernumber,1);
for i=1:usernumber
    Itemset=find(R(i,:)>0);
    m=zeros(length(Itemset),1);%预计算预测评分
    for j=1:length(Itemset)
        m(j)=U(i,:)*V(Itemset(j),:)';       
    end
    TotalM{i}=m;
    t=zeros(itemnumber,1);%计算累积梯度值
    for j=1:length(Itemset)
        for k=j+1:length(Itemset)
            y=Yijk(R,i,Itemset(j),Itemset(k));%计算Yijk值
            temp=y*(m(j)-m(k));
            if temp<1%由于文中采用的是L(a)=2min(a-1,0)判别函数
                s=2*(temp-1);
                t(Itemset(j))=t(Itemset(j))+y*s;
                t(Itemset(k))=t(Itemset(k))-y*s;
            end      
        end
    end
    for j=1:length(Itemset)%计算整体梯度
        g(Itemset(j),:)=g(Itemset(j),:)+t(Itemset(j))*U(i,:);
    end
end
g=g+0.01*V;%考虑正则化项
g=reshape(g',itemnumber*D,1);%化为向量
end

