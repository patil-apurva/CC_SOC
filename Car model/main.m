clearvars
close all
run('parameters.m')

seed = 1234;
rng(seed); % Reset the CPU random number generator.
gpurng(seed); % Reset the GPU random number generator.

eta0 = 0.7760;
fail_prob0 = 1;
Delta = 0.8;
rate = 0.1;
index =0;

eta = eta0;
fail_prob = fail_prob0;

tic
while(fail_prob - Delta > 0.01)  
    index = index+1;
    fail_cnt = 0; %number of trajectories failed
    eta
    
    for traj_itr = 1:traj_num
%         traj_itr

        X = []; %to store all positions of this trajectory
        X = [X, x0]; %stack the initial position

        xt = x0; %start the state from the given initial position

        px_t = xt(1); py_t = xt(2); v_t = xt(3); theta_t = xt(4); phi_t = xt(5); 

        % dynamics model is a bicycle model
        f_xt = [k1*px_t + v_t*cos(theta_t); k1*py_t + v_t*sin(theta_t); k2*v_t; k3*theta_t + v_t*tan(phi_t)/L; k4*phi_t]; %initial f_xt
        
        fpx_t = f_xt(1); fpy_t = f_xt(2); fv_t = f_xt(3); ftheta_t = f_xt(4); fphi_t = f_xt(5);
        
        safe_flag_traj = 1;

        for t = t0:h:T-h % this loop is to find u(t) and x(t) at each time step t => x(t+h) = x(t) + f(x(t)).h + G_u.u(t).h + Sigma*dw

            % Note that process noises are only applied to the third and the fifth states,
            % which are directly actuated
            eps_t_all_1 = randn(1, runs, 'gpuArray'); %GPU array that stores eps_1(t) at the start of each sample path starting at time t and state xt
            eps_t_all_2 = randn(1, runs, 'gpuArray'); %GPU array that stores eps_2(t) at the start of each sample path starting at time t and state xt

            S_tau_all = arrayfun(@simulateMC, eps_t_all_1, eps_t_all_2, px_t, py_t, v_t, theta_t, phi_t, fpx_t, fpy_t, fv_t, ftheta_t, fphi_t, t, h, T, b, s, xR1, xS1, yR1, yS1, xR2, xS2, yR2, yS2, xP, xQ, yP, yQ, eta, k1, k2, k3, k4, d, L); %an array that stores S(tau) of each sample path starting at time t and state xt

            eps_t_all_arr = gather([eps_t_all_1; eps_t_all_2]); %concatenate eps_t_all_arr_1 and eps_t_all_arr_2 in an array

            denom_i = exp(-S_tau_all/lambda); %(size: (1 X runs))
            numer = eps_t_all_arr*(denom_i.'); %(size: (2 X 1))
            denom = sum(denom_i); %scalar

            ut = (s/sqrt(h)) * (numer/denom); %the agent control input
            
%             if(any(isnan(ut(:))))
%                 fprintf("error!")
%                 return
%             end

            %move the trajectory forward
            eps = randn(2,1);
            %update the position with the control inputs ut=> x(t+h) = x(t) + f.h + G_u.u(t).h + Sigma*dw
            xt = xt + f_xt*h + G_u*(ut*h + s*eps*sqrt(h));
%             xt = xt + f_xt*h + G_u*(ut*h);

            px_t = xt(1); py_t = xt(2); v_t = xt(3); theta_t = xt(4); phi_t = xt(5);

            X = [X, xt]; %stack the new position

            if(((px_t>=xR1) && (px_t<=xS1) && (py_t>=yR1) && (py_t<=yS1)) || ((px_t>=xR2) && (px_t<=xS2) && (py_t>=yR2) && (py_t<=yS2)) || ((px_t<=xP) || (px_t>=xQ) || (py_t<=yP) || (py_t>=yQ))) %if yes means trajectory has crossed the safe set
                fail_cnt = fail_cnt+1; 
                safe_flag_traj = 0;
                break;  %end this traj    
            end 

            f_xt = [k1*px_t + v_t*cos(theta_t); k1*py_t + v_t*sin(theta_t); k2*v_t; k3*theta_t + v_t*tan(phi_t)/L; k4*phi_t]; %update f(x(t)) for the next t => t=t+h. Will be used in the next iteration 
            
            fpx_t = f_xt(1); fpy_t = f_xt(2); fv_t = f_xt(3); ftheta_t = f_xt(4); fphi_t = f_xt(5);
        end

%          if (safe_flag_traj==1)
%             h2a = plot (X(1, :), X(2, :), 'g', 'LineWidth',1);
% %             h2a.Color(4)=0.3;
%         else
%             h2a = plot (X(1, :), X(2, :), 'b', 'LineWidth',1);
% %             h2a.Color(4)=0.3;
%          end
    end
    
    fail_prob = fail_cnt/traj_num
    
    eta = eta + rate*(fail_prob - Delta);
end
toc
plot(x0(1),x0(2),'p', 'MarkerSize',40,'MarkerEdgeColor','k','MarkerFaceColor','y')
plot(0,0,'p', 'MarkerSize',40,'MarkerEdgeColor','k','MarkerFaceColor','m')
% figname = ['u_zz_eta=',num2str(eta),'.fig'];
% saveas(gcf,figname)