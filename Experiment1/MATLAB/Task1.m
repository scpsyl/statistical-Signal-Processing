% 初始化参数
A_values = [0.5, 1.0, 2.0];  % 不同的信号电平
snr_values = [1, 5, 10, 20];  % 不同的信噪比值
num_samples = 1000;  % 样本数量
threshold_range = linspace(0, max(A_values) + 1, 100);  % 阈值范围

% 存储结果
false_alarm_rates = zeros(length(snr_values), length(threshold_range), length(A_values));
detection_rates = zeros(length(snr_values), length(threshold_range), length(A_values));

% 循环不同的 SNR 和 A 值
for k = 1:length(A_values)
    A = A_values(k);
    for i = 1:length(snr_values)
        snr = snr_values(i);
        noise_std = A / sqrt(2 * snr);  % 根据 SNR 计算噪声标准差

        % 生成 H0 假设下的噪声数据
        noise = noise_std * randn(1, num_samples);

        % 生成 H1 假设下的信号 + 噪声数据
        signal_noise = A + noise_std * randn(1, num_samples);

        % 计算不同阈值下的假设检验结果
        for j = 1:length(threshold_range)
            threshold = threshold_range(j);

            % 误判概率（False Alarm Rate）和检测率（Detection Rate）
            false_alarm_rates(i, j, k) = sum(noise > threshold) / num_samples;
            detection_rates(i, j, k) = sum(signal_noise > threshold) / num_samples;
        end
    end
end

% 绘制 ROC 曲线
figure;
for k = 1:length(A_values)
    A = A_values(k);
    subplot(1, length(A_values), k);
    hold on;
    for i = 1:length(snr_values)
        plot(false_alarm_rates(i, :, k), detection_rates(i, :, k), '-o', 'DisplayName', sprintf('SNR = %d dB', snr_values(i)));
    end
    xlabel('False Alarm Rate');
    ylabel('Detection Rate');
    title(sprintf('ROC Curve for A = %.1f', A));
    legend;
    grid on;
end

% 绘制误判概率和检测率随 SNR 和信号电平的变化
figure;
for k = 1:length(A_values)
    subplot(1, length(A_values), k);
    hold on;
    plot(snr_values, squeeze(detection_rates(:, end, k)), '-o', 'DisplayName', 'Detection Rate');
    plot(snr_values, squeeze(false_alarm_rates(:, end, k)), '-o', 'DisplayName', 'False Alarm Rate');
    xlabel('SNR (dB)');
    ylabel('Rate');
    title(sprintf('Performance vs SNR for A = %.1f', A_values(k)));
    legend;
    grid on;
end
