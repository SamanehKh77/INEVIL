 function [Distance]=EvaluateDisrtance(Data,model,nmix)
 load ubm_pets
 trials=[1 1];
 BB={(Data)'};
 [npoints,dimens]=size(Data);
           D= score_gmm_trials({model},BB, trials, ubm);
                            estpp = (1/nmix)*ones(1,nmix);
       Distance=D+(dimens*sum(log(estpp))) +(dimens + 0.5)*nmix*log(npoints);
% % %  wf=model1.w;
% % % mf=model1.mu;
% % % vf=model1.sigma;
% % %  wg=model2.w;
% % % mg=model2.mu;
% % % vg=model2.sigma;
% % %  for i=1:size(mf,2)
% % %       for j=1:size(mg,2)
% % %       Dgf(i,j)=wg(i)*0.5*(sum(((1./vf(:,j)).*vg(:,i)))+((mf(:,j)-mg(:,i))'*diag(1./vf(:,j)))*(mf(:,j)-mg(:,i))+(sum(log(vf(:,j)))-sum(log(vg(:,i))))-size(mf,1));  
% % % %      end
% % %   Dfg(i,j)=wf(i)*0.5*(sum(((1./vg(:,j)).*vf(:,i)))+((mg(:,j)-mf(:,i))'*diag(1./vg(:,j)))*(mg(:,j)-mf(:,i))+(sum(log(vg(:,j)))-sum(log(vf(:,i))))-size(mg,1));  
% % %      end
% % %  end
% % %   Distance=mean(diag(Dgf+Dfg));
