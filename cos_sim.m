function [sim ] = cos_sim( x,y )
%�����������ƶ�
sum1=x'*y;
sum2=norm(x)*norm(y);
if sum2==0
    sim=0;
else
    sim=sum1/sum2;
end
end

