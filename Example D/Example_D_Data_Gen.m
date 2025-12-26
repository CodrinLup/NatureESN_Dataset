clear all
close all
clc

%% Target NARMA10 system generation

% Parameters
L = 12360;                                              % Signal Length
T = L+40;                                               % sequence length
u = rand(1, T) * 0.5;                                   % uniformly distributed input in [0, 0.5]
y = zeros(1, T);                                        % output initialisation

% Initialise first 10 values
y(1:10) = 0.0;

% Generate NARMA10 output sequence
for t = 11:T-1
    sum_y = sum(y(t-10+1:t));  
    y(t+1) = 0.3 * y(t) + 0.05 * y(t) * sum_y + 1.5 * u(t-9) * u(t) + 0.1;
end

u = u(:,41:end);
y = y(:,41:end);

%% Target PLOTS

t = 0:1:L-1;

% % Can add post-synaptic noise to the output
% SNR = 50;
% y=awgn(y,SNR);

% Input and output generation plot

figure(1)
subplot(2,1,1)
plot(t,u,'k','Linewidth',2);
xlabel('Time(s)','fontsize', 20)
ylabel('u(t)','fontsize', 20)
set(gca,'FontSize',20)
title ('a','fontsize', 20)
xlim([0 L])
ylim([0 0.5])
subplot(2,1,2)

plot(t,y,'k','Linewidth',2);
xlabel('Time(s)','fontsize', 20)
ylabel('y^*(t)','fontsize', 20)
set(gca,'FontSize',20)
xlim([0 L])
ylim([0 1])
title ('b','fontsize', 20)

% Save the whole dataset

output(1,1:1:L) = y;
input(1,1:1:L) = u;
save('points.mat','input','output');

%% Training, validation and test data separation

input_training = input(1,1:1:0.7*L);
input_validation = input(1,0.7*L+1:1:0.85*L);
input_testing = input(1,0.85*L+1:1:L);
output_training = output(1,1:1:L*0.7);
output_validation = output(1,0.7*L+1:1:L*0.85);
output_testing = output(1,0.85*L+1:1:L);

% Mean normalisation

ooutput_training = output_training;
mean_output_training = mean(output_training);
%mean_output_training = 0;
output_training = ooutput_training - mean_output_training;
%output_validation = output_validation - mean_output_training;
%output_testing = output_testing - mean_output_training;
orig_output_training = output_training;

save('training.mat','input_training','output_training');
save('testing.mat','input_testing','output_testing');