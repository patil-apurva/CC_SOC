close all
%outer rectangle
xP = -0.4;
yP = -0.1;
A = 0.5; 
B = 0.5;

%obstacle
xR = -0.3;
yR = 0;
xS = -0.1;
yS = 0.2;

c = 1; %G=c.I
s2 = 0.01; %Sigma=s.I, s2=s^2

a = 1; %R=a.I
b = 1; %V=b.||x(t)||^2
d = 1; %psi=d.||x(T)||^2
e = 1;

x0 = [-0.3; 0.3]; %initial position
runs = 1000000; %MC runs
traj_num = 100; %number of trajectories to plot

h = 0.001; % time step
t0 = 0.0; %initial time
T = 2; % final time

eta0 = 0;
fail_prob0 = 1;
rate = 0.001;
epsilon = 0.01;
%==========================================================================

lambda = a*s2/(c^2); %PDE linearization constant
k = -e/T;
s = sqrt(s2); %Sigma=s.I

xQ = xP+A;
yQ = yP+B;

figure (2)
hold on;
set(gca, 'FontName', 'Arial', 'FontSize', 18)
xlabel('$p_x$', 'Interpreter','latex', 'FontSize', 30); ylabel('$p_y$', 'Interpreter','latex','FontSize', 30); 
xticks(xP:0.1:xQ)
yticks(yP:0.1:yQ)
set(gca,'LineWidth',1)
ax = gca;
ax.LineWidth = 1;
ax.Color = 'w';
axis equal;
xlim([xP, xQ]);
ylim([yP, yQ]);
rectangle('Position',[xP yP xQ-xP yQ-yP], 'FaceColor', 'w', 'EdgeColor', 'r', 'LineWidth',1.5); %outer rectangle
v = [xS yS; xR yS; xR yR; xS yR];
f = [1 2 3 4 1];
% p= patch('Faces',f,'Vertices',v,...
%     'EdgeColor','none','FaceColor','w');
% hatch(p, 30, 'k', '-', 12, 2);
rectangle('Position',[xR yR xS-xR yS-yR], 'FaceColor', 'r', 'EdgeColor', 'r', 'LineWidth',1.5); %inner rectangle

clear A B A_xi A_zeta B_eta B_nu