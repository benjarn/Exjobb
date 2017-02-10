function [ W_k ] = evaluateWeights( P_0, point )
%EVALUATE Evaluates the weigh W_k_j for each possible partitioning of the selected point
% Moves z to each possible cluster and evaluates the weight of the partition resulting from that move
% P_0 is the partitioning from the start, with point removed from the cluster
global v_0 S_0 alpha_0 beta_0;


N = P_0.Length;
W_k = ones(N+1,1);
N_1 = 0; % N % P_j.Length
N_0 = 0; % What are N1 N0 ?
for j = 1:N+1
    P_j = P_0; % copy the partition
    if(j==N+1)
    P_j = P_j.addCluster(GibbsCluster());
    end
    P_j.Clusters{j} = P_j.Clusters{j}.addPoint(point);

    p_D = fov();
    if(p_D) % Check if target landmark is inside the fov
        for i = 1:P_j.Length % Add the p_D to check if the cluster is out of view
            % calculate weight parameters
            v_k = v_0 + P_j.Clusters{i}.Length-1;
            S_k = S_0 + (bsxfun(@minus,P_j.Clusters{i}.Points,P_j.Clusters{i}.Mean))*(bsxfun(@minus,P_j.Clusters{i}.Points,P_j.Clusters{i}.Mean))';
            mu_k = P_j.Clusters{i}.Mean;
            c_k = P_j.Clusters{i}.Length;
            alpha_k = alpha_0 + c_k; % Small alpha, fewer measurements expected from landmark
            beta_k = beta_0 + N_1 + N_0; % Small beta, large variance

            % calculate the prodsum
            p_D = 1;
            % Add a logarithm based calculation
            % log(a*b) = log(a) + log(b)
            % log(a/b) = log(a) - log(b)
            % log(b^a) = a*log(b)
            % gammaln(A) = log(gamma(A))
            W_k(j) = W_k(j)  + ...
             log(beta_0)*alpha_0 + gammaln(alpha_k)   -  log(beta_k)*alpha_k -gammaln(alpha_0) ...
             + log(norm(S_0))*(v_0/2) + gamma2(v_k/2) -log(pi)*(c_k-1) -0.5*log(c_k) -gamma2(v_0/2) -log(norm(S_k))*(v_k/2);
        end
    else
        W_k(j) = 0;
    end
end

