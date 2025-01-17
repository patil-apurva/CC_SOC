clearvars
close all
run('parameters.m') %all the parameters are stored inside the parameters.m file

seed = 1234;
rng(seed); % Reset the CPU random number generator.
gpurng(seed); % Reset the GPU random number generator.

Delta_all = [0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1];
eta_all = [];
fail_prob_all = [];

eta = eta0;   

for Delta = Delta_all
    Delta
    
    xt = x0; %start the state from the given initial position
    f_xt = [k1*xt(1) + xt(3)*cos(xt(4)); k1*xt(2) + xt(3)*sin(xt(4)); k2*xt(3); k3*xt(4)]; %initial f_xt

%     eta = eta0;  
    fail_prob = fail_prob0;
       
while(1) 
%     eta     
    eps_t_all_1 = randn(1, runs, 'gpuArray'); %GPU array that stores eps_1(t) at the start of each sample path starting at time t and state xt
    eps_t_all_2 = randn(1, runs, 'gpuArray'); %GPU array that stores eps_2(t) at the start of each sample path starting at time t and state xt
    
    [S_tau_all, risk_tau_all] = arrayfun(@risk_analysis_simulateMC, eps_t_all_1, eps_t_all_2, xt(1), xt(2), xt(3), xt(4), f_xt(1), f_xt(2), f_xt(3), f_xt(4), h, T, b, s, xR1, xS1, yR1, yS1, xR2, xS2, yR2, yS2, xP, xQ, yP, yQ, eta, d, k1, k2, k3, Delta); %an array that stores S(tau) and risk(tau) of each sample path starting at time t and state xt
    
    eps_t_all_arr = gather([eps_t_all_1; eps_t_all_2]); %concatenate eps_t_all_arr_1 and eps_t_all_arr_2 in an array

    denom_i = exp(-S_tau_all/lambda); %(size: (1 X runs))
    denom = sum(denom_i); %scalar
    
    fail_prob = gather(risk_tau_all*(denom_i.')/denom); %importance sampling formula to compute fail_prob
    
    if(abs(fail_prob - Delta) < epsilon)
         break;
    end
    
    eta = eta + rate*(fail_prob - Delta);  %gradient ascent

end
    eta_all = [eta_all; eta];
    fail_prob_all = [fail_prob_all; fail_prob]; 
end

figure (4)
hold on;
set(gca, 'FontName', 'Arial', 'FontSize', 18)
xlabel('$\Delta$', 'Interpreter','latex', 'FontSize', 30); ylabel('$P_{fail}$', 'Interpreter','latex','FontSize', 30);
set(gca,'LineWidth',1)
ax = gca;
ax.LineWidth = 1;
ax.Color = 'w';
plot(Delta_all, fail_prob_all, 'r', 'LineWidth', 2);
grid on;
figname = "Pfail_vs_Delta.fig";
saveas(gcf,figname)

figure (5)
hold on;
set(gca, 'FontName', 'Arial', 'FontSize', 18)
xlabel('$\Delta$', 'Interpreter','latex', 'FontSize', 30); ylabel('$\eta$', 'Interpreter','latex','FontSize', 30);
set(gca,'LineWidth',1)
ax = gca;
ax.LineWidth = 1;
ax.Color = 'w';
plot(Delta_all, eta_all, 'b', 'LineWidth', 2);
grid on;
figname = "eta_vs_Delta.fig";
saveas(gcf,figname)

figure (6)
hold on;
set(gca, 'FontName', 'Arial', 'FontSize', 18)
xlabel('$\eta$', 'Interpreter','latex', 'FontSize', 30); ylabel('$P_{fail}$', 'Interpreter','latex','FontSize', 30);
set(gca,'LineWidth',1)
ax = gca;
ax.LineWidth = 1;
ax.Color = 'w';
plot(eta_all, fail_prob_all, 'k', 'LineWidth', 2);
grid on;
figname = "Pfail_vs_eta.fig";
saveas(gcf,figname)