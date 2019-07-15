% function [model]= TrainGaussian(label,Data,num_gaussian,number,ubm)
function [model,Freq,lastData]= TrainGaussian(label,Data,num_gaussian,number,ubm)
 Freq=histc(label,number);
map_tau =0.8;
config = 'mvw';
for i=1:number
%     lastData.Data=Data(label==i,:);
%     lastData.label=i;
lastData{:,i}=Data(label==i,:);

   if isempty(Data(label==i,:))
      model{1,i}= [];
        else
temp= mapAdapt({(Data(label==i,:))'}, ubm, map_tau, config);
  temp.number=size(Data(label==i,:),1);
  model{1,i}=temp;
   end
    
end
