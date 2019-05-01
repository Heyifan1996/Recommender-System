function [B,C] = divide(A,p)
%划分数据集为训练和测试集
a=randperm(length(A));%随机数序列
number=round(length(A)*p);%测试集的个数
B=A(a(1:number),:);
C=A(a(number+1:end),:);
% B=sortrows(B,1:2);%按前两行进行排序以下，没什么用就是好看
% C=sortrows(C,1:2);
end

