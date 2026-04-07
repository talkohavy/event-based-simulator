function [Lp]=calcNumericalLaplace(s,Type,param)
if strcmp(Type,'Exp')
    Lp=1./(1+param(1)*s);
elseif strcmp(Type,'Gamma')
    k=param(2);
    Lp=1./(1+param(1)*s/k).^k;
elseif strcmp(Type,'Flat')
    Lp=(exp(-param(1)*s)-exp(-param(2)*s))./(param(2)-param(1))./s;
elseif strcmp(Type,'Deterministic')
    Lp=exp(-s*param(1));
end