clc
clear all
close all;
num=1;
Batch_size=20;
LIMITmin=-inf;
alpha=0.98;
sss=0;
Threshold1=-inf;

starii=[];

load('D:\LEVIS\video_clips_pca\label__PETsView1.mat')
label=label__PETsView1;
load('D:\LEVIS\NEVIL1.0\UBM\FK_Data_PETsView1.mat')
Data=FK_Data_PETsView1;
final_niter = 10;
nmix=2;Thresholdtemp=0.01;
ds_factor = 2;
FK_background_ubm_projected=[Data{6};Data{7};Data{8}];
FK_background_ubm_projected=FK_background_ubm_projected(sum(FK_background_ubm_projected,2)~=0,:);
Data(6:8)=[];%Data(7)=[];Data(8)=[];
final_niter = 10;
nmix =2;        % In this case, we know the # of mixtures needed
ds_factor = 2;
% FK_background_ubm_projected=double(FK_background_ubm');
FK_background_ubm_projected=FK_background_ubm_projected(:,1:200);
FK_UBMBackground_projected={FK_background_ubm_projected'};
ubm = gmm_em(FK_UBMBackground_projected,nmix, final_niter, ds_factor,12);
clear FK_UBMBackground_projected;clear final_niter;clear ds_factor;
label(6:8)=[];
LIMITmin=-inf;
oldModelNO=[];
ModelNO=[];
sss=0;
DIS=[];
UP=[];
PR=[];
Threshold1=-inf;
save ubm_pets ubm

for  Threshold2=-300:50:750%117%500%6:50:200%0.5:2 
    % Threshold2=Threshold1;
    num=1;
    %-------------528
    for LIMITmax=0:20:100%0:0.4:1.5%
        update_number=0;
        discard_number=0;
        flag=0;
        novelty=0;
        ensembleOfModels={};
        DISTNCE={};
        FLAG=[];
        FLAGTEM=[];
        counter=1;
        MAXI=max(label);
        temp=Data{1,1};
        Num_obs=size(temp,1);
        limit=floor((Num_obs-counter)/Batch_size);
        Total_num_Batches=0;
        Num_Manual_labeled=0;
        temp=[];
        %---------
        label_limit=max(label);
        %-----------------
        X1=1:max(label);
        %--------------------------------------------------------
        %-------------------Start-------------------------------
        q=1;
        for p=1:floor((Num_obs-counter)/Batch_size)
            lixo=[];
            address=[];
            flag=0;
            currBatchOfData=[];
            for j=1:size(Data,2)
               tt=Data{1,j};
                tt=tt(:,1:200);
                               if p==limit
                    CB=tt(counter:end,:);
                else
                    CB=tt(counter:counter+Batch_size-1,:);
                end
                total=0;
                CB_temp=[];
                for k=1:Batch_size
                    if sum(CB(k,:),2)~=0;
                        total=total+1;
                     %%%%   CB_temp=[CB_temp;CB(k,:) label(j)];
                          %%%%%%%%  CB_temp=[CB_temp;CB(k,:) label(j)];
                        CB_temp=[CB_temp;CB(k,:)];
                    end
                end
                if total<6
                    total=0;
                    CB_temp1=[];
                else
                     CB_temp=mean(CB_temp);
                    % CB_temp=sum(CB_temp)./sum(CB_temp(:));
                    CB_temp1=[CB_temp label(j)];
                end
                temporal_Data{1,j}=CB_temp1;
                Frame_per_Batch(j)=total;
                currBatchOfData=[currBatchOfData;CB_temp1];
               
            end
            counter=counter+Batch_size;
            if sum(Frame_per_Batch)~=0
                Batches_per_spam(q,:)=Frame_per_Batch;
                
                %Operator_label=[];
                if q==1
                    current_label=unique((currBatchOfData(:,end))');
                    total_number_classes=max(unique(current_label));
                    label_time=label.*(Batches_per_spam(q,:)>0);
                    Real_label=label_time;
                    [model,Freq{1},lastData] = TrainGaussian(currBatchOfData(:,end),currBatchOfData(:,1:end-1),nmix,max(unique(current_label)),ubm);
                    %classNo=size(unique(currBatchOfData(:,end)),1);
                                        classNo=nnz(unique(label_time));
                    classes={(unique(currBatchOfData(:,end)))'};
                    ensembleOfModels.models=model;
                    starii(q)=counter-Batch_size;
                    ensembleOfModels.oldmodels=model;
                    ensembleOfModels.classNo=classNo;
                    ensembleOfModels.classes=classes;
                    currBatchOfData=[];
                    FLAG=3*(Batches_per_spam(q,:)>0);
                
                    % Accuracy(1)=1;
                    Num_Manual_labeled=sum(nnz(Batches_per_spam(q,:)));
                    Total_num_Batches=Num_Manual_labeled;
                    disp('------------------------')
                    limitation=max(label_time(:));
                    
                    Final_label(1,:)=Real_label(1,:);
                    
                else
                    %  Operator_label=label(Frame_per_Batch.*label>0);
                    if q==2
                        COEF=1;
                    end
                    
                    prediction_probability=computePredictionOfEnsemble(currBatchOfData,ensembleOfModels,label_limit,COEF,ubm);
                    %---------------Batches----
                    COEF=COEF.*(1-alpha);
                    COEF(end+1,1)=alpha;
                    divider=1;
                    [C,M,B]=find(Batches_per_spam(q,:));
                    Prediction_temp=zeros(1,size(Data,2));
                    Operator_label_temp=zeros(1,size(Data,2));
                    new_class_label_temp=zeros(1,size(Data,2));
                    frames=Frame_per_Batch(Frame_per_Batch>0);
                    [A,B]=find(Frame_per_Batch);
                    ClassNO=label_limit;
                    for r=1:nnz(Frame_per_Batch)%size(Frame_per_Batch,1)
                        temporal=Frame_per_Batch(Frame_per_Batch>0);
                       % tempo2=prediction_probability(:,divider:Frame_per_Batch(B(r))+divider-1);
                       % temp5=tempo2';
                        tempo2=prediction_probability(:,r);
                        temp5=tempo2';
                       % AAA(p,M(r))={temp5};
                        %%%%X1=1:ClassNO;
                        X1=1:size(temp5,2);
                       % Structure.Original_frames(p,r)={[X1;temp5]};
                        %   temp5=scale(temp5);
                       % CCC(p,M(r))={temp5};
                        %-------------------------------------------
                        temp5(temp5==0)=-inf;
                         temp7=temp5;
                        % BCL=max(temp7);
                        BCL=max(temp5);
                        %----------------------------------------------------
                        if BCL>LIMITmax
                            
                            [prob_max,Ass_label]=max(temp7);
                                                        Prediction_temp(M(r))=Ass_label;
                            Prediction(q,M(r))=Ass_label;
                        elseif (BCL<LIMITmax)&& (BCL>LIMITmin)
                            %%%%%%% else
                            flag=1;
                            Operator_label_temp(M(r))=label(1,M(r));
                            Operator_label(q,M(r))=label(1,M(r));
                            lixo(1,end+1)=label(1,M(r));
                            address(1,end+1)=M(r);
                                                      Num_Manual_labeled=Num_Manual_labeled+1;
                        else
                            new_class(q,M(r))=1;
                            novelty=novelty+1;
                            %%%%%%new_class_label_temp(M(r))=label_limit+1;
                            limitation=limitation+1;
                            new_class_label_temp(M(r))=limitation;
                            
                        end
                        Real_label(q,M(r))=label(1,M(r));
                        divider=Frame_per_Batch(M(r))+divider;
                    end
                    total_Num_Manual_labeled(q)=Num_Manual_labeled;
                    Final_label(q,:)=Prediction_temp+Operator_label_temp+new_class_label_temp;
                    if   flag==1
                        Best_assignment=CalculateAssignment(Final_label,Real_label);
                        [Matching,Cost]= Hungarian(Best_assignment);
                        U=unique(Real_label);
                        U=U(2:end);
                        V=unique(Final_label);
                        V=V(2:end);
                        for j=1:size(lixo,2)
                            [x,y]=find(Matching(U==lixo(j),:)==1);
                            if sum(x+y)>0
                                Final_label(end,address(j))=V(y);
                            end
                                                    end
                    end
                    
                    flag=0;
                 
                    last_col=[];
      
                    for i=1:nnz(Frame_per_Batch)
                       % last_col=[last_col;Final_label(q,B(i))*ones(frames(i),1)];
                       last_col=[last_col;Final_label(q,B(i))];
                    end
                    currBatchOfData(:,end)=last_col;
                    [model,Freq{p},lastData]=TrainGaussian(currBatchOfData(:,end),currBatchOfData(:,1:end-1),nmix,max(unique(Final_label)),ubm);
                  [ensembleOfModels,D,FLIPFLOP,model,update_number,discard_number,STAR]=FindDistancesortupdate(ensembleOfModels,model,Threshold1,Threshold2,update_number,discard_number,lastData,nmix);
                    %  ensembleOfModels.models=ensembleOfModelsNEW.models;
                    %   [D,FLIPFLOP]=FindDistance(ensembleOfModels,model, ThresholdPrune);
                    FLAG(end+1,1:size(model,2))=STAR;
                                        FLAGTEM(end+1,:)=counter;
                    DISTNCE(end+1,1:size(model,2))=D;
                    ensembleOfModels.oldmodels(end+1,1:size(model,2))=model;
                    model(:,FLIPFLOP==0)=cell(1,1);
                      starii(q)=counter-Batch_size;
                    ensembleOfModels.models(end+1,1:size(model,2))=model;
                end
                q=q+1;
            end
        end
        oldModelNO(num)=nnz(~cellfun('isempty', ensembleOfModels.oldmodels));%find models for current timeslonnz(temp)
        ModelNO(num)=nnz(~cellfun('isempty', ensembleOfModels.models));%find models for current timeslonnz(temp
        Annotation(num)=Num_Manual_labeled/nnz(Batches_per_spam);
        %     Accuracy(num)=1-(nnz(Final_label-Real_label)/nnz(Batches_per_spam))
        Best_assignment=CalculateAssignment(Final_label,Real_label);
        [Matching,Cost] = Hungarian(Best_assignment);
        trueM=nnz(Batches_per_spam)*nnz(Matching)-Cost;
        ACC(num)=1-(nnz(Final_label-Real_label)/nnz(Batches_per_spam))
        Accuracy(num)=(trueM/nnz(Batches_per_spam));
        Threshold(num)=LIMITmax;
        update_NO(num)=update_number;
        discard_NO(num)=discard_number;
        num=num+1;
    Final_label=[];
       Real_label=[];
        clear label_limit
        clear  novelty
       clear ensembleOfModels
        clear  ClassNO
      clear DISTNCE
        
    end
    sss=sss+1
    Annotation=[0 Annotation 1]
    ANN(sss,:)=Annotation
    Accuracy=[0 Accuracy 1]
    ACCu(sss,:)=Accuracy
    ALC(sss)=trapz(Annotation,Accuracy)
    
  %  DIVERSITY(sss)=
    discard_NO./oldModelNO
    discard_percentge(sss)=mean(discard_NO./oldModelNO)
    DIS(sss,:)=(discard_NO)./oldModelNO;
    update_percentge(sss)=mean((update_NO)./oldModelNO)
    UP(sss,:)=(oldModelNO-ModelNO)./oldModelNO;
    clear Accuracy
    clear Annotation
    prune_percentage(sss)=mean((oldModelNO-ModelNO)./oldModelNO)
    PR(sss,:)=(oldModelNO-ModelNO)./oldModelNO;
    
end

plot(prune_percentage,ALC,'-or','linewidth',1.8)
title('SAVIOT overlapped')
xlabel('Updating(%)')
ylabel('ALC')
axis([0 1 0 1])
grid on;
hold on
