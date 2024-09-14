clearvars
close all
run('parameters.m')

seed = 1234;
rng( seed ); % Reset the CPU random number generator.
gpurng( seed ); % Reset the GPU random number generator.

eta0 = 0.05;
fail_prob0 = 1;
Delta = 0.1
rate = 0.1;
index =0;

eta = eta0;

fail_prob = fail_prob0;

tic
while(fail_prob - Delta > 0.01)
    index = index+1;
    eta

        xt = x0; %start the state from the given initial position
        f_xt = k*c*xt; %initial f_xt

        for t = t0:h:T-h % this loop is to find u(t) and x(t) at each time step t => x(t+h) = x(t) + f(x(t)).h + G.u(t).h + Sigma*dw
            eps_t_all_1 = randn(1, runs, 'gpuArray'); %GPU array that stores eps_1(t) at the start of each sample path starting at time t and state xt
            eps_t_all_2 = randn(1, runs, 'gpuArray'); %GPU array that stores eps_2(t) at the start of each sample path starting at time t and state xt
            
            if(t==t0)
                [S_tau_all, risk_all] = arrayfun(@risk_analysis_simulateMC, eps_t_all_1, eps_t_all_2, xt(1), xt(2), f_xt(1), f_xt(2), t, h, T, b, s, xR, xS, yR, yS, xP, xQ, yP, yQ, eta, k, c, d); %an array that stores S(tau) of each sample path starting at time t and state xt
            else
                S_tau_all = arrayfun(@simulateMC, eps_t_all_1, eps_t_all_2, xt(1), xt(2), f_xt(1), f_xt(2), t, h, T, b, s, xR, xS, yR, yS, xP, xQ, yP, yQ, eta, k, c, d); %an array that stores S(tau) of each sample path starting at time t and state xt
            end
            
            eps_t_all_arr = gather([eps_t_all_1; eps_t_all_2]); %concatenate eps_t_all_arr_1 and eps_t_all_arr_2 in an array

            denom_i = exp(-S_tau_all/lambda); %(size: (1 X runs))
            numer = eps_t_all_arr*(denom_i.'); %(size: (2 X 1))
            denom = sum(denom_i); %scalar

            ut = ((s/c)*numer)/(sqrt(h)*denom); %the control input
            
            if(t==t0)
                fail_prob = risk_all*(denom_i.')/denom;
            end

    %         if(any(isnan(ut(:))))
    %             fprintf("error!")
    %             return
    %         end

            %move the trajectory forward
            eps = randn(2,1);
            xt = xt + f_xt*h + c*ut*h + s*eps*sqrt(h); %update the position with the control input ut=> x(t+h) = x(t) + f.h + g.u(t).h + sigma*dw

            if(((xt(1)>=xR) && (xt(1)<=xS) && (xt(2)>=yR) && (xt(2)<=yS)) || ((xt(1)<=xP) || (xt(1)>=xQ) || (xt(2)<=yP) || (xt(2)>=yQ))) %if yes means trajectory has crossed the safe set 
                break;  %end this traj    
            end 

            f_xt = k*c*xt; %update f(x(t)) for the next t => t=t+h. Will be used in the next iteration 
        end
    eta = eta + rate*(fail_prob - Delta);
    fail_prob
end
toc 

index

plot(x0(1),x0(2),'p', 'MarkerSize',40,'MarkerEdgeColor','k','MarkerFaceColor','y')
plot(0,0,'p', 'MarkerSize',40,'MarkerEdgeColor','k','MarkerFaceColor','g')
figname = ['eta=',num2str(eta),'.fig'];
saveas(gcf,figname)