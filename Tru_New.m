function [x] = Tru_New( R,U,V )
%ţ�ٽضϷ�
D=size(V,2);
[~,itemnumber]=size(R);%���������ݵõ��û��Ͳ�Ʒ����
[g,TotalM]=Compute_Grad(R,U,V);
x=zeros(itemnumber*D,1);
r=Hess_Pro(R,x,TotalM,U,V)-g;
p=-r;
maxiter=20;
for iter=1:maxiter%ʹ�ù����ݶȷ�����ݶ�
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
x=x';%����ݶ�
end

