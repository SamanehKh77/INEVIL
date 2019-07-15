%function [predicted_label,prob_estimates]=Gaussianpredict(label, data, model,Threshold)
function [prob_estimates]=Gaussianpredictalpha(data, model,COEF,ubm)
model1={};
trials=[1 1];
Coef=[];
BB={data'};

for i=1:size(model,1)
    if isempty (model{i})==0
        model1{end+1}=model{i};
        Coef(end+1,1)=COEF(i);
    end
end
model=model1;
%-----------------For Real----------
if isempty (model)
    prob_estimates=zeros(1,size(data,1));
else
    for i=1:size(model,2)
        for j=1:size(data,1)
            BB={(data(j,:))'};
            gmmScores(i,j) = score_gmm_trials({model{i}},BB, trials, ubm);
        end
    end
%     Coef=1
    prob_estimates= bsxfun(@times,Coef, gmmScores);
    
end
prob_estimates=sum(prob_estimates,1);
%-------------------------------------------
%--------------------For Synthetic ----------------
% if isempty (model)
%     prob_estimates=zeros(1,size(data,1));
% else
%     for i=1:size(model,2)
%       % prob(i,:)=pdf(model{i},data)
%                 %--------------
% %               % prob(i,:)=pdf(model{i},data);
%         %load  ubm
% %                 ubm=gmdistribution(ubm_synthetic.mu,ubm_synthetic.sigma,ubm_synthetic.w);
% %         %  mix = gmm(size(Data,2),2,'diag')
% % %  
% % %         mix = gmminit(mix,Data,options)
% % %    mix= gmmem(mix,Data, options)
% %         
% % %         load  ubm_synthetic
%        prob(i,:)=log(pdf(model{i},data))-log(pdf(ubm,data));
%        
% %         nnn
%         %------------
%             end
%          prob_estimates= bsxfun(@times,Coef,prob);
% end
%             prob_estimates=sum(prob_estimates,1);

% 
%%%%%