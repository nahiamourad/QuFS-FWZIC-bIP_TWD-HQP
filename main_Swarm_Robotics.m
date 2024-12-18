clear
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%Information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This MATLAB code is associated to the paper entitled "Robust three-way 
% decisions based on ensembled multi-divergence measures with circular 
% quintic fuzzy sets for developing swarm robots in mechanised agricultural 
% operations" with DOI: https://doi.org/10.1016/j.eswa.2024.126102
% The paper is to be cited if the MATLAB functions in this folder are reused
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%Generate the Opinion Matrices Randomly
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Data=readmatrix("Robotics.xlsx",'Sheet','DecisionMatrix','Range','B3:H36');
%%sort(randi([1,5],1,7),'descend') %for criteria evaluation
% Opinion1=Generate_opinion(Data,ones(1,7));
% Opinion2=Generate_opinion(Data,ones(1,7));
% Opinion3=Generate_opinion(Data,ones(1,7));
% writematrix(Opinion1,"Robotics.xlsx",'Sheet','DecisionMatrix','Range','K3:Q36');
% writematrix(Opinion2,"Robotics.xlsx",'Sheet','DecisionMatrix','Range','T3:Z36');
% writematrix(Opinion3,"Robotics.xlsx",'Sheet','DecisionMatrix','Range','AC3:AI36');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%Read the Opinion Matrices
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Opinion1=readmatrix("Robotics.xlsx",'Sheet','DecisionMatrix','Range','K3:Q36');
Opinion2=readmatrix("Robotics.xlsx",'Sheet','DecisionMatrix','Range','T3:Z36');
Opinion3=readmatrix("Robotics.xlsx",'Sheet','DecisionMatrix','Range','AC3:AI36');
n_A=size(Opinion1,1);
label="T"+(1:n_A);  %%Name of the alternatives on the Figures

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%Fuzzy set
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
q=5;%%Quintic Fuzzy set
QuFN{5}=[0.95	0.10];
QuFN{4}=[0.75	0.30];
QuFN{3}=[0.55  0.50];
QuFN{2}=[0.40	0.65];
QuFN{1}=[0.15  0.90];
QuFN_best=[1 0 0];
QuFN_worst=[0 1 1];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%Criteria weights
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
EDM=readmatrix("Robotics.xlsx",'Sheet','criteria','Range','B3:H5');
[weight,EDM_fuzzy,EDM_agg,Scores]=FWZIC_SWARA(EDM,QuFN,'Circular_QuFN','score_C_QuFNs',-1);
writematrix([Scores;weight],"Robotics.xlsx",'Sheet','criteria','Range','B6');
writecell([EDM_fuzzy;EDM_agg],"Robotics.xlsx",'Sheet','criteria','Range','B10');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%Three ways decision
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sigma=0.05:0.1:1; %%The risk parameter in the TWD
Benefit=ones(size(weight)); %%All criteria are benefit type
Divergence={'Chen_1','Chen_2','Chen_3'};

sz_div=max(size(Divergence));
sz_sig=max(size(sigma));

[prob,rank]=deal(cell(1,sz_div));
[alpha,beta,regions]=deal(cell(sz_sig,sz_div));
results=cell(sz_div);
for j=1:sz_div
    for i_sig=1:sz_sig
        [result, region, DM_circular]=TWD_v2(Opinion1,Opinion2,Opinion3,Benefit,weight,sigma(i_sig),q,QuFN,QuFN_best,QuFN_worst,Divergence{j});
        if i_sig==1
            prob{j}=result(:,3);
            rank{j}=result(:,4);
            results{j}=[num2cell(prob{j}),num2cell(rank{j})];
        end
        alpha{i_sig,j}=result(:,end-1);
        beta{i_sig,j}=result(:,end);
        regions{i_sig,j}=region;
        results{j}=[results{j},num2cell(alpha{i_sig,j}),num2cell(beta{i_sig,j}),regions{i_sig,j}];
    end
end
for j=1:sz_div
    writecell(results{j},"Robotics.xlsx",'Sheet','TWD','Range',['B',num2str(4+(j-1)*(n_A+6))])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Ensemble TWD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ens_results,lambda, consensusIndex,trustLevel,ens_sigma]=Ensemble_TWD(prob,alpha,beta,n_A,sz_sig);
writematrix(lambda,"Robotics.xlsx",'Sheet','Ensemble','Range','C2');
writematrix([consensusIndex,trustLevel,ens_sigma],"Robotics.xlsx",'Sheet','Ensemble','Range','B5');
writecell(ens_results,"Robotics.xlsx",'Sheet','Ensemble','Range','B8');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Sensitivity Analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_senario=10; %%Number of scenarios for sensitvity analysis

[W,elasticity,boundry,delta]=genrate_weight(weight,num_senario-2);
writematrix([W;elasticity],"Robotics.xlsx","Sheet",'Senstivity',"Range",'B3')
writematrix(boundry,"Robotics.xlsx","Sheet",'Senstivity',"Range",'F17')

sen_rank=zeros(n_A,num_senario);
sen_regions=cell(n_A,num_senario*sz_sig);
for tr=1:num_senario
    for j=1:sz_div
        for i_sig=1:sz_sig
            [sen_result,~,~]=TWD_v2(Opinion1,Opinion2,Opinion3,Benefit,W(tr,:),sigma(i_sig),q,QuFN,QuFN_best,QuFN_worst,Divergence{j});
            alpha{i_sig,j}=sen_result(:,end-1);
            beta{i_sig,j}=sen_result(:,end);
        end
        prob{j}=sen_result(:,3);
    end
    [sen_ens_results,~, ~,~,~]=Ensemble_TWD(prob,alpha,beta,n_A,sz_sig);
    sen_rank(:,tr)=cell2mat(sen_ens_results(:,2));
    sen_regions(:,(tr-1)*sz_sig+1:tr*sz_sig)=sen_ens_results(:,5:3:end);
    FigName=['regions_S',num2str(tr)];
    figure('Name',FigName)
    TWD_graphing_v2(sen_rank(:,tr),sen_regions(:,(tr-1)*sz_sig+1:tr*sz_sig),sigma,label)
    saveas(gcf,[FigName, '.tif'],'tiffn')
end
close all

writematrix(sen_rank,"Robotics.xlsx","Sheet",'Senstivity',"Range",'B23');
writecell(sen_regions,"Robotics.xlsx","Sheet",'SenstivityRegions',"Range",'B3');
%%Correlation
r=sen_rank(:,1);
R=sen_rank(:,2:end);
[cc1,cc2,cc3]=deal(zeros(num_senario-1,1));
for i=1:num_senario-1
    cc1(i)=corr(r,R(:,i),'type','Spearman');
    [cc2(i),cc3(i)]=correlation_1(r,R(:,i));
end
cc=[cc1, cc2, cc3];
writematrix(cc,"Robotics.xlsx",'Sheet','Senstivity','Range','P25')