clear
addpath("./SimulationFunctions")
addpath("./LikelihoodFunctions");
addpath("./FitFunction")
%function [a1,a2,r]=simulate_CurseofPlanning(T,alpha,beta,lamda,w,wd,stickness)
T=1000;
alpha=0.17;
beta=3.74;
lamda=0.68;
w1=0.18;%working memory load 1
w2=0.5;%working memory load 2
wd=zeros([1,T])+1;%whether w1 or w2
stickness=0.1;

[a1,a2,r]=simulate(T,alpha,beta,lamda,[w1,w2],wd,stickness);
[Xfit,LL,BIC]=fit_my(a1,a2,r,[w1,w2],wd);

for n=1:100
    n
    alpha=rand;
    beta=exprnd(10);
    lamda=rand;
    w1=rand;
    w2=rand;
    stickness=rand;
    [a1,a2,r]=simulate(T,alpha,beta,lamda,[w1,w2],wd,stickness);
    [Xft,LL,BIC]=fit_my(a1,a2,r,[w1,w2],wd);
    
    Xsim(1,n)=alpha;
    Xsim(2,n)=beta;
    Xsim(3,n)=lamda;
    Xsim(4,n)=stickness;
    Xfit(1,n)=Xft(1);
    Xfit(2,n)=Xft(2);
    Xfit(3,n)=Xft(3);
    Xfit(4,n)=Xft(4);
end
%%
figure

subplot(2,2,1)
hold on
plot(Xsim(1,:),Xfit(1,:),"o")
xlabel("simulate \alpha")
ylabel("fit \alpha")

subplot(2,2,2)
hold on
plot(Xsim(2,:),Xfit(2,:),"o")
xlabel("simulate \beta")
ylabel("fit \beta")

subplot(2,2,3)
hold on
plot(Xsim(3,:),Xfit(3,:),"o")
xlabel("simulate \lambda")
ylabel("fit \lambda")

subplot(2,2,4)
hold on
plot(Xsim(4,:),Xfit(4,:),"o")
xlabel("simulate stickness")
ylabel("fit stickness")