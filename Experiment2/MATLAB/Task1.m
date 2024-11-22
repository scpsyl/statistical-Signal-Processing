A_true = 1;                % 稳恒电压信号幅度
sigma1 = 0.5;        % 噪声标准差（第一次和第二次实验）
sigma2 = 2.0;        % 噪声标准差（第三次实验）
num_trials = 10000;        % 重复次数

% 实验1：N=10，sigma^2=0.5
N1 = 10;
fprintf('实验1：N=%d, 噪声方差=0.5\n', N1);
% 生成数据
data1 = A_true + sigma1 * randn(num_trials, N1);
% 估计A
A_hat1 = mean(data1, 2);
% 理论值
E_A_hat1 = A_true;
Var_A_hat1 = sigma1^2 / N1;
% 实际结果
mean_A_hat1 = mean(A_hat1);
var_A_hat1 = var(A_hat1);
% 输出结果
fprintf('理论期望：E[A_hat]=%.4f\n', E_A_hat1);
fprintf('实际期望：E[A_hat]=%.4f\n', mean_A_hat1);
fprintf('理论方差：Var[A_hat]=%.6f\n', Var_A_hat1);
fprintf('实际方差：Var[A_hat]=%.6f\n\n', var_A_hat1);

% 实验2：N=100，sigma^2=0.5
N2 = 100;
fprintf('实验2：N=%d, 噪声方差=0.5\n', N2);
% 生成数据
data2 = A_true + sigma1 * randn(num_trials, N2);
% 估计A
A_hat2 = mean(data2, 2);
% 理论值
E_A_hat2 = A_true;
Var_A_hat2 = sigma1^2 / N2;
% 实际结果
mean_A_hat2 = mean(A_hat2);
var_A_hat2 = var(A_hat2);
% 输出结果
fprintf('理论期望：E[A_hat]=%.4f\n', E_A_hat2);
fprintf('实际期望：E[A_hat]=%.4f\n', mean_A_hat2);
fprintf('理论方差：Var[A_hat]=%.6f\n', Var_A_hat2);
fprintf('实际方差：Var[A_hat]=%.6f\n\n', var_A_hat2);

% 实验3：N=100，sigma^2=2.0
N3 = 100;
fprintf('实验3：N=%d, 噪声方差=2.0\n', N3);
% 生成数据
data3 = A_true + sigma2 * randn(num_trials, N3);
% 估计A
A_hat3 = mean(data3, 2);
% 理论值
E_A_hat3 = A_true;
Var_A_hat3 = sigma2^2 / N3;
% 实际结果
mean_A_hat3 = mean(A_hat3);
var_A_hat3 = var(A_hat3);
% 输出结果
fprintf('理论期望：E[A_hat]=%.4f\n', E_A_hat3);
fprintf('实际期望：E[A_hat]=%.4f\n', mean_A_hat3);
fprintf('理论方差：Var[A_hat]=%.6f\n', Var_A_hat3);
fprintf('实际方差：Var[A_hat]=%.6f\n', var_A_hat3);

% 可视化结果
figure;
subplot(3,1,1);
histogram(A_hat1, 50, 'Normalization', 'pdf');
hold on;
x = linspace(A_true - 4*sqrt(Var_A_hat1), A_true + 4*sqrt(Var_A_hat1), 100);
plot(x, normpdf(x, E_A_hat1, sqrt(Var_A_hat1)), 'r', 'LineWidth', 2);
title('实验1：N=10, 噪声方差=0.5');
xlabel('A的估计值');
ylabel('概率密度');
legend('仿真数据', '理论分布');

subplot(3,1,2);
histogram(A_hat2, 50, 'Normalization', 'pdf');
hold on;
x = linspace(A_true - 4*sqrt(Var_A_hat2), A_true + 4*sqrt(Var_A_hat2), 100);
plot(x, normpdf(x, E_A_hat2, sqrt(Var_A_hat2)), 'r', 'LineWidth', 2);
title('实验2：N=100, 噪声方差=0.5');
xlabel('A的估计值');
ylabel('概率密度');
legend('仿真数据', '理论分布');

subplot(3,1,3);
histogram(A_hat3, 50, 'Normalization', 'pdf');
hold on;
x = linspace(A_true - 4*sqrt(Var_A_hat3), A_true + 4*sqrt(Var_A_hat3), 100);
plot(x, normpdf(x, E_A_hat3, sqrt(Var_A_hat3)), 'r', 'LineWidth', 2);
title('实验3：N=100, 噪声方差=2.0');
xlabel('A的估计值');
ylabel('概率密度');
legend('仿真数据', '理论分布');
