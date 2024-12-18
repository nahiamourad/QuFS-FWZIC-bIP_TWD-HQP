function [ens_results,lambda, consensusIndex,trustLevel,sigma]=Ensemble_TWD(prob,alpha,beta,n_A,sz_sigma)

%%Half-Quadratic Programming to get the weights for each divergence
R=cell2mat(prob);
[ens_prob,finalRanking,lambda, consensusIndex,trustLevel,sigma] = EnsembleRanking(R);
finalRanking=n_A+1-finalRanking;

%%Weighted sum on alpha and beta
ens_alpha=cell2mat(alpha)*lambda';
ens_alpha=reshape(ens_alpha,n_A,sz_sigma);
ens_beta=cell2mat(beta)*lambda';
ens_beta=reshape(ens_beta,n_A,sz_sigma);

%%%Regions
ens_results=[num2cell(ens_prob),num2cell(finalRanking)];
ens_region=cell(n_A,sz_sigma);

ens_alpha_av=mean(ens_alpha);
ens_beta_av=mean(ens_beta);

for i_sigma=1:sz_sigma
    ens_region(ens_prob>=ens_alpha_av(i_sigma),i_sigma)={'POS'};
    ens_region(and(ens_prob>ens_beta_av(i_sigma),ens_prob<ens_alpha_av(i_sigma)),i_sigma)={'BND'};
    ens_region(ens_prob<=ens_beta_av(i_sigma),i_sigma)={'NEG'};

%     for i=1:n_A
%         if ens_prob(i)>=ens_alpha_av(i_sigma)
%             ens_region{i,i_sigma}='POS';
%         elseif ens_prob(i)>ens_beta_av(i_sigma) && ens_prob(i)<ens_alpha_av(i_sigma)
%             ens_region{i,i_sigma}='BND';
%         elseif ens_prob(i)<=ens_beta_av(i_sigma)
%             ens_region{i,i_sigma}='NEG';
%         end
%     end
    ens_results=[ens_results,num2cell(ens_alpha(:,i_sigma)),num2cell(ens_beta(:,i_sigma)),ens_region(:,i_sigma)];
end
end