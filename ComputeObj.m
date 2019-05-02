function [ obj] = ComputeObj( R,vaild,U,V )
%计算验证集的目标函数
obj=0;
for i=1:length(vaild)
    temp=vaild{i};
    p=zeros(length(temp),1);
    for j=1:length(temp)
        p(j)=U(i,:)*V(temp(j),:)';
    end
    rat=R(i,temp);
    for j=1:length(rat)
        for k=j+1:length(rat)
            if (rat(j)<rat(k)&&p(j)<p(k))||(rat(j)>=rat(k)&&p(j)>=p(k))
                obj=obj+1;
            end
        end
    end
end
end

