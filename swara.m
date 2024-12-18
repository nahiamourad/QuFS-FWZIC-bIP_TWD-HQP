function [results]=swara(S)
eps=10^-8;
m=max(size(S));
[a,Ind]=sort(S,'descend');
[sig,k,omega]=deal(zeros(1,m),zeros(1,m),zeros(1,m));
for i=1:m
    if i==1
        sig(i)=1;
        k(i)=1;
        omega(i)=1;
    else
        sig(i)=a(i)/a(i-1);
        if (abs(sig(i)-1)<eps)
            sig(i)=0;
        end
        k(i)=sig(i)+1;
        omega(i)=omega(i-1)/k(i);
    end
end
w=omega./sum(omega);
sig(Ind)=sig;
k(Ind)=k;
omega(Ind)=omega;
w(Ind)=w;
results=[S;sig;k;omega;w];
end