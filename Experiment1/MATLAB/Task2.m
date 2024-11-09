% % Parameter settings
% A = 1;          % Signal level
% sigma = 0.5;    % Noise standard deviation
% num_trials = 1000;  % Number of trials
% N_values = 1:10;  % Range of observation points

% Pe_values = zeros(size(N_values));  % Store error probability for each number of observation points

% for n_idx = 1:length(N_values)
%     N = N_values(n_idx);  % Current number of observation points
%     errors = 0;  % Record the number of errors
    
%     for trial = 1:num_trials
%         % Generate noise
%         n = sigma * randn(1, N);  % Generate N Gaussian noise samples
%         z = A + n;  % Observed signal
        
%         % Detection strategy: calculate the mean and compare with the threshold
%         z_mean = mean(z);  % Calculate the mean
%         threshold = A / 2;  % Set the threshold
        
%         % Determine if it is H1 (signal present) or H0 (signal absent)
%         if z_mean > threshold
%             detected_H1 = 1;  % Detected as H1
%         else
%             detected_H1 = 0;  % Detected as H0
%         end
        
%         % Error judgment
%         if detected_H1 == 0  % Actual signal present, but detected as H0
%             errors = errors + 1;
%         end
%     end
    
%     % Calculate error probability Pe
%     Pe = errors / num_trials;
%     Pe_values(n_idx) = Pe;  % Store the error probability for the current number of observation points
% end

% % Plot the relationship between the number of observation points and Pe
% figure;
% plot(N_values, Pe_values, '-o', 'LineWidth', 2);
% xlabel('Number of observation points N');
% ylabel('Error probability Pe');
% title('Relationship between the number of observation points and error probability Pe');
% grid on;

% 初始化实验参数
A = 1;  % 信号电平
sigma = 1;  % 噪声标准差
N_values = 1:2:50;  % 不同的观测点数
num_trials = 1000;  % 每个观测点数的实验次数
Pe_values = zeros(size(N_values));  % 存储每个 N 下的误差概率

% 循环不同的观测点数
for idx = 1:length(N_values)
    N = N_values(idx);
    errors = 0;  % 记录误判次数

    % 多次试验
    for trial = 1:num_trials
        % 在假设 H0 下：生成 N 个仅包含噪声的样本
        noise_H0 = sigma * randn(1, N);
        
        % 在假设 H1 下：生成 N 个包含信号和噪声的样本
        signal_H1 = A + sigma * randn(1, N);

        % 计算观测值的平均值
        Z_H0 = mean(noise_H0);
        Z_H1 = mean(signal_H1);

        % 设置判别阈值
        threshold = A / 2;

        % 判别
        if Z_H0 > threshold
            errors = errors + 1;  % 假设 H0 时误判为 H1
        end
        if Z_H1 <= threshold
            errors = errors + 1;  % 假设 H1 时误判为 H0
        end
    end

    % 计算误差概率 Pe
    Pe_values(idx) = errors / (2 * num_trials);  % 误判次数除以总判断次数
end

% 绘制观测点数 N 与误差概率 Pe 的关系曲线
figure;
plot(N_values, Pe_values, '-o', 'LineWidth', 1.5);
xlabel('Number of Observations (N)');
ylabel('Error Probability (Pe)');
title('Relationship between Number of Observations and Error Probability');
grid on;
