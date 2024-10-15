% 参数初始化
SNR_dB = 0:2:20; % 信噪比范围 (dB)
num_trials = 10000; % 实验次数
N = 100; % 每次实验的观测点数

P_D_amplitude_phase = zeros(length(SNR_dB), 1);
P_D_phase_only = zeros(length(SNR_dB), 1);
P_e_amplitude_phase = zeros(length(SNR_dB), 1);
P_e_phase_only = zeros(length(SNR_dB), 1);

for i = 1:length(SNR_dB)
    SNR_linear = 10^(SNR_dB(i) / 10); % 将 dB 转换为线性 SNR
    noise_power = 1/SNR_linear; % 噪声功率与 SNR 相关

    % 多次实验统计
    errors_amplitude_phase = 0;
    errors_phase_only = 0;
    
    for trial = 1:num_trials
        % 随幅随相信号生成
        A = 1 + 0.2*randn; % 随机幅度变化
        phi = 2 * pi * rand; % 随机相位
        noise = sqrt(noise_power) * randn(N, 1);
        signal_amplitude_phase = A * cos(2*pi*100*(1:N)' + phi) + noise;
        
        % 随相信号生成
        A0 = 1; % 恒定幅度
        noise_phase = sqrt(noise_power) * randn(N, 1);
        signal_phase_only = A0 * cos(2*pi*100*(1:N)' + phi) + noise_phase;

        % 检测器判断（这里我们使用简单的能量检测）
        detected_amplitude_phase = sum(signal_amplitude_phase.^2) > threshold; % 阈值检测
        detected_phase_only = sum(signal_phase_only.^2) > threshold; % 阈值检测
        
        % 更新误差计数
        if ~detected_amplitude_phase
            errors_amplitude_phase = errors_amplitude_phase + 1;
        end
        if ~detected_phase_only
            errors_phase_only = errors_phase_only + 1;
        end
    end
    
    % 计算误差概率 Pe 和 检测概率 PD
    P_e_amplitude_phase(i) = errors_amplitude_phase / num_trials;
    P_e_phase_only(i) = errors_phase_only / num_trials;
    
    % 计算检测概率 PD
    P_D_amplitude_phase(i) = 1 - P_e_amplitude_phase(i);
    P_D_phase_only(i) = 1 - P_e_phase_only(i);
end

% 绘图
figure;
plot(P_D_amplitude_phase, P_e_amplitude_phase, '-o', 'DisplayName', '随幅随相信号');
hold on;
plot(P_D_phase_only, P_e_phase_only, '--o', 'DisplayName', '随相信号');
xlabel('检测概率 P_D');
ylabel('误差概率 P_e');
legend;
grid on;
title('随幅随相信号与随相信号的检测性能比较');
