function [a1,a2,r]=simulate(T,alpha,beta,lamda,w,wd,stickness)

%state a, b and c. 
%state a contains action 1,2; b contains 3,4; c contains 5,6.

%variables for transition probability: N1b means taking action 1 lead agent
%from state a to b
N1b=0;
N1c=0;
N2b=0;
N2c=0;

%subjective transition probability of action 1 and 2
p1=[0.5 0.5];
p2=[0.5 0.5];

%first choice and second choice
a1=[];
a2=[];

%reward
r=[];

%values for two actions in state a,b,c
Qa=[0.5,0.5];
Qb=[0.5,0.5];
Qc=[0.5,0.5];

%initial probability of choosing in state a,b,c
pa=exp(beta*Qa)/sum(exp(beta*Qa));
pb=exp(beta*Qb)/sum(exp(beta*Qb));
pc=exp(beta*Qc)/sum(exp(beta*Qc));

for t=1:T
    %make choice in state a
    a1(t)=choose([1,2],pa);
    
    %transition according to action and probability
    if a1(t)==1
        current_State=choose(["b","c"],[0.7,0.3]);
        if current_State=="b"
            N1b=N1b+1;
        elseif current_State=="c"
            N1c=N1c+1;
        else
            error("error in simulation:transition");
        end
    elseif a1(t)==2
        current_State=choose(["b","c"],[0.3,0.7]);
        if current_State=="b"
            N2b=N2b+1;
        elseif current_State=="c"
            N2c=N2c+1;
        else
            error("error in simulation:transition");
        end
    else
        error("error in simulation:transition");
    end

    %make sencond choice based on first choice and transition
    if current_State=="b"
        a2(t)=choose([3,4],pb);
    elseif current_State=="c"
        a2(t)=choose([5,6],pc);
    else
        error("error in simulation:action");
    end
    
    %generate reward based on choice 3-6
    if a2(t)==3
        r(t)=reward([1 0],[0.43 1-0.43]);
    elseif a2(t)==4
        r(t)=reward([1 0],[0.67 1-0.67]);
    elseif a2(t)==5
        r(t)=reward([1 0],[0.32 1-0.32]);
    elseif a2(t)==6
        r(t)=reward([1 0],[0.45 1-0.45]);
    else
        error("error in simulation:reward");
    end
    
    %update value
    if current_State=="b"
        delta=r(t)+0-Qb(a2(t)-2);
        Qb(a2(t)-2)=Qb(a2(t)-2)+alpha*delta;
    elseif current_State=="c"
        delta=r(t)+0-Qc(a2(t)-4);
        Qc(a2(t)-4)=Qc(a2(t)-4)+alpha*delta;
    else
        error("error in simulation:update");
    end
    
    %update transition probability
    p1=[(1+N1b)/(2+N1b+N1c),(1+N1c)/(2+N1b+N1c)];
    p2=[(1+N2b)/(2+N2b+N2c),(1+N2c)/(2+N2b+N2c)];
    
    %model-based for action 1 and 2
    Qmb1=p1(1)*max(Qb)+p1(2)*max(Qc);
    Qmb2=p2(1)*max(Qb)+p2(2)*max(Qc);
    Qmb=[Qmb1 Qmb2];
    %model-free for action 1 and 2
    Qmf(a1(t))=Qa(a1(t))+alpha*lamda*delta;
    %combine two models in state 1; for state 2,3, model-free=model-base
    
    Qa=w(wd(t))*Qmb+(1-w(wd(t)))*Qmf;

    %update probability
    if t==1
        pa=exp(beta*Qa)/sum(exp(beta*Qa));
        pb=exp(beta*Qb)/sum(exp(beta*Qb));
        pc=exp(beta*Qc)/sum(exp(beta*Qc));
    else
        Qa_r=Qa;
        Qb_r=Qb;
        Qc_r=Qc;
        Qa_r(a1(t))=Qa_r(a1(t))+stickness*(-(a1(t)==a1(t-1)));
        if current_State=="b"
            Qb_r(a2(t)-2)=Qb_r(a2(t)-2)+stickness*(-(a2(t)==a2(t-1)));
        elseif current_State=="c"
            Qc_r(a2(t)-4)=Qc_r(a2(t)-4)+stickness*(-(a2(t)==a2(t-1)));
        else
            error("error in simulation:probability");
        end
        pa=exp(beta*Qa_r)/sum(exp(beta*Qa_r));
        pb=exp(beta*Qb_r)/sum(exp(beta*Qb_r));
        pc=exp(beta*Qc_r)/sum(exp(beta*Qc_r));
    end
end