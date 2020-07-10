function [synchr_index, tConv, in_freq_absPow,delayPh]=solveODEreduc(plotflag, par)
% input set of parameters:
% par = [P w1 w2 w3 w4 w5 w6 w7 q AMP FREQ phase]
%
% output:
%   synchronization index
%   time needed for convergence
%   absolute power of input frequency
%   phase delay

% Settings for the solver
options = odeset('InitialStep',1e-03,'MaxStep',0.005);
% Define simulation time 
t_end=20;
timestep=0.002;
tRange= 0 : timestep : t_end-timestep;
Fs=1/timestep;

x_ini= [0 0 0];
phase = par(12);
in_freq= par(11);
ampl=par(10);
offset= par(1);
thalf = t_end/2;     % first half of simulation where no transition allowed

%prepare constant drive - parameter offset used
constantDrive = offset * ones(size(tRange));

% simulate with a constant input first
% the purpose is to find the transition time: when the constant input
% should become oscillating input
parameters={tRange, constantDrive,par(2),par(3),par(4),par(5),par(6),par(7),par(8),par(9)};
[t,x]=ode45(@modelFunqVarInput,tRange,x_ini,options,parameters);

% find the peaks in both the signal and its first derivative
% the peaks represent the start of phases 0, pi/2, pi, 3pi/2
X = x(:,1);
XX = [0; diff(X)];
switch phase
    case 0
        [~,IND] = findpeaks(XX);
    case 1
        [~,IND] = findpeaks(X);
    case 2
        [~,IND] = findpeaks(-XX);
    case 3
        [~,IND] = findpeaks(-X);
    otherwise
        error('check phase value')
end
clear X XX

count=1;
for i=length(IND)-1:-1:1        % cleaning up the phase indices
    if IND(i)==IND(i+1)-count
        IND(i)=[];
        count= count+1;
    else
        count=1;
    end
end
transIND = IND(find(t(IND)>thalf,1));   % transition index, first after thalf
transitionT = t(transIND);              % transition time


% prepare the oscillatory input - starts at transitionT with phase 0
oscillDrive=offset+ampl*sin(2*pi*in_freq*tRange);
oscillDrive = circshift(oscillDrive,transIND);
oscillDrive(1:transIND) = offset*ones(1,transIND); 

% simulate again , now with oscillatory input
parameters={tRange, oscillDrive,par(2),par(3),par(4),par(5),par(6),par(7),par(8),par(9)};
[t,y]=ode45(@modelFunqVarInput,tRange,x_ini,options,parameters);


% make up the attractor set to detect convergence in all 3 dimensions
tolerance = 1e-3;
indP = round(17*size(y,1)/20);
attrSet = uniquetol(y(indP:end,:), tolerance,'ByRows',true);

% find the timpoint of convergence
for j  = indP :-1 :1
    if ~ismembertol(y(j, :), attrSet, 10*tolerance, 'ByRows',true)
        convergedAt = tRange(j+1);
        break
    end
end
        
% time needed for convergence
tConv = convergedAt - transitionT;
tConv(tConv<0) = 0;


% find the delay of between y1 and oscillDrive, with oscillDrive being the
% reference
delay = finddelay(oscillDrive(indP:end), y(indP:end,1));     % this is in timesteps
delayT = delay*timestep;

% delay in phase, phase difference
delayPh = 2*pi*(delayT*in_freq);
if delayPh < -pi
    delayPh = delayPh + 2*pi;
end
if delayPh > pi
    delayPh = delayPh - 2*pi;
end

% plot the response of the system and indicate the timepoint of
% convergence
if plotflag
    figure(1)
    subplot(2,1,1)
    plot(t,oscillDrive);
    hold on
    stem(convergedAt, 0.5)
    legend('external drive P(t)', 'convergence timepoint')
    ylabel('P(t)')
    
    subplot(2,1,2)
    plot(t,y(:,1))
    hold on
    stem(convergedAt, 0.5)
    legend( 'excitatory population E(t)', 'convergence timepoint')
    xlabel('time (s)')
    ylabel('E(t)')
    hold off
end

% run spectral analysis on the last third of system response
ypart = y(round(2*end/3):end,1);    %last third of system response
[out_freq, powers, in_freq_absPow]=freq_analys(ypart,Fs,plotflag,in_freq);
synchr_index=0;
for i=1:length(out_freq)
    if out_freq(i)>=in_freq-0.2 && out_freq(i)<=in_freq+0.2
        synchr_index=powers(i);
        break
    end
end
    



