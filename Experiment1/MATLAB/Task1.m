% Data generation and parameter setting
A = 1;  % Known signal level
N = 1000;  % Number of samples
SNR_dB = 10;  % Signal-to-noise ratio (in dB)
SNR = 10^(SNR_dB/10);  % Convert SNR to linear value

% Generate Gaussian noise with mean 0 and variance controlled by SNR
n = randn(1, N);  % Standard Gaussian noise, mean 0, variance 1

% Generate signals under two hypotheses
z_H0 = n;  % Under H0: only noise
z_H1 = A + n;  % Under H1: signal A plus noise

% Adjust noise power according to SNR
sigma = sqrt(1/SNR);  % Calculate noise standard deviation based on SNR
n_adjusted = sigma * n;
z_H0 = n_adjusted;
z_H1 = A + n_adjusted;

% Set detection threshold
threshold = A / 2;  % Simple threshold, can be optimized based on actual needs

% Apply detection rule
detected_H1 = z_H1 > threshold;  % Detection under H1 hypothesis
detected_H0 = z_H0 > threshold;  % Detection under H0 hypothesis

% % Analyze performance
% P_d = mean(detected_H1);  % Detection probability P_d, i.e., probability of correctly judging as H1
% P_fa = mean(detected_H0);  % False alarm probability P_fa, i.e., probability of incorrectly judging as H1
% fprintf('Detection probability (Pd): %.3f\n', P_d);
% fprintf('False alarm probability (Pfa): %.3f\n', P_fa);

% Recalculate Pd and Pfa by adjusting SNR
SNR_values = -5:1:20;  % SNR range (in dB)
P_d_values = zeros(size(SNR_values));
P_fa_values = zeros(size(SNR_values));

for i = 1:length(SNR_values)
    SNR = 10^(SNR_values(i)/10);
    sigma = sqrt(1/SNR);
    n_adjusted = sigma * n;
    z_H0 = n_adjusted;
    z_H1 = A + n_adjusted;
    
    detected_H1 = z_H1 > threshold;
    detected_H0 = z_H0 > threshold;
    
    P_d_values(i) = mean(detected_H1);
    P_fa_values(i) = mean(detected_H0);
end

% Plot ROC curve
figure;
plot(P_fa_values, P_d_values, '-o');
xlabel('False alarm probability (Pfa)');
ylabel('Detection probability (Pd)');
title('ROC Curve');
