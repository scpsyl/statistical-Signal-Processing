N = 1e5; % 发送比特数
SNR_dB = 0:0.5:20; % SNR范围，单位为dB
fs = 6; % 每个符号的采样点数
T = 1; % 符号持续时间
t = (0:fs-1)/fs; % 单个符号的时间向量

% 为CFSK选择频率（确保正交性）
f0 = 1; % 比特'0'的频率
f1 = 2; % 比特'1'的频率

% 初始化误码概率数组
Pe_CPSK = zeros(size(SNR_dB));
Pe_CFSK = zeros(size(SNR_dB));
Pe_CASK = zeros(size(SNR_dB));

for idx = 1:length(SNR_dB)
    snr = SNR_dB(idx);
    SNR_linear = 10^(snr/10);
    
    % 生成随机二进制数据
    bits = randi([0 1], N, 1);
    
    %% 调制过程
    
    % CPSK（BPSK）调制
    symbols_CPSK = 2*bits - 1; % 将比特映射为-1和+1
    
    % CFSK（BFSK）调制
    s0 = sqrt(2/T) * cos(2*pi*f0*t); % 比特'0'的信号
    s1 = sqrt(2/T) * cos(2*pi*f1*t); % 比特'1'的信号
    s_CFSK = zeros(N, fs);
    for n = 1:N
        if bits(n) == 0
            s_CFSK(n, :) = s0;
        else
            s_CFSK(n, :) = s1;
        end
    end
    
    % CASK（BASK）调制
    Es = 1; % 符号能量
    symbols_CASK = sqrt(2*Es) * bits; % 将比特映射为0和sqrt(2*Es)
    
    %% 信道（加入AWGN）
    
    % 计算噪声方差
    N0 = Es / SNR_linear;
    noise_std = sqrt(N0/2);
    
    % 为CPSK信号加入噪声
    noise_CPSK = noise_std * randn(N, 1);
    r_CPSK = symbols_CPSK + noise_CPSK;
    
    % 为CFSK信号加入噪声
    noise_CFSK = noise_std * randn(N, fs);
    r_CFSK = s_CFSK + noise_CFSK;
    
    % 为CASK信号加入噪声
    noise_CASK = noise_std * randn(N, 1);
    r_CASK = symbols_CASK + noise_CASK;
    
    %% 接收机（相干检测）
    
    % CPSK检测
    detected_bits_CPSK = r_CPSK > 0;
    
    % CFSK检测
    correlator_output0 = sum(r_CFSK .* repmat(s0, N, 1), 2);
    correlator_output1 = sum(r_CFSK .* repmat(s1, N, 1), 2);
    detected_bits_CFSK = correlator_output1 > correlator_output0;
    
    % CASK检测
    threshold = sqrt(Es) / 2;
    detected_bits_CASK = r_CASK > threshold;
    
    %% 计算误码概率
    
    Pe_CPSK(idx) = sum(bits ~= detected_bits_CPSK) / N;
    Pe_CFSK(idx) = sum(bits ~= detected_bits_CFSK) / N;
    Pe_CASK(idx) = sum(bits ~= detected_bits_CASK) / N;
end

%% 绘制P_e与SNR的关系曲线
figure;
semilogy(SNR_dB, Pe_CPSK, 'b-o', 'LineWidth', 2);
hold on;
semilogy(SNR_dB, Pe_CFSK, 'r-s', 'LineWidth', 2);
semilogy(SNR_dB, Pe_CASK, 'g-^', 'LineWidth', 2);
xlabel('SNR (dB)');
ylabel('误码概率 (P_e)');
legend('CPSK', 'CFSK', 'CASK');
grid on;
title('CPSK、CFSK和CASK的误码概率与SNR关系');
