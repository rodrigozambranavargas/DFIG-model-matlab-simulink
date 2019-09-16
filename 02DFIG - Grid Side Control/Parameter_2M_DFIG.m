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
smax = 0.33;                % Maximun slip 0.25
Fs = 1.28;                  % Stator Flux
Vbus_ref = 1000;            % Bus Voltage
%Mechanic 
J = 127;                    % Inertia Kg*m^2
D = 1e-3;                   % Damping friction factor N.m.s
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
Rg = 20e-6;                 % Grid side filter? resistance 1
Lg = 483e-6;                % Grid side filter? inductance 1e-3

Kpg = 1/(1.5*Vs*sqrt(2/3)); 
Kqg = -Kpg;

%PI regulators
tau_ig = Lg/Rg;
wnig = 60*2*pi;

kp_idg = (2*wnig*Lg)-Rg;
kp_iqg = kp_idg;
ki_idg = (wnig^2)*Lg;
ki_iqg = ki_idg;

kp_v = -1000;   
ki_v = -300000;

%--------------------------------------------------------------------------
%PWM 
fsw = 4e3;                  % Switching frequency (Hz)
Ts = 1/fsw/f;               % Sample time (sec)

%--------------------------------------------------------------------------
%Space for Three blade wind turbine model

N = 100;                    %Gearbox Ratio
Radio = 44;                 %Radio
ro = 1.225;                 %Air desity kg/m3 
beta = -0.5;                   %Pitch angle
V = [0.0000,0.5556,1.1111,1.6667,2.2222,2.7778,3.3333,3.8889,4.4444,...
    5.0000,5.5556,6.1111,6.6667,7.2222,7.7778,8.3333,8.8889,9.4444, ...
    10.0000,10.5556,11.1111,11.6667,12.2222,12.7778,13.3333,13.8889,...
    14.4444,15.0000];       %wind
cont = 1;

for lambda = 0.1:0.1:12
lambdai(cont)=(1/((1/(lambda-0.02*beta)+(0.003/(beta^3+1)))));
Cp(cont)=0.73*(151/lambdai(cont)-0.58*beta-0.002*beta^2.14-13.2).*(exp(-18.4/lambdai(cont)));
Ct(cont) = Cp (cont)/lambda;
cont = cont+1;
end 
lambda=[0.1:0.1:12];
plot (lambda,Cp);
hold on;

cp_opt = max(Cp)
posicion=find(Cp==cp_opt);
lambda_opt = lambda(posicion)
















% 
% N = 100;                    %Gearbox Ratio
% Radio = 44;                 %Radio
% ro = 1.225;                 %Air desity kg/m3 
% 
% % Cp and Ct curves
% beta = -0.6;                   %Pitch angle
% V = [0.0000,0.5556,1.1111,1.6667,2.2222,2.7778,3.3333,3.8889,4.4444,...
%     5.0000,5.5556,6.1111,6.6667,7.2222,7.7778,8.3333,8.8889,9.4444, ...
%     10.0000,10.5556,11.1111,11.6667,12.2222,12.7778,13.3333,13.8889,...
%     14.4444,15.0000];       %wind
% 
% % for beta = 0:1:0  % max power to Beta = -1,6 and wind speed 12,7778
% cont = 1;
% 
% for lambda = 0:0.42143:11.8   % 28 Cps and Cts
%     lambdai(cont)=(1/((1/(lambda-0.02*beta)+(0.003/(beta^3+1)))));
%     Cp(cont)=0.73*(151/lambdai(cont)-0.58*beta-0.002*beta^2.14-13.2).*(exp(-18.4/lambdai(cont)));
%     Ct(cont) = Cp (cont)/lambda;
%     Pt (cont)= (0.5*ro*pi*(Radio)^2)*(V(cont))^3*Cp(cont);
%     cont=cont+1; 
% end
% tab_lambda=[0.2:0.42143:11.8];
% plot (tab_lambda,Cp);
% hold on;
% 
% % plot (tab_lambda,Ct);
% % hold on;
% figure
% plot (V,Pt);
% hold on;
% % end
% 
% % Kopt for MPPT
% Cp_max = 0.4593;
% lambda_opt = 7.364;
% Kopt = ((0.5*ro*pi*(Radio^5)*Cp_max)/(lambda_opt)^3);
