function dydt = UPF_ODE_model(t,y,p)
%function dydt = myUPFmodel(t,y,p)
%p=[tau,tauF,amx];
%p=[6.3,1,0.4];
%[t,y] = ode45(@(t,y) UPF_ODE_model(t,y,p),[0 60],[1;1;1;]);

% Solution with nonnegative constraint
%options1 = odeset('Refine',8);
%options2 = odeset(options1,'NonNegative',1);%options2 = odeset(options1,'NonNegative',1);
%[t,y] = ode45(@(t,y) UPF_ODE_model(t,y,p),[0 60],[1;1;1;],options2);

tau=p(1);
tauF=p(2);
amx=p(3);
dydt=[min([1,y(3)/y(1)]).*(y(1)./tau).*(amx*((y(3)./y(1)).^2)./(1+(y(3)./y(1)).^2)),...
    min([1,y(3)/y(1)]).*(y(1)./tau).*(1-amx*((y(3)./y(1)).^2)./(1+(y(3)./y(1)).^2)),...
    y(2)./tauF - min([1,y(3)./y(1)]).*y(1)./tau].';


