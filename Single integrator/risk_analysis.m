clearvars
% close all
run('risk_analysis_parameters.m')

% runs_all = [1, 10, 100, 1000, 10^4, 10^5, 10^6, 10^7, 10^8];
% runs_all_in_power = [0, 1, 2, 3, 4, 5, 6, 7, 8];
runs_all = [10^8];

pfail_under_Q_all = [];
pfail_under_R_all = [];

seed = 1234;
rng( seed ); % Reset the CPU random number generator.
gpurng( seed ); % Reset the GPU random number generator.

for runs = runs_all
    runs
    f_x0 = k*c*x0; %initial f_xt

    eps0_all_1 = randn(1, runs, 'gpuArray'); %GPU array that stores eps_1(t0) at the start of each sample path starting at time t0 and state x0
    eps0_all_2 = randn(1, runs, 'gpuArray'); %GPU array that stores eps_2(t0) at the start of each sample path starting at time t0 and state x0

    [S_tau_all, risk_all] = arrayfun(@risk_analysis_simulateMC, eps0_all_1, eps0_all_2, x0(1), x0(2), f_x0(1), f_x0(2), t0, h, T, b, s, xR, xS, yR, yS, xP, xQ, yP, yQ, eta, k, c, d); %an array that stores S(tau) of each sample path starting at time t and state xt

    denom_i = exp(-S_tau_all/lambda); %(size: (1 X runs))
    denom = sum(denom_i); %scalar

    % weighting = denom_i/denom;

    % pfail = risk_all*weighting.'

    pfail_under_Q = risk_all*(denom_i.')/denom;
    pfail_under_R = sum(risk_all)*1/runs;

    pfail_under_Q_all = [pfail_under_Q_all, pfail_under_Q]
%     pfail_under_R_all = [pfail_under_R_all, pfail_under_R]
end

% figure(1);
% hold on;
% plot(runs_all_in_power, pfail_under_Q_all, 'r')
% % plot(runs_all_in_power, pfail_under_R_all, 'b')
% xlabel('runs')
% ylabel('Pfail')
% 
% % legend ('Q', 'R')
% legend ('Q')

plot(x0(1),x0(2),'p', 'MarkerSize',40,'MarkerEdgeColor','k','MarkerFaceColor','y')
plot(0,0,'p', 'MarkerSize',40,'MarkerEdgeColor','k','MarkerFaceColor','g')