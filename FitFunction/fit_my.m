function [Xfit, LL, BIC]=fit_my(a1,a2,r,w,wd)

%function NegLL=lik(a1,a2,r,alpha,beta,lamda,w,wd,stickness)
obFunc=@(x) lik(a1,a2,r,x(1),x(2),x(3),w,wd,x(4));

X0=[rand exprnd(1) rand rand];
UB=[1 inf 1 1];
LB=[0 0 0 0];

[Xfit, NegLL]=fmincon(obFunc,X0,[],[],[],[],LB,UB);

LL = -NegLL;
BIC = length(X0) * log(length(r)) + 2*NegLL;