function [B,C] = divide(A,p)
%�������ݼ�Ϊѵ���Ͳ��Լ�
a=randperm(length(A));%���������
number=round(length(A)*p);%���Լ��ĸ���
B=A(a(1:number),:);
C=A(a(number+1:end),:);
% B=sortrows(B,1:2);%��ǰ���н����������£�ûʲô�þ��Ǻÿ�
% C=sortrows(C,1:2);
end

