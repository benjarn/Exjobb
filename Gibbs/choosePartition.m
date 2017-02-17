function  partition  = choosePartition(W_k_log,partition,point)
% INPUT: Weights W_k of all hypotheses is the possible partitions when the chosen
% measurment is placed in each of them
% OUTPUT: Given the weights, a single partition is chosen from the Hypotheses.
%W_k_norm=W_k/sum(W_k);
% W_k_norm=-W_k/sum(W_k)+2/length(W_k);
% [~,j]=max(W_k_norm);
W_k_log_sum=W_k_log(1);
for i=2:length(W_k_log)
    if W_k_log(i)>W_k_log_sum
        W_k_log_sum=W_k_log(i)+log1p(exp(W_k_log_sum-W_k_log(i)));
    else
        W_k_log_sum=W_k_log_sum+log1p(exp(W_k_log(i)-W_k_log_sum));
    end
end
W_k_log_norm=W_k_log-W_k_log_sum;
W_k_norm=exp(W_k_log_norm);
        if(any(isnan(W_k_norm))|| all(W_k_norm==0))
            pause(0.1);
        end
j = sum(cumsum(W_k_norm)<rand())+1; % pick one cluster at random
%[~,j]=max(W_k);
if(j==length(W_k_log))
    partition = partition.addCluster(GibbsCluster());
end
partition.Clusters{j}=partition.Clusters{j}.addPoint(point);
end

