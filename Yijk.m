function [result] = Yijk( R,i,j,k)
%¼ÆËãYijk
if R(i,j)>R(i,k)
    result=1;
else
    result=-1;
end
end

