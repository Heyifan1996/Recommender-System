load 'movie.mat';
 times=10;%������֤����
 itertimes=50;%����������
 Y=zeros(times,itertimes);
 usernumber=max(A(:,1));
 movienumber=max(A(:,2));
  Dataindex=crossdivide(A,times);%���ݵ�����λ��
 for i=1:times;
test=A(Dataindex{i},:);
train=A;
train(Dataindex{i},:)=[];
tic;
[Y(i,:),U,V]=MF(train,test,itertimes,usernumber,movienumber);
toc;
 end
 rmse=sum(Y(:,end))/times;
