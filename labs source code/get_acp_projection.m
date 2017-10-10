%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016

function data_projected = get_acp_projection(data , vec_p, M, n)

[n_samples , ~] = size(data);
% Projection on the n first eigen vectors
data_projected = (data - ones(n_samples , 1) * M) * vec_p(:, 1:n);

end 