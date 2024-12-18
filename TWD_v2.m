function [result,region,DM_circular]=TWD_v2(DM1,DM2,DM3,Benefit,Weight,sigma,q,Fuzzy,fuzzy_best,fuzzy_worst,divergence_name)
%%%%Inputs and Outputs

%%%%%Size check
[n,m]=size(DM1);

if ~isequal(size(DM2),size(DM1),[n,m])
    disp('Decision MAtrices size should be same!')
    return
end

if ~isequal(size(Benefit,2),size(Weight,2),m)
    disp('Weight size is not compatible with the TWD_v2 function!')
    return
end

%%%%%Fuzification of the three Decision Matrices
DM1_fuzzy=Fuzzification(DM1,Fuzzy);
DM2_fuzzy=Fuzzification(DM2,Fuzzy);
DM3_fuzzy=Fuzzification(DM3,Fuzzy);


%%%%Building Circular q-ROF
%%%%then Calculating Divergence
DM_circular=cell(n,m);
[div_pos,div_neg,div_neg_pos]=deal(zeros(n,m));
for i=1:n
    for j=1:m
        DM_circular(i,j)=Circular_qRFNs({DM1_fuzzy{i,j};DM2_fuzzy{i,j};DM3_fuzzy{i,j}},q);
        if(Benefit(j)==1)
            fuzzy_pos=fuzzy_best;
            fuzzy_neg=fuzzy_worst;
        else
            fuzzy_pos=fuzzy_worst;
            fuzzy_neg=fuzzy_best;
        end
        divergence=str2func(divergence_name(1:end-2));
        divergence_parameter=str2double(divergence_name(end));
        div_pos(i,j)=divergence(DM_circular{i,j},fuzzy_pos,divergence_parameter);
        div_neg(i,j)=divergence(DM_circular{i,j},fuzzy_neg,divergence_parameter);
        div_neg_pos(i,j)=divergence(fuzzy_pos,fuzzy_neg,divergence_parameter);
    end
end

%%%Calculate Conditional Probability
S=(div_pos./div_neg_pos)*Weight';
QQ=S./max(S);
pr=1-QQ;

%%%Calculate the thresholds alpha and beta
Q_max=div_pos*Weight';
Q_min=div_neg*Weight';
alpha=((1-sigma).*Q_max)./(((1-sigma).*Q_max)+(sigma.*Q_min));
beta=((sigma).*Q_max)./(((sigma).*Q_max)+((1-sigma).*Q_min));

alpha_av=mean(alpha);
beta_av=mean(beta);

%%%Regions
region=cell(n,1);
region(pr>=alpha_av)={'POS'};
region(and(pr>beta_av,pr<alpha_av))={'BND'};
region(pr<=beta_av)={'NEG'};

% for i=1:n
%     if pr(i)>=alpha_av
%         region{i}='POS';
%     elseif pr(i)>beta_av && pr(i)<alpha_av
%         region{i}='BND';
%     elseif pr(i)<=beta_av
%         region{i}='NEG';
%     end
% end

%%%Rank alternatives
rank=rankWithDuplicates(pr);
result=[S QQ pr rank' alpha beta];
end