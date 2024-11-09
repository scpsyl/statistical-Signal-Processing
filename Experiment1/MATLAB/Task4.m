clear; close all; clc;

% 参数设置
N = 1000;                   % 每个信号的样本数
numTrials = 1e5;            % 蒙特卡洛仿真次数
SNR_dB = -20:2:20;          % 信噪比范围（以 dB 为单位）
SNR_lin = 10.^(SNR_dB/10);  % 线性信噪比
alpha_values = [1e-6, 1e-4];% 虚警概率
f = 0.1;                    % 信号频率（归一化频率）
t = (0:N-1)';               % 时间向量

% 信号类型
signal_types = {'RandomAmpPhase', 'RandomPhase'};

% 预分配存储空间
P_D_vs_SNR = cell(length(signal_types), length(alpha_values));

% 主循环：遍历每个信号类型
for s_idx = 1:length(signal_types)
    signal_type = signal_types{s_idx};

    % 主循环：遍历每个 SNR 值
    for idx = 1:length(SNR_dB)
        SNR = SNR_lin(idx);

        % 噪声方差（固定信号平均功率为 Ps = 2）
        Ps = 2;                          % 信号平均功率
        sigma_n2 = Ps / SNR;             % 噪声方差
        sigma_n = sqrt(sigma_n2 / 2);    % 噪声标准差（复数噪声，每个分量除以 2）

        % 生成噪声（复高斯白噪声）
        n_real = sigma_n * randn(N, numTrials);
        n_imag = sigma_n * randn(N, numTrials);
        n = n_real + 1j * n_imag;

        % 根据信号类型生成信号 s[n]
        switch signal_type
            case 'RandomAmpPhase' % 随幅随相
                % 生成随机幅度（瑞利分布）和相位（均匀分布）
                A = raylrnd(1, 1, numTrials);    % 瑞利分布参数 sigma = 1
                phi = 2 * pi * rand(1, numTrials);
                % 生成信号 s[n]
                s = repmat(A, N, 1) .* exp(1j * (2 * pi * f * t + repmat(phi, N, 1)));
            case 'RandomPhase' % 随相（固定幅度）
                A = 1; % 固定幅度
                phi = 2 * pi * rand(1, numTrials);
                s = A * exp(1j * (2 * pi * f * t + repmat(phi, N, 1)));
            otherwise
                error('未知的信号类型');
        end

        % 假设 H1 下的接收信号
        r_H1 = s + n;
        % 假设 H0 下的接收信号
        r_H0 = n;

        % 计算测试统计量 T
        T_H1 = sum(abs(r_H1).^2);
        T_H0 = sum(abs(r_H0).^2);

        % 对 T_H0 排序以确定阈值
        T_H0_sorted = sort(T_H0);

        % 对于每个 alpha，计算对应的阈值和检测概率
        for a_idx = 1:length(alpha_values)
            alpha = alpha_values(a_idx);

            % 确定阈值 gamma，使得 P_FA = alpha
            idx_gamma = ceil((1 - alpha) * numTrials);
            if idx_gamma <= 0
                idx_gamma = 1;
            end
            gamma_alpha = T_H0_sorted(idx_gamma);

            % 计算在该阈值下的检测概率 P_D
            P_D = sum(T_H1 > gamma_alpha) / numTrials;

            % 存储检测概率
            P_D_vs_SNR{s_idx, a_idx}(idx, :) = [P_D, SNR_dB(idx)];
        end
    end
end

% 绘制 E_s/N_0 与 P_D 的关系曲线（横轴为 P_D，纵轴为 E_s/N_0）
figure;
plotStyles = {'o-', 's-', '^--', 'd--'};
legendEntries = {};

for s_idx = 1:length(signal_types)
    for a_idx = 1:length(alpha_values)
        data = P_D_vs_SNR{s_idx, a_idx};
        P_D_data = data(:, 1);
        SNR_data = data(:, 2);

        % 将 SNR_dB 作为纵轴，P_D 作为横轴
        plot(P_D_data, SNR_data, plotStyles{(s_idx - 1) * length(alpha_values) + a_idx}, 'LineWidth', 2);
        hold on;

        % 生成图例条目
        switch signal_types{s_idx}
            case 'RandomAmpPhase'
                signal_desc = '随幅随相';
            case 'RandomPhase'
                signal_desc = '随相';
        end
        legendEntries{end+1} = [signal_desc, ', \alpha = ', num2str(alpha_values(a_idx))];
    end
end

xlabel('检测概率 P_D');
ylabel('E_s/N_0 (dB)');
legend(legendEntries, 'Location', 'Best');
grid on;
title('不同信号类型和 \alpha 下的 E_s/N_0 与检测概率 P_D 的关系');
xlim([0 1]);

