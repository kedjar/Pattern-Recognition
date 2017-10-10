%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016

function features = get_acp_components(features)

M = mean(features);
S = cov(features);

[vec_p , L] = eig(S);
[val_p , index] = sort(diag(L) , 'descend');
vec_p = vec_p(: , index);

features = struct();
features.vec_p = vec_p;
features.M     = M; 
if(1)
    cum_val = cumsum(val_p)/sum(val_p)*100;     % Cumulative variance (%)
    
    figure(1)
    plot(cum_val,'-'), hold on, grid on
    plot(44,cum_val(44), 'k*')
    line([44 44],[0,cum_val(44)],'Color',[.1 .1 .1],'LineWidth',0.5)
    line([0 44],[cum_val(44),cum_val(44)],'Color',[.1 .1 .1],'LineWidth',1)
    xlabel('nombre de composantes utilisées (k)')
    ylabel('pourcentage de variabilité expliquée')
    str = '$$\frac{\sum_{j=1}^{k} \lambda_{j}}{\sum_{j=1}^{`} \lambda_{j}} \geq 95\%$$';
    text(46,88, str, 'Interpreter','latex')
end


end