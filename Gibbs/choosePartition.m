function  partition  = choosePartition(W_k,partition,point)
% INPUT: Hypotheses is all the possible partitions when the chosen
% measurment is placed in each of them
% OUTPUT: Given the weights, a single partition is chosen from the Hypotheses.
W_k_norm=W_k/sum(W_k);
j = sum(cumsum(W_k_norm)<rand())+1; % pick one cluster at random
partition.Clusters{j}=partition.Clusters{j}.addPoint(point);

end

