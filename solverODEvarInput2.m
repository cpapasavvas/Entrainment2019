function [oscillating,synchr_index, tConv, in_freq_absPower,delayPh]=solverODEvarInput2(plotflag, par, phase)
% par = [P w1 w2 w3 w4 w5 w6 w7 q AMP FREQ]

% Settings
options = odeset('InitialStep',1e-03,'MaxStep',0.005);
% Define simulation time 
t_end=20;
timestep=0.002;
tRange= 0 : timestep : t_end-timestep;
Fs=1/timestep;

x_ini= [0 0 0];
in_freq= par(11);
ampl=par(10);
offset= par(1);
transitionT = 10;       % this is different from t1


constantDrive = offset * ones(size(tRange));

% simulate with a constant input first
% the only goal is to find the time t1 when the oscillating input should
% start for the selected phase

parameters={tRange, constantDrive,par(2),par(3),par(4),par(5),par(6),par(7),par(8),par(9)};
[t,x]=ode45(@modelFunqNELvarInputPhase,tRange,x_ini,options,parameters);


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
        error('check phase')
end

count=1;
for i=length(IND)-1:-1:1
    if IND(i)==IND(i+1)-count
        IND(i)=[];
        count= count+1;
    else
        count=1;
    end
end
timeIND = IND(find(t(IND)>transitionT,1));
t1 = t(timeIND);

clear X XX

% this should make the oscillatory input start with phase 0 at t1
oscillDrive=offset+ampl*sin(2*pi*in_freq*tRange);
oscillDrive = circshift(oscillDrive,timeIND);
oscillDrive(1:timeIND) = offset*ones(1,timeIND); 

parameters={tRange, oscillDrive,par(2),par(3),par(4),par(5),par(6),par(7),par(8),par(9)};
[t,y]=ode45(@modelFunqNELvarInputPhase,tRange,x_ini,options,parameters);


% make up the attractor set with a tolerance
tolerance = 1e-3;
indP = round(17*size(y,1)/20);
attrSet = uniquetol(y(indP:end,:), tolerance,'ByRows',true);

for j  = indP :-1 :1
    if ~ismembertol(y(j, :), attrSet, 10*tolerance, 'ByRows',true)
        convergedAt = tRange(j+1);
        break
    end
end
        
% the time needed for convergence
tConv = convergedAt - t1;
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

% test for oscillation  - not useful anymore?
maxv=max(y( round(31*end/32):end , :));
minv=min(y( round(31*end/32):end , :));
vrange=maxv-minv;
if vrange(1)>0.02 && vrange(2)>0.002 && vrange(3)>0.002
    oscillating=1;
else
    oscillating=0;
end

if plotflag
    figure(1)
    plot(t,0.35+oscillDrive/12);
    hold on
    plot(t,y(:,1))
    stem(convergedAt, 0.5)
    legend('external drive P(t)', 'excitatory population E(t)', 'convergence timepoint')
    xlabel('time (s)')
    hold off
end

[out_freq, powers, in_freq_absPower]=freq_analysis2(y(round(2*end/3):end,1),Fs,plotflag,in_freq);
synchr_index=0;
for i=1:length(out_freq)
    if out_freq(i)>=in_freq-0.2 && out_freq(i)<=in_freq+0.2
        synchr_index=powers(i);
        break
    end
end
    



