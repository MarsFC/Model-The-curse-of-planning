clear
addpath("./SimulationFunctions")

T=1000;
CM=zeros([2,2]);

for n=1:100
    n
    
    figure(1);
    clf;
    hold on;
    FM = round(CM./sum(CM,2),2);
    imagesc(FM)
    for i=1:size(FM,1)
        for j=1:size(FM,2)
            txt(i,j)=text(i,j,num2str(FM(i,j)));
        end
    end
    set(txt(FM<0.3), 'color', 'w')
    
    for i=1:(size(FM,1)-1)
        plot([i+0.5,i+0.5],[0.5,size(FM,2)+0.5],'k-','LineWidth',1)
    end
    for j=1:(size(FM,2)-1)
        plot([0.5,size(FM,1)+0.5],[j+0.5,j+0.5],'k-','LineWidth',1)
    end
    
    set(txt,'horizontalalignment', 'center','verticalalignment', 'middle','fontsize', 22);
    title(['count = ' num2str(n)]);
    set(gca, 'xtick', [1:2], 'ytick', [1:2],...
        'XTickLabel',{'mf', 'mb'},'YTickLabel',{'mf', 'mb'}, ...
        'fontsize', 28,'xaxislocation', 'bottom', 'tickdir', 'out')
    ylabel('Fitting Model')
    xlabel('Simulate Model')
    
    alpha=rand;
    beta=1+exprnd(1);
    lamda=rand;
    stickness=rand;
    % model free
    w=[0 0];
    wd=zeros([1,T])+1;
    [a1,a2,r]=simulate(T,alpha,beta,lamda,w,wd,stickness);
    [~,~,BIC1]=fit_my(a1,a2,r,[0 0],wd);
    [~,~,BIC2]=fit_my(a1,a2,r,[1 1],wd);
    BEST=min([BIC1;BIC2])==[BIC1;BIC2];
    CM(:,1)=CM(:,1)+BEST;
    
    % model base
    w=[1 1];
    wd=zeros([1,T])+1;
    [a1,a2,r]=simulate(T,alpha,beta,lamda,w,wd,stickness);
    [~,~,BIC1]=fit_my(a1,a2,r,[0 0],wd);
    [~,~,BIC2]=fit_my(a1,a2,r,[1 1],wd);
    BEST=min([BIC1;BIC2])==[BIC1;BIC2];
    CM(:,2)=CM(:,2)+BEST;
end