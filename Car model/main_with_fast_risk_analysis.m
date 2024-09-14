clearvars
close all
run('parameters.m')

seed = 1234;
rng( seed ); % Reset the CPU random number generator.
gpurng( seed ); % Reset the GPU random number generator.

eta0 = 0.6;
fail_prob0 = 1;
Delta = 0.9;
rate = 0.08;
index =0;

eta = eta0;
% eta = 1 
fail_prob = fail_prob0;
% fail_prob_prev = fail_prob;

tic
while(fail_prob - Delta > 0.01) 
%     && fail_prob_prev >= fail_prob) 
    index = index+1;
%     eta
    
        xt = x0; %start the state from the given initial position
        % dynamics model is input acceleration model
        f_xt = [k1*xt(1) + xt(3)*cos(xt(4)); k1*xt(2) + xt(3)*sin(xt(4)); k2*xt(3); k3*xt(4)]; %initial f_xt

        for t = t0:h:T-h % this loop is to find u(t) and x(t) at each time step t => x(t+h) = x(t) + f(x(t)).h + G_u.u(t).h + Sigma*dw

            % Note that process noises are only applied to the last two states,
            % which are directly actuated
            eps_t_all_1 = randn(1, runs, 'gpuArray'); %GPU array that stores eps_1(t) at the start of each sample path starting at time t and state xt
            eps_t_all_2 = randn(1, runs, 'gpuArray'); %GPU array that stores eps_2(t) at the start of each sample path starting at time t and state xt
            
            if(t==t0)
                [S_tau_all, risk_all] = arrayfun(@risk_analysis_simulateMC, eps_t_all_1, eps_t_all_2, xt(1), xt(2), xt(3), xt(4), f_xt(1), f_xt(2), f_xt(3), f_xt(4), t, h, T, b, s, xR1, xS1, yR1, yS1, xR2, xS2, yR2, yS2, xP, xQ, yP, yQ, eta, d, k1, k2, k3); %an array that stores S(tau) of each sample path starting at time t and state xt
            else
                
                S_tau_all = arrayfun(@simulateMC, eps_t_all_1, eps_t_all_2, xt(1), xt(2), xt(3), xt(4), f_xt(1), f_xt(2), f_xt(3), f_xt(4), t, h, T, b, s, xR1, xS1, yR1, yS1, xR2, xS2, yR2, yS2, xP, xQ, yP, yQ, eta, d, k1, k2, k3); %an array that stores S(tau) of each sample path starting at time t and state xt
            end
            
            eps_t_all_arr = gather([eps_t_all_1; eps_t_all_2]); %concatenate eps_t_all_arr_1 and eps_t_all_arr_2 in an array

            denom_i = exp(-S_tau_all/lambda); %(size: (1 X runs))
            numer = eps_t_all_arr*(denom_i.'); %(size: (2 X 1))
            denom = sum(denom_i); %scalar

            ut = (s/sqrt(h)) * (numer/denom); %the agent control input
            
            if(t==t0)
                fail_prob = gather(risk_all*(denom_i.')/denom);
            end
            
%             if(any(isnan(ut(:))))
%                 fprintf("error!")
%                 return
%             end

            %move the trajectory forward
            eps = randn(2,1);
            %update the position with the control inputs ut and vt=> x(t+h) = x(t) + f.h + G_u.u(t).h + Sigma*dw
            xt = xt + f_xt*h + G_u*(ut*h + s*eps*sqrt(h));

            if(((xt(1)>=xR1) && (xt(1)<=xS1) && (xt(2)>=yR1) && (xt(2)<=yS1)) || ((xt(1)>=xR2) && (xt(1)<=xS2) && (xt(2)>=yR2) && (xt(2)<=yS2)) || ((xt(1)<=xP) || (xt(1)>=xQ) || (xt(2)<=yP) || (xt(2)>=yQ))) %if yes means trajectory has crossed the safe set
                break;  %end this traj    
            end 

            f_xt = [k1*xt(1) + xt(3)*cos(xt(4)); k1*xt(2) + xt(3)*sin(xt(4)); k2*xt(3); k3*xt(4)]; %update f(x(t)) for the next t => t=t+h. Will be used in the next iteration 
        end

    eta = eta + rate*(fail_prob - Delta);
end
toc

index

plot(x0(1),x0(2),'p', 'MarkerSize',40,'MarkerEdgeColor','k','MarkerFaceColor','y')
plot(0,0,'p', 'MarkerSize',40,'MarkerEdgeColor','k','MarkerFaceColor','m')
figname = ['u_zz_eta=',num2str(eta),'.fig'];
saveas(gcf,figname)