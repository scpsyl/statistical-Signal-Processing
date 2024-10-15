% Parameter settings
N = 1000;  % Signal length
num_trials = 1000;  % Number of experiments
SNR_dB_values = -5:2:20;  % SNR range (dB)
Pe_CPSK = zeros(size(SNR_dB_values));  % CPSK error probability
Pe_CFSK = zeros(size(SNR_dB_values));  % CFSK error probability
Pe_CASK = zeros(size(SNR_dB_values));  % CASK error probability

% Generate random bit sequence
data_bits = randi([0 1], 1, N);

% CPSK modulation
CPSK_signal = exp(1i * pi * data_bits);  % Phase modulation (0->0°, 1->180°)

% CFSK modulation (frequency shift keying, using two frequencies)
f1 = 1; f2 = 2;  % Two frequencies
t = (0:N-1)/N;
CFSK_signal = cos(2*pi*f1*t).* (data_bits == 0) + cos(2*pi*f2*t).* (data_bits == 1);

% CASK modulation (amplitude shift keying, 0 and 1 use different amplitudes)
A1 = 1; A2 = 2;
CASK_signal = A1 * (data_bits == 0) + A2 * (data_bits == 1);

% Add noise and design receiver

for idx = 1:length(SNR_dB_values)
    SNR_dB = SNR_dB_values(idx);
    SNR = 10^(SNR_dB/10);  % Convert SNR from dB to linear
    
    % Calculate noise variance
    noise_variance = 1/SNR;
    
    errors_CPSK = 0;  % Count CPSK errors
    errors_CFSK = 0;  % Count CFSK errors
    errors_CASK = 0;  % Count CASK errors
    
    for trial = 1:num_trials
        % Generate Gaussian noise
        noise = sqrt(noise_variance/2) * (randn(1, N) + 1i * randn(1, N));
        
        % CPSK signal with noise
        received_CPSK = CPSK_signal + noise;
        detected_CPSK = real(received_CPSK) > 0;  % Threshold detection
        
        % CFSK signal with noise
        received_CFSK = CFSK_signal + sqrt(noise_variance) * randn(1, N);
        detected_CFSK = (sum(received_CFSK .* cos(2*pi*f1*t)) > sum(received_CFSK .* cos(2*pi*f2*t)));
        
        % CASK signal with noise
        received_CASK = CASK_signal + sqrt(noise_variance) * randn(1, N);
        detected_CASK = received_CASK > (A1 + A2)/2;  % Threshold detection
        
        % Count errors
        errors_CPSK = errors_CPSK + sum(detected_CPSK ~= data_bits);
        errors_CFSK = errors_CFSK + sum(detected_CFSK ~= data_bits);
        errors_CASK = errors_CASK + sum(detected_CASK ~= data_bits);
    end
    
    % Calculate error probability
    Pe_CPSK(idx) = errors_CPSK / (N * num_trials);
    Pe_CFSK(idx) = errors_CFSK / (N * num_trials);
    Pe_CASK(idx) = errors_CASK / (N * num_trials);
end

% Plot error probability curves
figure;
semilogy(SNR_dB_values, Pe_CPSK, '-o', 'DisplayName', 'CPSK');
hold on;
semilogy(SNR_dB_values, Pe_CFSK, '-x', 'DisplayName', 'CFSK');
semilogy(SNR_dB_values, Pe_CASK, '-s', 'DisplayName', 'CASK');
xlabel('SNR (dB)');
ylabel('Error Probability Pe');
title('Relationship between SNR and Error Probability');
legend('show');
grid on;
