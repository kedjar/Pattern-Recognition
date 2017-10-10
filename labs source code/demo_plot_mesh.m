%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016

mesh(100*error_mtx/1000)
xlabel('C')
ylabel('g')
zlabel('erreur de classification(%)')
legend('Erreur sur la base de test')
legend('location', 'best')
set(gca, 'Xtick',1:6,'XTickLabel',mat2cell(C, 1,numel(C)))
set(gca, 'Ytick',1:6,'YTickLabel',mat2cell(g, 1,numel(g)))



XMIN = g(1) - 1; 
XMAX = g(end) + 1;
YMIN = C(1) - 1;
YMAX = C(end) + 1;

ZMIN = min(min(error_mtx)) - 1;
ZMAX = max(min(error_mtx)) + 1;

axis([XMIN XMAX YMIN YMAX ZMIN ZMAX])