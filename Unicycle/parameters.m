close all
%outer rectangle
xP = -0.5;
yP = -0.5;
% yP = -0.1;
% A = 0.6; 
% B = 0.6;
A = 0.6; 
B = 0.6;

%obstacles
xR1 = -0.3;
yR1 = -0.4;
xS1 = -0.2;
yS1 = -0.25;
xR2 = -0.3;
yR2 = -0.15;
xS2 = -0.1;
yS2 = 0;

%time parameters
h = 0.01; % time step
t0 = 0.0; %initial time
T = 10; % final time

%==================================
%tuning parameters
s2 = 0.01; %s^2
% eta = 1 %lagrange multiplier
a = 1; %R=a.I
b = 1; %V=b.||x(t)||^2
d = 1; %psi=d.||x(T)||^2
e = 2;
%==================================

G_u = [0 0; 0 0; 1 0; 0 1];

x0 = [-0.4; -0.4; 0; 0]; %initial position
runs = 10000; %MC runs
traj_num = 100; %number of trajectories to plot
%==========================================================================
lambda = a*s2; %PDE linearization constant
k1 = -e/T;
k2 = k1;
k3 = k1;

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
v1 = [xS1 yS1; xR1 yS1; xR1 yR1; xS1 yR1];
f = [1 2 3 4 1];
p1= patch('Faces',f,'Vertices',v1,...
    'EdgeColor','none','FaceColor','r');
% hatch(p1, 30, 'k', '-', 12, 2);
rectangle('Position',[xR1 yR1 xS1-xR1 yS1-yR1], 'EdgeColor', 'r', 'LineWidth',1.5); %inner rectangle
hold on
v2 = [xS2 yS2; xR2 yS2; xR2 yR2; xS2 yR2];
f = [1 2 3 4 1];
p2= patch('Faces',f,'Vertices',v2,...
    'EdgeColor','none','FaceColor','r');
% hatch(p2, 30, 'k', '-', 12, 2);
rectangle('Position',[xR2 yR2 xS2-xR2 yS2-yR2], 'EdgeColor', 'r', 'LineWidth',1.5); %inner rectangle

clear A B