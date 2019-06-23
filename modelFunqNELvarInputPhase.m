function dxdt = modelFunqNELvarInputPhase(t,x,ext_in_t, ext_in_v,w1,w2,w3,w4,w5,w6,w7,parq)
%model m024


dxdt=zeros(3,1);

P=interp1(ext_in_t, ext_in_v, t);
w_p=0;
w_ee=w1;
w_es=w2;
w_ed=w3;
w_se=w4;
w_ss=0;
w_sd=0;
w_de=w5;
w_ds=w6;
w_dd=w7;
q=parq;
r_e=1;
r_s=1;
r_d=1;
a_e=1.3;
a_s=2;
a_d=2;
u_e=4;
u_s=3.7;
u_d=3.7;
t_e=0.05;
t_s=0.05;
t_d=0.05;


dxdt(1)=(-x(1)+((exp(a_e*u_e)/(1+exp(a_e*u_e)))-r_e*x(1))*(a_e/(a_e+q*w_ed*x(3)))*(1/(1+exp(-a_e*((w_ee*x(1)+P)-(u_e+w_es*x(2)+(1-q)*w_ed*x(3)))))-1/(1+exp(a_e*u_e))))/t_e;
dxdt(2)=(-x(2)+((exp(a_s*u_s)/(1+exp(a_s*u_s)))-r_s*x(2))*(1/(1+exp(-a_s*((w_se*x(1)+w_p*P)-(u_s+w_ss*x(2)+w_sd*x(3)))))-1/(1+exp(a_s*u_s))))/t_s;
dxdt(3)=(-x(3)+((exp(a_d*u_d)/(1+exp(a_d*u_d)))-r_d*x(3))*(1/(1+exp(-a_d*((w_de*x(1)+w_p*P)-(u_d+w_ds*x(2)+w_dd*x(3)))))-1/(1+exp(a_d*u_d))))/t_d;

end

