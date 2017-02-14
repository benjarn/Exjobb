function [ W_k ] = evaluateWeights( P_0, point, ego_pos )
%EVALUATE Evaluates the weigh W_k_j for each possible partitioning of the selected point
% Moves z to each possible cluster and evaluates the weight of the partition resulting from that move
% P_0 is the partitioning from the start, with point removed from the cluster
global v_0 S_0 alpha_0 beta_0;


N = P_0.Length;
W_k = ones(N+1,1);
N_1 = N;
N_0 = 0; % What are N1 N0 ?
W_base = 1;
for i = 1:N % Add the p_D to check if the cluster is out of view
    % calculate weight parameters
    v_k = v_0 + P_0.Clusters{i}.Length-1;
    S_k = S_0 + P_0.Clusters{i}.Sigma;
    mu_k = P_0.Clusters{i}.Mean;
    c_k = P_0.Clusters{i}.Length;
    alpha_k = alpha_0 + c_k; % Small alpha, fewer measurements expected from landmark
    beta_k = beta_0 + N_1 + N_0; % Small beta, large variance
    % calculate the prodsum
    W_base = prodSum_mex(W_base,v_k,S_k,mu_k,c_k,alpha_k,beta_k);  
end
W_k = W_base*W_k;
for j = 1:N+1
    P_j = P_0; % copy the partition
    if(j==N+1)
    P_j = P_j.addCluster(GibbsCluster());
    end
    p_D = fov(P_j.Clusters{j}.Mean, ego_pos); % Should be before assignment pj - p0
    if(p_D) % Check if target landmark is inside the fov
        % calculate weight parameters before the move
        v_k = v_0 + P_j.Clusters{j}.Length-1;
        S_k = S_0 + P_j.Clusters{j}.Sigma;
        mu_k = P_j.Clusters{j}.Mean;
        c_k = P_j.Clusters{j}.Length;
        alpha_k = alpha_0 + c_k; % Small alpha, fewer measurements expected from landmark
        beta_k = beta_0 + N_1 + N_0; % Small beta, large variance
        % calculate the prodsum
        W_old = prodSum_mex(1,v_k,S_k,mu_k,c_k,alpha_k,beta_k);

        P_j.Clusters{j} = P_j.Clusters{j}.addPoint(point);
        % calculate weight parameters for the target cluster
        v_k = v_0 + P_j.Clusters{j}.Length-1;
        S_k = S_0 + P_j.Clusters{j}.Sigma;
        mu_k = P_j.Clusters{j}.Mean;
        c_k = P_j.Clusters{j}.Length;
        alpha_k = alpha_0 + c_k; % Small alpha, fewer measurements expected from landmark
        beta_k = beta_0 + N_1 + N_0; % Small beta, large variance
        % calculate the prodsum
        W_k(j) = prodSum_mex(W_k(j),v_k,S_k,mu_k,c_k,alpha_k,beta_k)/W_old;
    else
        W_k(j) = 0;
    end
end

