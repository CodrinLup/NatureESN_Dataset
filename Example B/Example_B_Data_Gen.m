clc
clear all
close all

% Parameters 

N = 20;                                            % System dimension
L = 550;                                           % Signal Length

%% Input initialisation

noise = rand(1,L);                                 % White Noise

% Filter design
Ts = 1;                                            % Sampling time
Fs = 1/Ts;                                         % Sampling Frequency (Hz)
Fn = Fs/2;                                         % Nyquist Frequency (Hz)
Fco = Fs/10;                                       % Cutoff Frequency (Hz)
Wp = Fco/Fn;                                       % Normalised Cutoff Frequency (rad)
Ws = 1.6*Wp;                                       % Stopband Frequency (rad)
Rp = 3;                                            % Passband Ripple (dB)
Rs = 20;                                           % Stopband Ripple (dB)
[n,Wn]  = buttord(Wp,Ws,Rp,Rs);                    % Calculate Filter Order
[b,a]   = butter(n,Wn);                            % Calculate Filter Coefficients
[sos,g] = tf2sos(b,a);                             % Convert To Second Order Section Representation
figure(1)
freqz(sos, 1024, Fs)                               % Plot Filter Response (Bode Plot)
flago = 0;

% Filtering the input to the dynamics of the system

noise = filter(b,a,noise);
noise = noise - mean(noise);
noise = 2 * noise;

%% Target system generation

Aclosedtarget = zeros(N,N);
for j=1:N/2
    a1=2*rand-1;
    b1=2*rand-1;
    while(abs(a1+i*b1)>=0.9)
        a1=2*rand-1;
        b1=2*rand-1;
    end
    Aclosedtarget(2*j-1,2*j-1) = a1;
    Aclosedtarget(2*j,2*j) = a1;
    Aclosedtarget(2*j-1,2*j) = -b1;
    Aclosedtarget(2*j,2*j-1) = b1;
end
if(mod(N,2))
    Aclosedtarget(N,N) = 2*rand-1;
end
P = rand(N,N);
P = P/norm(P);
Aclosedtarget = P*Aclosedtarget*inv(P);
Btarget = 2*rand(N,1)-1;
Ctarget = 2*rand(1,N)-1;

tranz = floor(L/11);

CO = ctrb(Aclosedtarget, Btarget);                       % Controllability of the target system
OB = obsv(Aclosedtarget, Ctarget);                       % Observability of the target system
rOB = rank(OB);                                          % Controllability rank
rCO = 0;                                                 % Observability rank

% Save system matrices

save('matrices.mat','Aclosedtarget','Btarget','Ctarget');

%% Output generation

[y,state_training] = affinetarget(length(Aclosedtarget(1,:)), Aclosedtarget, Btarget, Ctarget, L, noise);
t = 0:1:L-1;

% % Can add post-synaptic noise to the output
SNR = 10;
y=awgn(y,SNR);

%% Target PLOTS

figure(2)
subplot(2,1,1)
plot(t,noise,'k','Linewidth',2);
xlabel('Time(s)','fontsize', 20)
ylabel('u(t)','fontsize', 20)
set(gca,'FontSize',20)
title ('a','fontsize', 20)
ylim([-0.5 1.5])
xlim([0 550]) ;
subplot(2,1,2)

plot(t,y,'k','Linewidth',2);
xlabel('Time(s)','fontsize', 20)
ylabel('y^*(t)','fontsize', 20)
set(gca,'FontSize',20)
xlim([0 550]);
title ('b','fontsize', 20)

% Save the whole dataset

output(1,1:1:L) = y;
input(1,1:1:L) = noise;

save('points.mat','input','output');

%% Training, validation and test data separation

input_training = input(1,1:1:L/2);
input_validation = input(1,L/2+1:1:3*L/4);
input_testing = input(1,3*L/4+1:1:L);
output_training = output(1,1:1:L/2);
output_validation = output(1,L/2+1:1:3*L/4);
output_testing = output(1,3*L/4+1:1:L);

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
