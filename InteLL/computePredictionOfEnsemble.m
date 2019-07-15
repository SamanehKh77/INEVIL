function [prob_estimates] = computePredictionOfEnsemble(currBatchOfData,ensembleOfModels,total_number_classes,COEF,ubm)
models=ensembleOfModels.models;
%%%
% classNo=ensembleOfModels.classNo;
% classes=ensembleOfModels.classes;
prediction_probability=cell(size(models,1),1);
% A=1:max(classNo);
 %for i=1:max(classNo)
for i=1:size(models,2)
    %for i=1:total_number_classes
         %prob_estimates(i,:)=computePredictionOfSingleModel(models(:,i),i,currBatchOfData,Threshold);
prob_estimates(i,:)=computePredictionOfSingleModel(models(:,i),currBatchOfData,COEF,ubm);
end
