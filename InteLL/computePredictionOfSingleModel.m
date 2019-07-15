%function  [prob_estimates]=computePredictionOfSingleModel(model,classes,currBatchOfData,Threshold)
function  [prob_estimates]=computePredictionOfSingleModel(model,currBatchOfData,COEF,ubm)
%label=currBatchOfData(:,end);
data=currBatchOfData(:,1:end-1);
%[prob_estimates]=Gaussianpredict(classes, data, model,Threshold);
[prob_estimates]=Gaussianpredictalpha(data,model,COEF,ubm);
%%%