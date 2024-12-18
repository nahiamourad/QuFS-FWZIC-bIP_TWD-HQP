function Opinion=Generate_opinion(A,C)
%A is the original expert decision
%C is a row vactor indicating the type of criteria
epsilon=10^-5;
f=@(t,a,b,c,d)((d-c)/(b-a))*(t-a)+c; %will map the interval [𝑎,𝑏] onto [c,d]
[n,m]=size(A);
Opinion=zeros(n,m);
for j=1:m
    if(C(j)==1)
        best=max(A(:,j));
        worst=min(A(:,j));
    else
        worst=max(A(:,j));
        best=min(A(:,j));
    end
    for i=1:n
        Opinion(i,j)=f(A(i,j),worst,best,1,5);
        if (Opinion(i,j)<5 && Opinion(i,j)>1)
            Opinion(i,j)=randi([floor(Opinion(i,j)-epsilon),ceil(Opinion(i,j)+epsilon)]);
        end
    end
end