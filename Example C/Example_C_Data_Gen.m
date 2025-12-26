clc
clear all
close all

%% Fruitfly data level selection

% Parameters
Ts = 0.0025;                                            % Sampling time
Nolags = 5;                                             % Input lags
trans = 1600;                                           % Number of transitory points (first points of the signal)
L = 8000;                                               % Level signal Length
L_stationary = 6400;                                    % Number of stationary points (points that are after the transitory points)
data = importdata('170_PreProcessed.mat');
input_total = data.u;
output_total = data.y;

% Level 1: 1-3*L/2
% Level 2: 3-5*L/2
% Level 3: 5-7*L/2
% Level 4: 7-9*L/2
% Level 5: 9-11*L/2
% Selecting the L2 level

%     u_trans(1,:) = input_total(3*L/2+1:5*L/2,:);
%     y_trans(1,:) = output_total(3*L/2+1:5*L/2,:);

% Selecting the L3 level

u_trans(1,:) = input_total(3*L/2+1:5*L/2,:);
y_trans(1,:) = output_total(3*L/2+1:5*L/2,:);

% Eliminating the first transitory points

u(1,:) = u_trans(1,trans+1:L);
y(1,:) = y_trans(1,trans+1:L);


%% Target PLOTS

t = 0:Ts:L_stationary*Ts-Ts;

figure(1)
subplot(2,1,1)
plot(t,u,'k','Linewidth',1);
xlabel('Time(s)','fontsize', 20)
ylabel('Amplitude','fontsize', 20)
set(gca,'FontSize',20)
subplot(2,1,2)
plot(t,y,'k','Linewidth',1);
xlabel('Time(s)','fontsize', 20)
ylabel('Amplitude','fontsize', 20)
set(gca,'FontSize',20)
output(1,1:1:L_stationary) = y;
input(1,1:1:L_stationary) = u;

% Save the whole Level dataset

output(1,1:1:L_stationary) = y;
input(1,1:1:L_stationary) = u;

save('points.mat','input','output');

%% Training, validation and test data separation

iinput_training = input(1,1:1:600);
for j = 2:5
    iinput_training = [iinput_training input(1,(j-1)*800+1:1:j*800-200)];
end

input_training = zeros(Nolags, length(iinput_training));

% Adding the input lags from the original input signal
for i=1:Nolags
    input_training(i,:) = [zeros(1,i-1) iinput_training(1:1:length(iinput_training)-i+1)];
end

iinput_testing = input(1,601:1:800);
for j=2:3
    iinput_testing = [iinput_testing input(1,j*800-199:1:j*800)];
end

input_testing = zeros(Nolags, length(iinput_testing));
for i=1:Nolags
    input_testing(i,:) = [zeros(1,i-1) iinput_testing(1:1:length(iinput_testing)-i+1)];
end

ooutput_training = output(1,1:1:600);
for j = 2:5
    ooutput_training = [ooutput_training output(1,(j-1)*800+1:1:j*800-200)];
end

output_testing = output(1,601:1:800);
for j=2:3
    output_testing = [output_testing output(1,j*800-199:1:j*800)];
end

% Mean normalisation

mean_output_training = mean(ooutput_training);
output_training = ooutput_training - mean_output_training;
output_testing = output_testing + mean_output_training - mean(output_testing);

orig_output_training = output_training;
tranz = floor(L_stationary/11);

save('training.mat','input_training','output_training');
save('testing.mat','input_testing','output_testing');