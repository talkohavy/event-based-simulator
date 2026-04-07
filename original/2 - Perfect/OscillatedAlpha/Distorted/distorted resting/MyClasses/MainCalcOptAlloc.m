tP = 6;
tU = 6;
tF = 6;
t0 = 6/10;
factor = 2;

s=(1e-6):(1e-6):0.1;
[LpU]=calcNumericalLaplace(s,'Exp',tU);
[LpP]=calcNumericalLaplace(s,'Exp',tP);
[LpF]=calcNumericalLaplace(s,'Exp',tF);
[Lp0]=calcNumericalLaplace(s,'Exp',t0);
[alpha_opt,mu_opt,alpha_,muU,muF] = FindAlphaOpt(s,LpU,LpP,LpF,Lp0);
s=(1e-6):(1e-6):0.1;
[LpF]=calcNumericalLaplace(s,'Exp',tF*factor);
[alpha_opt2,mu_opt2,alpha_,muU2,muF2] = FindAlphaOpt(s,LpU,LpP,LpF,Lp0);


% plot(alpha_,muU2),hold all,plot(alpha_,muF2),hold on;


pwd = PlayWithData();
pwd.NewFigure();
pwd.ChangeXlabel("time");
pwd.ChangeYlabel("Cost");
pwd.ChangeTitle("Regular Plot");
%Line:
pwd.ChangeLineColor('black');
pwd.ChangeLineWidth(3);
pwd.ChangeLineStyle(1); %1=Solid
pwd.SetMaxXMaxY(max(alpha_)*1.1,max(muU2)*1);
pwd.Plot_xVy(alpha_,muU2,'time');
pwd.Plot_xVy(alpha_,muF2,'time');