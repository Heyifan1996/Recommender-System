function sim= ConstrainedP_sim(x,y )
%计算受限皮尔斯相关系数
x=x-4;
y=y-4;
sum1=x'*y;
sum2=norm(x)*norm(y);
if sum2==0
    sim=0;
else
    sim=sum1/sum2;
end
end

