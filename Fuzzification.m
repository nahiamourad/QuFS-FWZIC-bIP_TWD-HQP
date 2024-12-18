function [EDM_Fuzzy]=Fuzzification(EDM,Fuzzy)
%Input: EDM is a matrix of crips to be fuzzified
%       Fuzzy ia a cell containg the chosen fuzzy numbers
%Output: EDM_Fuzzy a cell same size of EDM replacing each crisp with it's corresponding FN
EDM_Fuzzy=cell(size(EDM));
n=max(size(Fuzzy));
for i=1:n
    EDM_Fuzzy(EDM==i)=Fuzzy(i);
end