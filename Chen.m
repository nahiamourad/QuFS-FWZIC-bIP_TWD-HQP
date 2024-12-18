function [distance]=Chen(v1,v2,beta)
n=3;    %This is because we're considering cirular Fuzzy numbers (membership, non-membership, raduis)
q=5;    %This is because we're considering Quintic fuzzy numbers
distance=sum(abs(v1.^q-v2.^q).^beta);
distance=nthroot(distance/n,beta);
end