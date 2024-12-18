function outrank = rankWithDuplicates(data,mode)
if nargin==1
    mode='descend';
end
[~,b]=size(data);
if b==1
    data=data';
end
% Sort data
[srt, idxSrt]  = sort(data,mode);
% Find where are the repetitions and negate
idxRepeat = [false diff(srt) == 0];
% Loop through where there are duplicates and maintain the rank. 
% I'm not sure if this is necessary but it's the only way I could get it
% done.
rnk = 1:numel(data);
loopidx=find(idxRepeat>0);
for i=loopidx
    rnk(i)=rnk(i-1);
end
% Return order according to original sort
outrank(idxSrt)=rnk;