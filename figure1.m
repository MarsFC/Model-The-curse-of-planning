clear
addpath("./SimulationFunctions");
%%
% test whether simulation run correctly
T=1000;
alpha=0.17;
beta=3.74;
lamda=0.68;
w1=0.18;%working memory load 1
w2=0.5;%working memory load 2
wd=zeros([1,T])+1;%whether w1 or w2
stickness=0.1;

for n=1:1000
    n
    [a1,a2,r]=simulate(T,alpha,beta,lamda,[1,1],wd,stickness);
    c_or_n="none";%into common or rare situation
    reward_common=0;
    reward_rare=0;
    none_common=0;
    none_rare=0;
    reward_common_t=0;
    reward_rare_t=0;
    none_common_t=0;
    none_rare_t=0;
    for t=1:T
        if (a1(t)==1)&&(a2(t)<5)
            c_or_n="common";
        elseif (a1(t)==1)&&(a2(t)>4)
            c_or_n="rare";
        elseif (a1(t)==2)&&(a2(t)<5)
            c_or_n="rare";
        elseif (a1(t)==2)&&(a2(t)>4)
            c_or_n="common";
        else
            error("error in simulation:figure");
        end
        
        if t==T
            continue;
        elseif(c_or_n=="common")&&(r(t)==1)
            reward_common_t=reward_common_t+1;
            if a1(t)==a1(t+1)
                reward_common=reward_common+1;
            end
        elseif (c_or_n=="common")&&(r(t)==0)
            none_common_t=none_common_t+1;
            if a1(t)==a1(t+1)
                none_common=none_common+1;
            end
        elseif (c_or_n=="rare")&&(r(t)==1)
            reward_rare_t=reward_rare_t+1;
            if a1(t)==a1(t+1)
                reward_rare=reward_rare+1;
            end
        elseif (c_or_n=="rare")&&(r(t)==0)
            none_rare_t=none_rare_t+1;
            if a1(t)==a1(t+1)
                none_rare=none_rare+1;
            end
        else
            error("error in simulation:figure");
        end
    end
    p(n,:)=[reward_common/reward_common_t,reward_rare/reward_rare_t,none_common/none_common_t,none_rare/none_rare_t];
end
%%

figure(1)
p_show=mean(p,1);
bar([p_show(1),p_show(2);p_show(3),p_show(4)])
%ylim([0.5,1])
xticklabels({"rewarded","unrewarded"})
legend('commen', 'rare')
txt=['Model-base(\alpha=',num2str(alpha),' \beta=',num2str(beta),' \lambda=',num2str(lamda),')'];
title(txt)