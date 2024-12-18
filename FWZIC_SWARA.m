function[weight,EDM_fuzzy,EDM_agg,Scores]=FWZIC_SWARA(EDM,FNs,agg_function,score_function,min_score)
%%%Input: EDM: Expert Decision Matrix.
%%%       FNs: Array of cells containing fuzzy numbers in order.
%%%       agg_function: Name of the aggregation function to be used
%%%       score_function: Name of the score function to be used
%%%       min_score: Is the lower bound of the score function
%%%Output: Weights based on FWZIC and SWARA
[s,n]=size(EDM);
EDM_fuzzy=Fuzzification(EDM,FNs);

EDM_agg=cell(1,n);
Scores=zeros(1,n);
agg_fun=str2func(agg_function);
score_fun=str2func(score_function);
for j=1:n
    EDM_agg{j}=agg_fun(EDM_fuzzy(:,j),ones(1,s)/s);
    Scores(j)=score_fun(EDM_agg{j});
end

if(Scores(Scores<0))
    results=swara(Scores-min_score);
else
    results=swara(Scores);
end

weight=results(end,:);
end