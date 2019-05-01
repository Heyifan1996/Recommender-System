function [traindata,testdata ] = datadivide( A,percent )
%按比例随机划分数据集
n=size(A,1);
testnum=floor(n*percent);
index=randperm(n);
testdata=A(index(1:testnum),:);
traindata=A(index(testnum+1:end),:);
end

