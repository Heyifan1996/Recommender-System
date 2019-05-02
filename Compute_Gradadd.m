function [ g ] =  Compute_Gradadd( R,U,V)
%通过文中算法5实现梯度计算
g=zeros(size(V));
D=size(V,2);
[usernumber,itemnumber]=size(R);%从输入数据得到用户和产品个数
for i=1:usernumber
    Itemset=find(R(i,:)>0);
    m=zeros(length(Itemset),1);
    for j=1:length(m)
        m(i)=U(i,:)*V(Itemset(j),:)';
    end
    [sortm,index]=sort(m);
    pi=Itemset(index);%把产品按预测评分升序排序
    s=zeros(5,1);%数据集只含有1~5个评分等级
    c=zeros(5,1);
    p=1;
    TO=zeros(itemnumber,1);
    TN=zeros(itemnumber,1);
    for j=1:length(Itemset)%计算T+
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
    for j=1:length(Itemset)%计算T-不确定是否正确
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
    for j=1:length(Itemset)%计算整体梯度
        g(Itemset(j),:)=g(Itemset(j),:)+(TO(Itemset(j))+TN(Itemset(j)))*U(i,:);
    end
end
g=g+0.01*V;%考虑正则化项
g=reshape(g',itemnumber*D,1);%化为向量
end

