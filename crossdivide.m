function [Dataindex] = crossdivide(A,times)
%划分数据集为训练和测试集
a=randperm(length(A));%随机数序列
num=floor(length(a)/times);
Dataindex=cell(times,1);
for i=1:times-1
    Dataindex{i}= a((i-1)*num+1:i*num);  
end
Dataindex{times}=a((times-1)*num+1:end);
end

