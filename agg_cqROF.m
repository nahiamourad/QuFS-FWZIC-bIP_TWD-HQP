function agg_FNs=agg_cqROF(FNs,w)
%%% FNs is a column array of cells containing the circular q-Runge orthopair Fuzzy numbers to be aggregated
%%% w is the weight of aggregation
q=5;  %%%Restrict the FNs to quintic

if(isrow(FNs))
    FNs=FNs';
end
if(isrow(w))
    w=w';
end

M=cell2mat(FNs);
if(size(M,2)~=3)
    disp('Error in agg_cqROF: The fuzzy numbers are not circular')
    return
end
agg_FNs=[nthroot(1-prod((1-M(:,1).^q).^w),q),prod(M(:,2).^w),prod(M(:,3).^w)];
end
