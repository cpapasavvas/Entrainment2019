function dxdt = modelFunqESD(t,x,ext_in_t, ext_in_v,par1,par2,par3,par4,par5,par6,par7,par8)
%model m008 as described  and w_dd included


dxdt=zeros(3,1);


P_e=interp1(ext_in_t, ext_in_v, t);
P_s=0;
P_d=0;
w_ee=par1;
w_es=par2;
w_ed=par3;
w_se=par4;
w_ss=0;
w_de=par5;
w_ds=par6;
w_dd=par7;
q=par8;
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


dxdt(1)=(-x(1)+((exp((a_e/(1+q*w_ed*x(3)))*u_e)/(1+exp((a_e/(1+q*w_ed*x(3)))*u_e)))-r_e*x(1))*(1/(1+exp(-(a_e/(1+q*w_ed*x(3)))*((w_ee*x(1)+P_e)-(u_e+w_es*x(2)+(1-q)*w_ed*x(3)))))-1/(1+exp((a_e/(1+q*w_ed*x(3)))*u_e))))/t_e;
dxdt(2)=(-x(2)+((exp(a_s*u_s)/(1+exp(a_s*u_s)))-r_s*x(2))*(1/(1+exp(-a_s*((w_se*x(1)+P_s)-(u_s+w_ss*x(2)))))-1/(1+exp(a_s*u_s))))/t_s;
dxdt(3)=(-x(3)+((exp(a_d*u_d)/(1+exp(a_d*u_d)))-r_d*x(3))*(1/(1+exp(-a_d*((w_de*x(1)+P_d)-(u_d+w_ds*x(2)+w_dd*x(3)))))-1/(1+exp(a_d*u_d))))/t_d;

end

