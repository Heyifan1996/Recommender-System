function sim = Pearson_sim(x,y )
%计算皮尔斯相关系数
x=x-mean(x);
y=y-mean(y);
sum1=x'*y;
sum2=norm(x)*norm(y);
if sum2==0
    sim=0;
else
    sim=sum1/sum2;
end
end

