%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016

m = {'ro-', 'g+-', 'bs-', 'k*-', 'mp-'}
for ii = 1:5
  semilogy(100*error_per_n_comp(:,ii), m{ii}), hold on  
end
grid on
xlabel('variance du bruit rajoutée')
ylabel('taux d''erreur (%)')
legend('Bayes Quadratique', 'k-PPV Validation' , 'k-PPV Test', 'SVM Validation', 'SVM Test')
legend('location', 'best')
set(gca, 'Xtick',1:numel(var_vect),'XTickLabel',mat2cell(var_vect, 1,numel(var_vect)))
set(gca, 'Ytick',1:2:22,'YTickLabel',mat2cell(0:10:100, 1,numel(0:10:100)))

m = {'ro-', 'k+-', 'bs-', 'r*-', 'kp-', 'b^-'}
for ii = 1:6
    if(ii==6)
 plot(t_per_n_comp(:,ii), m{ii}), hold on  
    end
end
grid on
xlabel('variance du bruit rajoutée')
ylabel('temps de calcul (s)')
%legend('QB Entrainement ', 'k-PPV Entrainement' ,'SVM Entrainement', 'QB Test ','k-PPV Test', 'SVM Test')
%legend('QB Entrainement ', 'k-PPV Entrainement' , 'QB Test ','k-PPV Test')
%legend('QB Entrainement ', 'k-PPV Entrainement' , 'QB Test ','k-PPV Test', 'SVM Test')
%legend('SVM Entrainement')
legend( 'SVM Test')
% legend('SVM Entrainement', 'SVM Test')
%legend('SVM Entrainement')

legend('location', 'best')
set(gca, 'Xtick',1:numel(var_vect),'XTickLabel',mat2cell(var_vect, 1,numel(var_vect)))
set(gca, 'YLim', [1.0000e-03 100000])


 figure, plot(var_vect, optim_params_per_n_comp(:,1), 'ro-')
 grid on
xlabel('variance du bruit rajoutée')
ylabel('valeur optimal de k pour k-PPV')

plot(error_per_n_comp)
plot(error_per_n_comp, 'o-')
semilogy
semilogy(error_per_n_comp, 'o-')
semilogy(t_per_n_comp, 'o-')

overlap_rate_train(v) = overlap_v3(train_features',train_labels);
overlap_rate_test(v) = overlap_v3(test_features',test_labels);


figure, semilogy(var_vect, 100*overlap_rate_train, 'ro-'),
hold on, 
 semilogy(var_vect, 100*overlap_rate_test, 'b*-'),
 grid on
 xlabel('variance du bruit rajoutée')
 ylabel('taux de recouvrement (%)' );
 legend('base d'' entrainment' , ' base de test' )
 

