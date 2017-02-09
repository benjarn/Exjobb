function [ W_k ] = evaluateWeights( P_0, point )
%EVALUATE Evaluates the weigh W_k_j for each possible partitioning of the selected point
% Moves z to each possible cluster and evaluates the weight of the partition resulting from that move
% P_0 is the partitioning from the start, with point removed from the cluster
global v_0 S_0 alpha_0 beta_0;


N = P_0.Length;
W_k = ones(N+1,1);
N_1 = N;
N_0 = 0; % What are N1 N0 ?
for j = 1:N
    P_j = P_0; % copy the partition
    P_j.Clusters{j} = P_j.Clusters{j}.addPoint(point);

    for i = 1:P_j.Length % Add the p_D to check if the cluster is out of view
        % calculate weight parameters
        v_k = v_0 + P_j.Clusters{i}.Length-1;
        S_k = S_0 + (bsxfun(@minus,P_j.Clusters{i}.Points,P_j.Clusters{i}.Mean))*(bsxfun(@minus,P_j.Clusters{i}.Points,P_j.Clusters{i}.Mean))';
        mu_k = P_j.Clusters{i}.Mean;
        c_k = P_j.Clusters{i}.Length;
        alpha_k = alpha_0 + c_k;
        beta_k = beta_0 + N_1 + N_0;

        % calculate the prodsum
        p_D = 1;
        W_k(j) = W_k(j) * p_D * (beta_0^alpha_0*gamma(alpha_k))/(beta_k^alpha_k*gamma(alpha_0)) * (norm(S_0)^(v_0/2)*gamma(v_k/2))/(pi^(c_k-1)*sqrt(c_k)*gamma(v_0/2)*norm(S_k)^v_k/2);
    end
end
W_k(end) = 0; % weight of last element?

