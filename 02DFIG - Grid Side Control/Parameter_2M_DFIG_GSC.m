close all
clear all
clc       
%--------------------------------------------------------------------------
%PARAMETERS OF A 2MW DFIG
%IEEE - DFIM: Chapter 3 
%--------------------------------------------------------------------------
f = 60;%50                  % Stator frequency (Hz)
n = 1800; %1500             % Synchronous speed at 50 Hz|(rev/min)
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
Fs = 1.5 %1.8;              % Stator Flux
Vbus_ref = 1200;            % Bus Voltage
%Mechanic 
J = 90%130;                    % Inertia Kg*m^2
D = 0.1%1e-3;                   % Damping friction factor N.m.s
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
fsw = 4e3;                  %Switching frequency (Hz)
Ts = 1/fsw/f;               %Sample time (sec)

%--------------------------------------------------------------------------
%Space for Three blade wind turbine model
% Beta -> Lambda Vs Cp Graph
N = 100;                    %Gearbox Ratio
Radio = 44;                 %Radio
ro = 1.225;                 %Air desity kg/m3
%beta=[-2.5 -1.5 0 1.5 2.5 0];
beta=[0 0 0 0 0 0 0];
for k=1:7
    cont = 1;
    for lambda = 0.1:0.1:14
        lambdai(cont)=(1/((1/(lambda-0.02*beta(k))+(0.003/(beta(k)^3+1)))));
        Cp(cont)=0.73*(151/lambdai(cont)-0.58*beta(k)-0.002*beta(k)^2.14-13.2).*(exp(-18.4/lambdai(cont)));
        Ct(cont) = Cp (cont)/lambda;
        cont = cont+1;
    end
    lambda=[0.1:0.1:14];
    %figure (1)
    %plot(lambda,Cp), grid on, hold on,
    
    %Rotor Speed Vs Power Graph
    for Vv = 6:0.5:12   %Wind Velocity at 12 m/s
        cont2=1;
        for serie = 0.1:0.1:14
            Pt (cont2)= (0.5*ro*pi*(Radio)^2)*(Vv)^3*Cp(cont2);
            omega_m (cont2) = ((lambda(cont2)*Vv) /Radio)*N/(2*pi/60)
            cont2=cont2+1;
        end
        %figure (2)
        %plot(omega_m,Pt), grid on, hold on,
    end
end

% Lambda and CP optimum
cp_opt = max(Cp)
cp_opt_abs = abs(max(Cp))
posicion=find(Cp==cp_opt);
lambda_opt = abs(lambda(posicion))
beta = beta (k)     %Pitch angle

% Wind velocity Vs Wind Power
cont2=1;
for Vv = 0.1:0.1:15
    Pt (cont2)= (0.5*ro*pi*(Radio)^2)*(Vv)^3*cp_opt;
    cont2=cont2+1;
end
Vv=[0.1:0.1:15];
figure (3)
plot(Vv,Pt), grid on, hold on,
%--------------------------------------------------------------------------
