function [Dataindex] = crossdivide(A,times)
%�������ݼ�Ϊѵ���Ͳ��Լ�
a=randperm(length(A));%���������
num=floor(length(a)/times);
Dataindex=cell(times,1);
for i=1:times-1
    Dataindex{i}= a((i-1)*num+1:i*num);  
end
Dataindex{times}=a((times-1)*num+1:end);
end

