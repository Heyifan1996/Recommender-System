function [result] = Yijk( R,i,j,k)
%����Yijk
if R(i,j)>R(i,k)
    result=1;
else
    result=-1;
end
end

