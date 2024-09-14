clearvars
run('parameters_J_try2.m')

x0_3 = Speed;
x0_4 = Theta;

J = zeros(Nx, Ny); %store J's at all the grid points  
V1 = zeros(Nx, Ny); %store v(1)'s at all the grid points  
V2 = zeros(Nx, Ny); %store v(2)'s at all the grid points  
Nx_iter = 0; 

for x0_1 = linspace(xP, xQ, Nx)
    x0_1
    Nx_iter = Nx_iter + 1;
    Ny_iter = 0;
    
     for x0_2 = linspace(yP, yQ, Ny)
        Ny_iter = Ny_iter + 1;
                               
        if((x0_1>(xR1)) && (x0_1<(xS1)) && (x0_2>(yR1)) && (x0_2<(yS1)) || (x0_1>(xR2)) && (x0_1<(xS2)) && (x0_2>(yR2)) && (x0_2<(yS2)))
             J(Nx_iter, Ny_iter) = NaN;
             V1(Nx_iter, Ny_iter) = NaN;
             V2(Nx_iter, Ny_iter) = NaN;
        else
            x0 = [x0_1; x0_2; x0_3; x0_4]; %given initial position
            t0 = 0;
            f_x0 = [k1*x0(1) + x0(3)*cos(x0(4)); k1*x0(2) + x0(3)*sin(x0(4)); k2*x0(3); k3*x0(4)];
            
            eps0_all_1 = randn(1, runs, 'gpuArray'); %GPU array that stores eps_1(t) at the start of each sample path starting at time t and state xt
            eps0_all_2 = randn(1, runs, 'gpuArray'); %GPU array that stores eps_2(t) at the start of each sample path starting at time t and state xt
            
            S_tau_all = arrayfun(@simulateMC, eps0_all_1, eps0_all_2, x0(1), x0(2), x0(3), x0(4), f_x0(1), f_x0(2), f_x0(3), f_x0(4), t0, h, T, b, s, xR1, xS1, yR1, yS1, xR2, xS2, yR2, yS2, xP, xQ, yP, yQ, eta, d, k1, k2, k3); %an array that stores S(tau) of each sample path starting at time t and state xt
            
            eps0_all_arr = gather([eps0_all_1; eps0_all_2]);
            S_tau_all_arr = gather(S_tau_all); %convert from GPU array to normal array (size: (1 X runs))
            
            denom_i = exp(-S_tau_all_arr/lambda); %(size: (1 X runs))
            numer = eps0_all_arr*(denom_i.'); %(size: (2 X 1))
            denom = sum(denom_i); %scalar

            xi0 = denom/runs; %xi(x0,t0)
            J0 = -lambda*log(xi0); %J(x0,t0)

            u0 = ((s/c)*numer)/(sqrt(h)*denom); %the control input
            
            if (((x0_1>=(xR1)) && (x0_1<=(xS1)) && (x0_2>=(yR1)) && (x0_2<=(yS1))) || ((x0_1>=(xR2)) && (x0_1<=(xS2)) && (x0_2>=(yR2)) && (x0_2<=(yS2))) || ((x0_1<=xP) || (x0_1>=xQ) || (x0_2<=yP) || (x0_2>=yQ)))%if yes means x0 is not in the safe region
                J(Nx_iter, Ny_iter) = eta; %set the value at x0 as eta
            else
                J(Nx_iter, Ny_iter) = J0; %store J0 at the given x0 
            end
%   
%             V1(Nx_iter, Ny_iter) = u0(1);
%             V2(Nx_iter, Ny_iter) = u0(2);
        end
    end
end

x_grid = linspace(xP,xQ,Nx);
y_grid = linspace(yP,yQ,Ny);

[x_mesh, y_mesh] = meshgrid(x_grid, y_grid); %the grid points
x_mesh = x_mesh.';
y_mesh = y_mesh.';

xx_mesh_2 = zeros(1,1);
yy_mesh_2 = zeros(1,1);
itr1 = 0;
for i = 1:1:Nx
    itr1 = itr1+1;
    itr2 = 0;
    for j = 1:1:Ny
        itr2 = itr2+1;
        xx_mesh_2(itr1, itr2) = x_mesh(i,j);
        yy_mesh_2(itr1, itr2) = y_mesh(i,j);
    end
end


figure(1)
hold on
S1 = surf(x_mesh, y_mesh, J);
axis equal;
set(S1,'LineWidth',0.5, 'EdgeAlpha', 1)
set(gca, 'FontName', 'Arial', 'FontSize', 18)
xlabel('$p_x$', 'Interpreter','latex', 'FontSize', 20); ylabel('$p_y$', 'Interpreter','latex','FontSize', 20); 
set(gca,'LineWidth',1)
ax = gca;
ax.LineWidth = 1;
xlim([xP, xQ]);
ylim([yP, yQ]);
view([-336.7460 32.9971])
figname = ['J_surf_eta=', num2str(eta), '_s2=', num2str(s2), '_theta=0','.fig'];
saveas(gcf,figname)

fprintf("done!")