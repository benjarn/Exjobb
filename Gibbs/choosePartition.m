function  Partition_j  = choosePartition( Hypotheses )
% INPUT: Hypotheses is all the possible partitions when the chosen
% measurment is placed in each of them
% OUTPUT: Given the weights, a single partition is chosen from the Hypotheses.
W_k_hyp=zeros(1,length(Hypotheses));

for i=1:length(Hypotheses)
    W_k_hyp(i)=Hypotheses{i}.Weight; % Det här är långsamt men svårt att göra utan loop
end

W_k_norm=W_k_hyp/sum(W_k_hyp);
j = sum(cumsum(W_k_norm)<rand())+1; % pick one cluster at random

Partition_j=Hypotheses{j};
end

