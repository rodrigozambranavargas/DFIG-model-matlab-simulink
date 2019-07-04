close all
clear all
clc

%DFIG parameters -> Rotor parameters referred to the stator side

f = 50;                     % Stator frequency (Hz)
Ps = 2e6;                   % Rated stator power (W)
n = 1500;                   % Rated rotational speed (rev/min)
Vs = 690;                   % Rated stator votage (V)
Is = 1760;                  % Rated stator current (A)
Tem = 12732;                % Rated torque (N.m)

p = 2;                      % Pole pair 
u = 1/3;                    % Stator/rotor turns ratio
Vr = 2070;                  % Rated rotor voltage (non-reached) (V)
smax = 1/3;                 % Maximun slip
Vr_stator = (Vr*smax)*u;    % Rated rotor voltage referred to stator  
Rs = 2.6e-3;                % Stator resistance (ohm)
Lsi = 0.087e-3;             % Leakage inductance (stator & rotor) (H) Inductacia de fuga
Lm = 2.5e-3;                % Magnetizing inductace (H)
Rr = 2.9e-3;                % Rotor resistance referred to stator
Ls = Lm + Lsi;              % Stator inductance (H)
Lr = Lm + Lsi;              % Rotor inductance (H)
Vbus = Vr_stator*sqrt(2);   % DC of bus voltage referred to stator (V)
sigma = 1- Lm^2/(Ls*Lr);    
Fs = Vs*sqrt(2/3)/(2*pi*f); % Stator Flux

J = 127;                    % Inertia
D = 1e-3;                   % Damping

fsw = 4e3;                  % Switching frequency (Hz)
Ts = 1/fsw/50;               % Sample time (sec) CHECK FREQUENCY 50

% PI regulators
tau_i = (sigma*Lr)/Rr;
tau_n = 0.05;
wni = 100*(1/tau_i);
wnn = 1/tau_n;

kp_id = (2*wni*sigma*Lr)-Rr;
kp_iq = kp_id;
ki_id = (wni^2)*Lr*sigma;
ki_iq = ki_id;
kp_n = (2*wnn*J)/p;
ki_n = ((wnn^2)*J)/p;
