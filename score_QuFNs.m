function score=score_QuFNs(QuFNs)
%This functions calculate the score of an array of Quintic fuzzy numbers
%where the first column contains the membership function and the second
%column contains the non-membership function
% as defined in https://doi.org/10.1016/j.dajour.2024.100449
if(size(QuFNs,2)~=2)
    disp('Check the dimension of the matrix in the score function')
    return
end
score=QuFNs(:,1).^5.*(2-QuFNs(:,1).^5-QuFNs(:,2).^5);
end
