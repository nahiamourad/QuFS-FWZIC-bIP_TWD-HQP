function score=score_C_QuFNs(QuFNs)
%This functions calculate the score of an array of Circular Quintic fuzzy numbers
%where the first column contains the membership function and the second
%column contains the non-membership function

if(size(QuFNs,2)~=3)
    disp('Check the dimension of the matrix in the score function')
    return
end
score=QuFNs(:,1).^5-QuFNs(:,2).^5-QuFNs(:,3).^5;
end
