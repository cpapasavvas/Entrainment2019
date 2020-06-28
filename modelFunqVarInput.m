function dxdt = modelFunqVarInput(t,x,pars)
% Neural mass model of a neocortical microcircuit with one excitatory,x(1),
% population and two inhibitory populations.
% The first inhibitory population, x(2), represents the dendrite-targeting
% interneurons and it delivers subtractive inhibition to the excitatory 
% population.
% The other inhibitory population, x(3), represents the soma-targeting 
% interneurons and it can deliver a combination of 
% subtractive and divisive inhibition
% onto the excitatory population. The contribution of divisive inhibition
% is dictated by parameter q.
%
% The excitatory population receives external input (P) that can be time
% varying. The inhibitory populations can receive extenral input as well
% by setting the w_p parameter above 0.

% state variables
dxdt=zeros(3,1);

% external input, allowing time-varying
P=interp1(pars{1}, pars{2}, t);

% CAUTION to avoid confusion with the parameter subscripts:
% The subscript s refers to subtractive inhibition and, thus, to 
% dendrite-targeting population.
% The subscript d refers to divisive inhibition and, thus, to
% the soma-targeting population.

w_p=0;        % gating factor for external input P onto inhib. populations
w_ee=pars{3}; % self-excitation weight for the excitatory population
w_es=pars{4}; % weight of inhibition from dendrite-targeting to excitatory
w_ed=pars{5}; % weight of inhibition from soma-targeting to excitatory
w_se=pars{6}; % weight of excitation from excitatory to dendrite-targeting
w_ss=0;       % self-inhibition weight for dendrite-targeting, disabled
w_sd=0;       % weight of inh. from soma-targ. to dend-targ. , disabled
w_de=pars{7}; % weight of excitation from excitatory to soma-targeting
w_ds=pars{8}; % weight of inhibition from dend-targ. to soma-targeting
w_dd=pars{9}; % self-inhibition weight for soma-targeting
q=pars{10};   % parameter dictating the proportion of divisive inhibition
r_e=1;        % constant refractory parameter for excitatory population
r_s=1;        % constant refractory parameter for dendrite-targeting popul.
r_d=1;        % constant refractory parameter for soma-targeting population
a_e=1.3;      % max slope for the sigmoidal of excit. popul.
a_s=2;        % max slope for the sigmoidal of dend-target.
a_d=2;        % max slope for the sigmoidal of soma-target.
u_e=4;        % min displacement for the sigmoidal of excit. popul.
u_s=3.7;      % min displacement for the sigmoidal of dend-targ. popul.
u_d=3.7;      % min displacement for the sigmoidal of soma-targ. popul.
t_e=0.05;     % time constant for the sigmoidal of excit. popul.
t_s=0.05;     % time constant for the sigmoidal of dend-targ. popul.
t_d=0.05;     % time constant for the sigmoidal of soma-targ. popul.


dxdt(1)=(-x(1)+((exp(a_e*u_e)/(1+exp(a_e*u_e)))-r_e*x(1))*(a_e/(a_e+q*w_ed*x(3)))*(1/(1+exp(-a_e*((w_ee*x(1)+P)-(u_e+w_es*x(2)+(1-q)*w_ed*x(3)))))-1/(1+exp(a_e*u_e))))/t_e;
dxdt(2)=(-x(2)+((exp(a_s*u_s)/(1+exp(a_s*u_s)))-r_s*x(2))*(1/(1+exp(-a_s*((w_se*x(1)+w_p*P)-(u_s+w_ss*x(2)+w_sd*x(3)))))-1/(1+exp(a_s*u_s))))/t_s;
dxdt(3)=(-x(3)+((exp(a_d*u_d)/(1+exp(a_d*u_d)))-r_d*x(3))*(1/(1+exp(-a_d*((w_de*x(1)+w_p*P)-(u_d+w_ds*x(2)+w_dd*x(3)))))-1/(1+exp(a_d*u_d))))/t_d;

end

