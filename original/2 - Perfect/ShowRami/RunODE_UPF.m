%clear all
%close all
amx=0.8497; %2*(sqrt(2)-1);
tauF=6;
tau=6;
p=[tau,tauF,amx];
maxSimTime = 140;

options1 = odeset('Refine',32);
options2 = odeset(options1,'NonNegative',1);
[t,y] = ode45(@(t,y) UPF_ODE_model(t,y,p),[0 maxSimTime],[1;1;1;],options2);
%eta=y(:,3)./y(:,1);
%alpha=p(3)*eta.^2./(1+eta.^2);
%semilogy(t,alpha,'LineWidth',2),shg
p2=[tau,tauF*2,1]; %alpha max 
yinit=y(end,:);
[t2,y2] = ode45(@(t,y) UPF_ODE_model(t,y,p2),[0 120],yinit,options2);
eta2=y2(:,3)./y2(:,1);
alpha2=p2(3)*eta2.^2./(1+eta2.^2);
hold all,semilogy(t2,alpha2,'LineWidth',2),shg