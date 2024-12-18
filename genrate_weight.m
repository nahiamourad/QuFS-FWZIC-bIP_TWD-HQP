function [W,alph,boundry,delta]=genrate_weight(w0,nbin)
eps=0.00001;
n=length(w0);
alph=w0./(1-max(w0));
[~ , id]=max(w0);
deltaLb=-max(w0);
deltaUb=1-max(w0);
boundry=[deltaLb deltaUb];
L=(deltaUb-deltaLb)/nbin;
delta=zeros(1,nbin);
for i=1:nbin
    if i==1
    delta(i)=deltaLb;
    else 
      delta(i)= delta(i-1)+L;
    end
end
delta=[delta deltaUb];
W=zeros(nbin,size(w0,2));
for i=1:nbin
  W(i,:)=w0-delta(i)*alph;
end
W(:,id)=0;
W(:,id)=1-sum(W,2);
W=[W;eps*ones(1,n)];
W(end,id)=1-eps*(n-1);
W=[w0;W];
W(W==0)=eps;%%To avoid zero weight coefficient