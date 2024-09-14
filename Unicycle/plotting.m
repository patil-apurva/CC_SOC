% plot eta* and pfail w.r.t. Delta

Delta = [0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9];

eta_star_PI = [0.9, 0.7216, 0.6864, 0.6776, 0.6704, 0.6616, 0.648, 0.6345];

pfail_PI = [0.21, 0.23, 0.41, 0.42, 0.58, 0.62, 0.78, 0.9];

% Delta = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9];
% 
% eta_star_PI = [0.7107, 0.7086, 0.7019, 0.6911, 0.6777];
% 
% pfail_PI = [0.0162, 0.0200, 0.0316, 0.0039, 0.3079];



figure(1)
set(gca, 'FontName', 'Arial', 'FontSize', 55)
set(gca,'LineWidth',1)
ax = gca;
ax.LineWidth = 1;
grid on;
xlabel('$\Delta$', 'Interpreter','latex', 'FontSize', 65); ylabel('$\eta^*$', 'Interpreter','latex','FontSize', 65); 
hold on;

plot(Delta, eta_star_PI, 'b-o', 'LineWidth',3.5, 'MarkerSize',20)
% legend('PI', 'FDM')

figure(2)
set(gca, 'FontName', 'Arial', 'FontSize', 55)
set(gca,'LineWidth',1)
ax = gca;
ax.LineWidth = 1;
grid on;
xlabel('$\Delta$', 'Interpreter','latex', 'FontSize', 65); ylabel('$P_{fail}$', 'Interpreter','latex','FontSize', 65); 
hold on;
yticks([0 0.25 0.5, 0.75, 1])

plot(Delta, pfail_PI, 'b-o', 'LineWidth',3.5, 'MarkerSize',20)
% legend('PI', 'FDM')

Delta = [0.2, 0.4, 0.6, 0.8, 0.9];
time = [356.54, 279.5, 224.16, 101.04, 79.22];
figure(3)
set(gca, 'FontName', 'Arial', 'FontSize', 45)
set(gca,'LineWidth',1)
ax = gca;
ax.LineWidth = 1;
grid on;
xlabel('$\Delta$', 'Interpreter','latex', 'FontSize', 65); ylabel('Avg. Computation time per iteration', 'Interpreter','latex','FontSize', 65); 
hold on;


plot(Delta, time, 'LineWidth',3.5)