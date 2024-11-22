clear;
clc;

% 参数设定
sigma_A_sq = 0.16;        % 幅度A的方差
sigma_n_sq = 0.25;        % 噪声n的方差
N = 1000;                 % 采样次数
num_trials = 10000;       % 重复次数

% 计算标准差
sigma_A = sqrt(sigma_A_sq);
sigma_n = sqrt(sigma_n_sq);

% 生成A的随机值 (均值为0，方差为0.16)
A = sigma_A * randn(num_trials, 1);

% 生成噪声 (均值为0，方差为0.25)
noise = sigma_n * randn(num_trials, N);

% 生成观测数据 z = A + n
Z = A(:, ones(1, N)) + noise;  % 每组数据包含1000次采样

% 估计方法1：MLE估计
A_hat1 = mean(Z, 2);

% 估计方法2：MAP估计
c = sigma_A_sq / (sigma_A_sq + sigma_n_sq / N);
A_hat_MAP = c * A_hat1;

% 理论期望和方差
% 样本均值估计量
E_A_hat1 = 0;  % 无偏
Var_A_hat1 = sigma_A_sq + sigma_n_sq / N;

% MAP估计量
E_A_hat_MAP = 0;  % 无偏
Var_A_hat_MAP = sigma_A_sq^2 / (sigma_A_sq + sigma_n_sq / N);

% 实际结果
mean_A_hat1 = mean(A_hat1);
var_A_hat1 = var(A_hat1);

mean_A_hat_MAP = mean(A_hat_MAP);
var_A_hat_MAP = var(A_hat_MAP);

% 输出结果
fprintf('实验2：N=%d, 噪声方差=%.2f\n\n', N, sigma_n_sq);

fprintf('估计方法1：最大似然估计 (Maximum Likelihood Estimator)\n');
fprintf('理论期望：E[A_hat1] = %.4f\n', E_A_hat1);
fprintf('实际期望：E[A_hat1] = %.4f\n', mean_A_hat1);
fprintf('理论方差：Var[A_hat1] = %.6f\n', Var_A_hat1);
fprintf('实际方差：Var[A_hat1] = %.6f\n\n', var_A_hat1);

fprintf('估计方法2：MAP估计 (Maximum A Posteriori Estimator)\n');
fprintf('理论期望：E[A_hat_MAP] = %.4f\n', E_A_hat_MAP);
fprintf('实际期望：E[A_hat_MAP] = %.4f\n', mean_A_hat_MAP);
fprintf('理论方差：Var[A_hat_MAP] = %.6f\n', Var_A_hat_MAP);
fprintf('实际方差：Var[A_hat_MAP] = %.6f\n\n', var_A_hat_MAP);

% 可视化结果
figure;

% 估计方法1的直方图与理论分布
subplot(2,1,1);
histogram(A_hat1, 50, 'Normalization', 'pdf');
hold on;
x1 = linspace(min(A_hat1), max(A_hat1), 1000);
y1 = normpdf(x1, E_A_hat1, sqrt(Var_A_hat1));
plot(x1, y1, 'r', 'LineWidth', 2);
title('估计方法1：MLE估计的分布');
xlabel('A的估计值');
ylabel('概率密度');
legend('仿真数据', '理论分布');
grid on;

% 估计方法2的直方图与理论分布
subplot(2,1,2);
histogram(A_hat_MAP, 50, 'Normalization', 'pdf');
hold on;
x2 = linspace(min(A_hat_MAP), max(A_hat_MAP), 1000);
y2 = normpdf(x2, E_A_hat_MAP, sqrt(Var_A_hat_MAP));
plot(x2, y2, 'r', 'LineWidth', 2);
title('估计方法2：MAP估计的分布');
xlabel('A的估计值');
ylabel('概率密度');
legend('仿真数据', '理论分布');
grid on;
