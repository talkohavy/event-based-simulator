function [alpha_opt,mu_opt,alpha_,muU,muF]=FindAlphaOpt(s,LpU,LpP,LpF)
%(tauU,tauP,tauF)
%s=(1e-6):(1e-6):0.1;
%k1=1;%other k give gamma distribution\
%k2=1;%other k give gamma distribution
%k3=1;%other k give gamma distribution
%LpU=1./(1+s*tauU/k1).^k1;
%LpP=1./(1+s*tauP/k2).^k2;
%LpF=1./(1+s*tauF./k3).^k3;
alpha_=(1e-4):(1e-4):(1-1e-4);
for k=1:length(alpha_)
    [~,mnind]=min(abs((1+alpha_(k))*LpU-1));
    muU(k)=s(mnind);
    [~,mnind2]=min(abs(LpF+(1-alpha_(k)).*LpF.*LpP-1));
    muF(k)=s(mnind2);
end
[~,mnind3]=min(abs(muF-muU));
alpha_opt=alpha_(mnind3);
mu_opt=muU(mnind3);
    
    