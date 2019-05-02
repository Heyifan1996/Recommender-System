function [x] = Tru_New( R,U,V )
%牛顿截断法
D=size(V,2);
[~,itemnumber]=size(R);%从输入数据得到用户和产品个数
[g,TotalM]=Compute_Grad(R,U,V);
x=zeros(itemnumber*D,1);
r=Hess_Pro(R,x,TotalM,U,V)-g;
p=-r;
maxiter=20;
for iter=1:maxiter%使用共轭梯度法算出梯度
    q=Hess_Pro(R,p,TotalM,U,V);
    a=-(r'*p)/(p'*q);
    x=x+a*p;  
    if norm(r+a*q)<(norm(r)/100)
        break
    end
    r=r+a*q;
    beta=(r'*q)/(p'*q);
    p=-r+beta*p;  
end
x=reshape(x,D,itemnumber);
x=x';%输出梯度
end

