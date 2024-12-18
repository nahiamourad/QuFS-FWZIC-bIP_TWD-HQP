function agg_FNs=agg_qROF(FNs,w)
%%% FNs is a column array of cells containing the q-Runge orthopair Fuzzy numbers to be aggregated
%%% w is the weight of aggregation
q=5;  %%%Restrict the FNs to quintic

if(isrow(FNs))
    FNs=FNs';
end
if(isrow(w))
    w=w';
end
M=cell2mat(FNs);
agg_FNs=[nthroot(1-prod((1-M(:,1).^q).^w),q),prod(M(:,2).^w)];
end
