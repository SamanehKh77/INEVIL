function [Ensemble,D,FLIPFLOP,model,update_number,discard_number,STAR]=FindDistancesortupdate(Ensemble,model,Threshold1,Threshold2,update_number,discard_number,lastData,nmix)
D=cell(1,max(size(Ensemble.models,2),size(model,2)));
%D=zeros(1,max(size(Ensemble.models,2),size(model,2)));
FLIPFLOP=zeros(1,max(size(Ensemble.models,2),size(model,2)));
 STAR=zeros(1,max(size(Ensemble.models,2),size(model,2)));
 temp=find(~cellfun('isempty',model));%find models for current timeslonnz(temp)
for k=1:nnz(temp)
    if  (size(model,2)>size(Ensemble.models,2))
      D{1,temp(k)}=[];
        % D(1,temp(k))=0;
        FLIPFLOP(1,temp(k))=1;
         STAR(1,temp(k))=3;
    elseif sum(~cellfun('isempty',Ensemble.models(:,temp(k))))==0
      D{1,temp(k)}=[];
     %  D(1,temp(k))=0;
        FLIPFLOP(1,temp(k))=1;
         STAR(1,temp(k))=3;
    else
        lixo=Ensemble.models(:,temp(k)); %pick the corresponding micro-ensemble
        for j=1:size(lixo,1)
            if cellfun('isempty',lixo(j))
                distancematrix(j)=inf;
            else
                %///////////////////////////////////distancematrix(j)=EvaluateDisrtance(model{:,temp(k)},lixo{j});
                distancematrix(j)=EvaluateDisrtance(lastData{:,temp(k)},lixo{j},nmix);
            end
        end
        [absloute,order]=min(distancematrix);
                if le(absloute,Threshold1)
            lixo{order,:}={};
            Ensemble.models(:,temp(k))=lixo;
            discard_number=discard_number+1;
            STAR(1,temp(k))=1;
        elseif ge(absloute,Threshold1)&& le(absloute,Threshold2)
                        model{:,temp(k)}=Updatemodel(lixo{order,:},model{:,temp(k)});
            update_number=update_number+1;
            lixo{order,:}={};
             Ensemble.models(:,temp(k))=lixo;
               STAR(1,temp(k))=2;
                else
                     STAR(1,temp(k))=3;
                   
        end
        FLIPFLOP(1,temp(k))=1;
      D{1,temp(k)}=distancematrix;
     %  D{1,temp(k)}=mean(distancematrix(isfinite(distancematrix))); 
     %D(1,temp(k))=mean(distancematrix(isfinite(distancematrix))); 
        distancematrix=[];
    end
end

