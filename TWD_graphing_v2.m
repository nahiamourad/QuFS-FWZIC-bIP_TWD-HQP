function TWD_graphing_v2(ranks,regions,sigma,label)
if iscolumn(sigma)
    sigma=sigma';
end
if iscolumn(label)
    sigma=label';
end
n=size(sigma,2);%%% number of different sigmas
m=size(label,2);%%% number of alternatives

if(size(ranks,2)~=n)
    ranks=repmat(ranks,1,n); %%%repeat the ranks for diffrenet sigma
end
    
for i_sig=1:n
    A1=ranks(:,i_sig);
    DD1=regions(:,i_sig);
    [~,dd1]=sort(A1);
    DD=DD1(dd1);
    label1=label(dd1);
    h=barh(i_sig,ones(1,m),'stacked');
    for i=1:m
        if strcmp(DD{i},'POS')
            h(i).FaceColor ='green';% rgb
            h2(1)=h(i); %%% h2 to dermine the color of the legend
        elseif  strcmp(DD{i},'BND')
            h(i).FaceColor =  [0.6 0.9 1]; % rgb
            h2(2)=h(i);
        elseif strcmp(DD{i},'NEG')
            h(i).FaceColor ='r'; % rgb
            h2(3)=h(i);
        end
    end
    %%
    for i=1:m
        t=text(i-0.5,i_sig-0.2,label1{i},'FontSize',5,'FontWeight','bold');
        t.Rotation = 90;
    end
    xlim([0 m])
    hold on
end

%%% Rank plot
h1=barh(0,ones(1,m),'stacked');
for i=1:m
    h1(i).FaceColor = [0.1 1 1];% rgb
    t=text(i-0.5,-0.2,num2str(i),'FontSize',7,'FontWeight','bold');
    t.Rotation = 90;
end
%%%% sigma plot
for i=1:n
    text(-3,i,['\sigma=',num2str(sigma(i))],'FontSize',7,'FontWeight','bold');
end

%%%  legend and x-axis
legend(h2,{'POS','BND','NEG'},'Location','best','NumColumns',3)
xlabel('RANK')
hold off
set(gca,'xtick',[],'ytick',[])
end