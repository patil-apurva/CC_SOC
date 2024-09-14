% plot eta* and pfail w.r.t. Delta

% Delta = [0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.6, 0.7, 0.8, 0.9];
% 
% eta_star_PI = [0.136, 0.135, 0.131, 0.13, 0.135, 0.128, 0.122, 0.107, 0.099, 0.089];
% eta_star_FDM = [0.1319, 0.1331, 0.1352, 0.1369, 0.1368, 0.1345, 0.1236, 0.1095, 0.1032, 0.0943];
% 
% 
% pfail_PI = [0.21, 0.28, 0.34, 0.29, 0.3, 0.35, 0.42, 0.67, 0.77, 0.88];
% pfail_FDM = [0.1975, 0.1814, 0.1555, 0.1381, 0.1388 0.1644, 0.34, 0.6776, 0.7978, 0.9053];

Delta = [0.1, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.6, 0.7, 0.8, 0.9];

eta_star_PI = [0.1396, 0.1296, 0.136, 0.135, 0.131, 0.13, 0.135, 0.128, 0.122, 0.107, 0.099, 0.089];
eta_star_FDM = [0.1410, 0.1327, 0.1319, 0.1331, 0.1352, 0.1369, 0.1368, 0.1345, 0.1236, 0.1095, 0.1032, 0.0943];


pfail_PI = [0.0515, 0.1285, 0.21, 0.28, 0.34, 0.29, 0.3, 0.35, 0.42, 0.67, 0.77, 0.88];
pfail_FDM = [0.1029, 0.1865, 0.1975, 0.1814, 0.1555, 0.1381, 0.1388 0.1644, 0.34, 0.6776, 0.7978, 0.9053];

figure(1)
set(gca, 'FontName', 'Arial', 'FontSize', 55)
set(gca,'LineWidth',1)
ax = gca;
ax.LineWidth = 1;
grid on;
xlabel('$\Delta$', 'Interpreter','latex', 'FontSize', 65); ylabel('$\eta^*$', 'Interpreter','latex','FontSize', 65); 
hold on;

plot(Delta, eta_star_PI, 'b-o', 'LineWidth',3.5, 'MarkerSize',20)
plot(Delta, eta_star_FDM, 'r-o', 'LineWidth',3.5, 'MarkerSize',20)
legend('PI', 'FDM')

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
plot(Delta, pfail_FDM, 'r-o', 'LineWidth',3.5, 'MarkerSize',20)
legend('PI', 'FDM')

% figure(3)
% set(gca, 'FontName', 'Arial', 'FontSize', 55)
% set(gca,'LineWidth',1)
% ax = gca;
% ax.LineWidth = 1;
% grid on;
% xlabel('$\eta^*$', 'Interpreter','latex', 'FontSize', 65); ylabel('$P_{fail}$', 'Interpreter','latex','FontSize', 65); 
% hold on;
% % yticks([0 0.25 0.5, 0.75, 1])
% 
% plot(eta_star_PI, pfail_PI, 'LineWidth',3.5)
% plot(eta_star_FDM, pfail_FDM, 'LineWidth',3.5)
% legend('PI', 'FDM')