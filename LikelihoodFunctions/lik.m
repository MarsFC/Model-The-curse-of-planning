function NegLL=lik(a1,a2,r,alpha,beta,lamda,w,wd,stickness)

% value for state a,b,c
Qa=[0.5,0.5];
Qb=[0.5,0.5];
Qc=[0.5,0.5];

% probability of choosing
pa=exp(beta*Qa)/sum(exp(beta*Qa));
pb=exp(beta*Qb)/sum(exp(beta*Qb));
pc=exp(beta*Qc)/sum(exp(beta*Qc));

%variables for transition probability: N1b means taking action 1 lead agent
%from state a to b
N1b=0;
N1c=0;
N2b=0;
N2c=0;

for t=1:length(r)
    choiceProb1(t)=pa(a1(t));
    if a2(t)<5
        choiceProb2(t)=pb(a2(t)-2);
    elseif a2(t)>4
        choiceProb2(t)=pc(a2(t)-4);
    else
        error("error:lik.m");
    end
    
    if((a1(t)==1)&&(a2(t)<5))
        N1b=N1b+1;
    elseif((a1(t)==1)&&(a2(t)>4))
        N1c=N1c+1;
    elseif((a1(t)==2)&&(a2(t)<5))
        N2b=N2b+1;
    elseif((a1(t)==2)&&(a2(t)>4))
        N2c=N2c+1;
    else
        error("error:lik.m");
    end
    
    %update value
    if(a2(t)<5)
        delta=r(t)+0-Qb(a2(t)-2);
        Qb(a2(t)-2)=Qb(a2(t)-2)+alpha*delta;
    elseif(a2(t)>4)
        delta=r(t)+0-Qc(a2(t)-4);
        Qc(a2(t)-4)=Qc(a2(t)-4)+alpha*delta;
    else
        error("error: lik.m");
    end
    
    %model-base
    %transition
    p1=[(1+N1b)/(2+N1b+N1c),(1+N1c)/(2+N1b+N1c)];
    p2=[(1+N2b)/(2+N2b+N2c),(1+N2c)/(2+N2b+N2c)];
    Qmb=[p1(1)*max(Qb)+p1(2)*max(Qc),p2(1)*max(Qb)+p2(2)*max(Qc)];
    
    %Qa: model_free
    Qmf(a1(t))=Qa(a1(t))+alpha*lamda*delta;
    
    %combine two models in state 1; for state 2,3, model-free=model-base
    Qa=w(wd(t))*Qmb+(1-w(wd(t)))*Qa;
    
    %update choice probability
    if(t==1)
        pa=exp(beta*Qa)/sum(exp(beta*Qa));
        pb=exp(beta*Qb)/sum(exp(beta*Qb));
        pc=exp(beta*Qc)/sum(exp(beta*Qc));
    else
        Qa_r=Qa;
        Qb_r=Qb;
        Qc_r=Qc;
        Qa_r=Qa_r+stickness*(a1(t)==a1(t-1));
        if(a2(t)<5)
            Qb_r=Qb_r+stickness*(a2(t)==a2(t-1));
        elseif(a2(t)>4)
            Qc_r=Qc_r+stickness*(a2(t)==a2(t-1));
        else
            error("error:lik.m");
        end
        pa=exp(beta*Qa_r)/sum(exp(beta*Qa_r));
        pb=exp(beta*Qb_r)/sum(exp(beta*Qb_r));
        pc=exp(beta*Qc_r)/sum(exp(beta*Qc_r));
    end
end

NegLL=-sum(log(choiceProb1.*choiceProb2));