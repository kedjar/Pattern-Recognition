%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
% Course Project on Age and Gender Classification

C = [1 5 10 30 70 100 200 500 1000 3000 6000 10000];
g = [0.1 0.05 0.01 0.0075 0.005 0.003 0.001 0.00075 0.0005  0.00035  0.0002 0.0001];
error_mtx = ...
   [834   657   111    83    47    35    30    29    37    43    54    69;
	829   625   121    83    43    34    30    29    27    27    32    39;
	829   625   121    83    43    34    30    30    29    27    28    34;
	829   625   121    83    43    34    30    30    33    32    30    30;
	829   625   121    83    43    34    30    30    33    32    29    31;
	829   625   121    83    43    34    30    30    33    32    30    30;
	829   625   121    83    43    34    30    30    33    32    30    30;
	831   625   121    83    43    34    30    30    33    32    30    32;
	829   625   121    83    43    34    30    30    33    32    30    32;
	829   625   121    83    43    34    30    30    33    32    30    32;
	829   625   121    83    43    34    30    30    33    32    30    32;	
	829   625   121    83    43    34    30    30    33    32    30    32];
	
	
mesh(100*error_mtx/1000)
xlabel('C')
ylabel('g')
zlabel('erreur de classification(%)')
legend('Erreur sur la base de test')
legend('location', 'best')
set(gca, 'Xtick',1:numel(C),'XTickLabel',mat2cell(C, 1,numel(C)))
set(gca, 'Ytick',1:numel(g),'YTickLabel',mat2cell(g, 1,numel(g)))



XMIN = g(1) - 1; 
XMAX = g(end) + 1;
YMIN = C(1) - 1;
YMAX = C(end) + 1;

ZMIN = min(min(error_mtx)) - 1;
ZMAX = max(min(error_mtx)) + 1;

axis([XMIN XMAX YMIN YMAX ZMIN ZMAX])