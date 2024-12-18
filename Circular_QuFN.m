function c_FN=Circular_QuFN(FNs,~)
%%%%Input is a column of QuFNs to be transformed to a Circular Quintic
%%%%Fuzzy number.
M=cell2mat(FNs);
q=5;  %%%Restrict the FNs to quintic

n=size(M,2);

if(n~=2)
    disp('Error in the Circular_QuFN function')
    return
end


mu=nthroot(mean(M(:,1).^q),q);
nu=nthroot(mean(M(:,2).^q),q);


r_Mat=abs(mu-M(:,1)).^q+abs(nu-M(:,2)).^q;
r=min(max(nthroot(r_Mat,q)),1);

c_FN=[mu,nu,r];
end