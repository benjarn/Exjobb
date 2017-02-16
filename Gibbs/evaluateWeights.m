function [ W_k ] = evaluateWeights( P_0, point,ego_pos )
%EVALUATE Evaluates the weigh W_k_j for each possible partitioning of the selected point
% Moves z to each possible cluster and evaluates the weight of the partition resulting from that move
% P_0 is the partitioning from the start, with point removed from the cluster
global v_0 S_0 alpha_0 beta_0;


N = P_0.Length;
W_k = ones(N+1,1);
N_1 = N;
N_0 = 0; % What are N1 N0 ?

for j = 1:N+1
    P_j = P_0; % copy the partition
    if(j==N+1)
        P_j = P_j.addCluster(GibbsCluster());
    end
    P_j.Clusters{j} = P_j.Clusters{j}.addPoint(point);
    
    p_D = fov(P_j.Clusters{j}.Mean,ego_pos);
    if(p_D) % Check if target landmark is inside the fov
        for i = 1:P_j.Length % Add the p_D to check if the cluster is out of view
            % calculate weight parameters
            p_D = fov(P_j.Clusters{i}.Mean,ego_pos);
            if(p_D)
                v_k = v_0 + P_j.Clusters{i}.Length-1;
                S_k = S_0 + P_j.Clusters{i}.Sigma;
                %mu_k = P_j.Clusters{i}.Mean;
                c_k = P_j.Clusters{i}.Length;
                alpha_k = alpha_0 + c_k; % Small alpha, fewer measurements expected from landmark
                beta_k = beta_0 + N_1 + N_0; % Small beta, large variance
                
                % calculate the prodsum
                W=(gamma(alpha_k))/(beta_k^alpha_k) * (gamma2(v_k/2))/(pi^(c_k-1)*sqrt(c_k)*norm(S_k)^(v_k/2));
                W_k(j) = W_k(j)  * W;
            end
        end
    else
        W_k(j) = 0;
    end
end

