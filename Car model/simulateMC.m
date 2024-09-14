function S_tau_all = simulateMC(eps_t_all_1, eps_t_all_2, px_t_prime, py_t_prime, v_t_prime, theta_t_prime, phi_t_prime, fpx_t_prime, fpy_t_prime, fv_t_prime, ftheta_t_prime, fphi_t_prime, t, h, T, b, s, xR1, xS1, yR1, yS1, xR2, xS2, yR2, yS2, xP, xQ, yP, yQ, eta, k1, k2, k3, k4, d, L)

    eps_t_prime_1 = eps_t_all_1; %standard normal noise at t
    eps_t_prime_2 = eps_t_all_2; %standard normal noise at t
    
    S_tau = 0; %the cost-to-go of the state dependent cost of a sample path
    safe_flag_tau = 1;
    
    for t_prime = t:h:T-h % this loop is to compute S(tau_i)
                
        S_tau = S_tau + h*b*(px_t_prime*px_t_prime + py_t_prime*py_t_prime); %add the state dependent running cost
        
        px_t_prime = px_t_prime + fpx_t_prime*h; %move tau ahead
        py_t_prime = py_t_prime + fpy_t_prime*h; %move tau ahead
        v_t_prime = v_t_prime + fv_t_prime*h + s*eps_t_prime_1*sqrt(h); %move tau ahead
        theta_t_prime = theta_t_prime + ftheta_t_prime*h; %move tau ahead
        phi_t_prime = phi_t_prime + fphi_t_prime*h + s*eps_t_prime_2*sqrt(h); %move tau ahead

        if (((px_t_prime>=xR1) && (px_t_prime<=xS1) && (py_t_prime>=yR1) && (py_t_prime<=yS1)) || ((px_t_prime>=xR2) && (px_t_prime<=xS2) && (py_t_prime>=yR2) && (py_t_prime<=yS2)) || ((px_t_prime<=xP) || (px_t_prime>=xQ) || (py_t_prime<=yP) || (py_t_prime>=yQ)))%if yes means t_prime=t_exit
            S_tau = S_tau + eta; %add the boundary cost to S_tau
            safe_flag_tau = 0;
            break; %end this tau 
        end

        eps_t_prime_1 = randn; %standard normal noise at new t_prime. Will be used in the next iteration 
        eps_t_prime_2 = randn; %standard normal noise at new t_prime. Will be used in the next iteration 

        fpx_t_prime =  k1*px_t_prime + v_t_prime*cos(theta_t_prime); %fpx_t_prime at new t_prime. Will be used in the next iteration 
        fpy_t_prime =  k1*py_t_prime + v_t_prime*sin(theta_t_prime); %fpy_t_prime at new t_prime. Will be used in the next iteration 
        fv_t_prime =  k2*v_t_prime; %fv_t_prime at new t_prime. Will be used in the next iteration 
        ftheta_t_prime =  k3*theta_t_prime + v_t_prime*tan(phi_t_prime)/L; %ftheta_t_prime at new t_prime. Will be used in the next iteration
        fphi_t_prime = k4*phi_t_prime; %fphi_t_prime at new t_prime. Will be used in the next iteration
    end

    if(safe_flag_tau==1) %if tau has not collided 
        S_tau = S_tau + d*(px_t_prime*px_t_prime + py_t_prime*py_t_prime); %add the terminal cost to S_tau
    end

    S_tau_all = S_tau;