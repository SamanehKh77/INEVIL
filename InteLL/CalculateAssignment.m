function Best_assignment=CalculateAssignment(Final_label,Real_label);
U=unique(Real_label);
V=unique(Final_label);
for i=1:size(U,1)-1
    for j=1:size(V,1)-1
              %Best_assignment(i,j)=(nnz((Final_label==V(j+1,1)).*(Real_label==U(i+1,1))));
            Best_assignment(i,j)=nnz(Real_label)-(nnz((Final_label==V(j+1,1)).*(Real_label==U(i+1,1))));
    end
end

% % % % for j=1:size(U,1)-1
% % % % 
% % % % for i=1:size(V,1)-1
% % % % Best_assignment(j,i)=nnz(((Final_label==V(i+1,1))>0)-((Real_label==U(j+1,1))>0));
% % % % Best_assignment(j,i)=nnz(((Final_label==V(i+1,1))>0)-((Real_label==U(j+1,1))>0));
% % % % Final_label(Real_label==U(j+1,1))
% % % % Best_assignment(j,i)=nnz(Final_label(Real_label==U(j+1,1))-V(i+1,1));
% % % % 
% % % % end
% % % % end
