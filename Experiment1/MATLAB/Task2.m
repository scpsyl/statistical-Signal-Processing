% Parameter settings
A = 1;          % Signal level
sigma = 0.5;    % Noise standard deviation
num_trials = 1000;  % Number of trials
N_values = 1:10;  % Range of observation points

Pe_values = zeros(size(N_values));  % Store error probability for each number of observation points

for n_idx = 1:length(N_values)
    N = N_values(n_idx);  % Current number of observation points
    errors = 0;  % Record the number of errors
    
    for trial = 1:num_trials
        % Generate noise
        n = sigma * randn(1, N);  % Generate N Gaussian noise samples
        z = A + n;  % Observed signal
        
        % Detection strategy: calculate the mean and compare with the threshold
        z_mean = mean(z);  % Calculate the mean
        threshold = A / 2;  % Set the threshold
        
        % Determine if it is H1 (signal present) or H0 (signal absent)
        if z_mean > threshold
            detected_H1 = 1;  % Detected as H1
        else
            detected_H1 = 0;  % Detected as H0
        end
        
        % Error judgment
        if detected_H1 == 0  % Actual signal present, but detected as H0
            errors = errors + 1;
        end
    end
    
    % Calculate error probability Pe
    Pe = errors / num_trials;
    Pe_values(n_idx) = Pe;  % Store the error probability for the current number of observation points
end

% Plot the relationship between the number of observation points and Pe
figure;
plot(N_values, Pe_values, '-o', 'LineWidth', 2);
xlabel('Number of observation points N');
ylabel('Error probability Pe');
title('Relationship between the number of observation points and error probability Pe');
grid on;
