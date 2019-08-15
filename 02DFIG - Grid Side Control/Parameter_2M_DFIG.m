close all
clear all
clc                          
%PARAMETERS OF A 2MW DFIG
%IEEE - DFIM: Chapter 3 
%--------------------------------------------------------------------------
f = 50;                     % Stator frequency (Hz)
n = 1500;                   % Synchronous speed at 50 Hz|(rev/min)
Ps = 2e6;                   % Nominal stator three-phase active power|(MW)
Vs = 690;                   % Line-to-line nominal stator voltage in rms (V)
Is = 1760;                  % Each phase nominal stator current in rms (Amp)
Tem = 12732;                % Nominal torque at generator or motor modes (N.m)
%Stator connection Star
p = 2;                      % Pole pair 
Vr = 2070;                  % Line-to-line nominal rotor voltage in rms (reached at speed near zero) (V)
%Rotor connection Star
u = 0.34;                   % Stator/rotor turns ratio (relation between the stator and rotor)
Rs = 2.6e-3;                % Stator resistance (mohm)
Lsi = 87e-6;                % Stator leakage inductance (uH)
Lm = 2.5e-3;                % Magnetizing inductace (mH)
Rres = 26.1e-3;             %% Rotor resistance (mohm)
Rind = 783e-6;              %% Rotor leakage inductance (uH)
Rr = 2.9e-3;                % Rotor resistance referred to stator (mohm)
Lsr = 87e-6;                % Rotor leakage inductance referred to the stator (uH)
Ls = Lm + Lsi;              % Stator inductance (mH)
Lr = Lm + Lsr;              % Rotor inductance (mH)
%--------------------------------------------------------------------------
%Space for Rotor Side Converter
Q = 0;                      % For Reactive power = 0
smax = 0.25;                % Maximun slip 0.25
Fs = 1.28;                  % Stator Flux
Vbus = 1000;                 % Bus Voltage
%Mechanic 
J = 127;                    % Inertia
D = 1e-3;                   % Damping
%PI regulators
sigma = 1- Lm^2/(Ls*Lr); 
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
%--------------------------------------------------------------------------
%Space for Grid Side Converter
Cbus = 80e-3;               % DC bus capacitance
Rg = 20e-6;                 % Grid side filter´s resistance 1
Lg = 483e-6;                % Grid side filter´s inductance 1e-3

Kpg = 1/(1.5*Vs*sqrt(2/3)); 
Kqg = -Kpg;

%PI regulators
tau_ig = Lg/Rg;
wnig = 60*2*pi;

kp_idg = (2*wnig*Lg)-Rg;
kp_iqg = kp_idg;
ki_idg = (wnig^2)*Lg;
ki_iqg = ki_idg;

kp_v = -1000;   %-1000
ki_v = -300000;

%--------------------------------------------------------------------------
%PWM 
fsw = 4e3;                  % Switching frequency (Hz)
Ts = 1/fsw/f;               % Sample time (sec)

