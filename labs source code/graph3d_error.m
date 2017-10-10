%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016

C = log10([1 5 10 30 70 100 200 500 1000 3000 6000 10000]);
g = log10([0.1 0.05 0.01 0.0075 0.005 0.003 0.001 0.00075 0.0005  0.00035  0.0002 0.0001]);
err_mtx = ...
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
E = 100*err_mtx/1000;
[gg , cc] = meshgrid(1:0.2:10);
h = mesh(interp2((E/max(max(1))),gg,cc));
set(gca,'ZScale','log');
xvalues = [-1:-1:-4]; x = linspace(-4,-1,12);
yvalues = [1:5]; y = linspace(1,5,12);
zvalues = [0 2.7 10 30 50 83.4 100];	
% set(gca,'Xtick' , linspace(1,50,4),'XTickLabel',mat2cell(xvalues, 1,numel(xvalues)))
% set(gca, 'Ytick' , linspace(1,50,5),'YTickLabel',mat2cell(yvalues, 1,numel(yvalues)))
set(gca,'Xtick' , linspace(1,50,4),'XTickLabel',{'10^{-1}','10^{-2}', '10^{-2}','10^{-4}'} )
set(gca, 'Ztick',zvalues,'ZTickLabel',mat2cell(zvalues, 1,numel(zvalues)))

XMIN = g(end); 
XMAX = g(1);
YMIN = C(1);
YMAX = C(end);

ZMIN = 0;
ZMAX = 100;

axis([XMIN XMAX YMIN YMAX ZMIN ZMAX])

mesh(log10(100*err_mtx/1000))
xlabel('g')
ylabel('C')
zlabel('erreur de classification(%)')
legend('Erreur sur la base de test')
legend('location', 'best')
set(gca, 'Xtick',1:numel(g),'XTickLabel',mat2cell(C, 1,numel(g)))
set(gca, 'Ytick',1:numel(C),'YTickLabel',mat2cell(g, 1,numel(C)))


X = bsxfun(@(x,y)hypot((x-5),(y-5)),1:10,(1:10).'); %sample
subplot(121);
surf(X);
subplot(122);
[xx yy] = meshgrid(1:0.1:10);  %force it to interpolate at every 10th pixel
surf(interp2(X,xx,yy))
grid off  %turn off grid

b = bar(z)
grid
Labels = {'Quadratique \newline     Bayes',...
          '          k-PPV \newline(validation simple)',...
          '          k-PPV \newline(validation croisée)',...
          '          SVM \newline(validation simple)',...
          '          SVM \newline(validation croisée)'};
   set(gca, 'XTick', 1:5, 'XTickLabel', Labels);
h = legend('apprentissage', 'validation', 'test')  
set(h, 'FontSize', 14)
   b(1).FaceColor = azure_colorwheel;
   b(2).FaceColor = parisgreen;
   b(3).FaceColor = neoncarrot;
   
 set(gca, 'YtickLabel', {'0', '10^{-2}','10^{-1}','10^{0}','10^{1}','10^{2}','10^{3}', '10^{4}','10^{5}'})
 ylabel('temps de calcul (s)', 'FontSize', 14)
 xlabel('phases de l''algorithme', 'FontSize', 14)
 
w = [2797760;60143296;6145978 ]
figure,bar(w) 
Labels = {'Quadratique \newline     Bayes',...
          '          k-PPV \newline(validation simple)',...
          '          k-PPV \newline(validation croisée)',...
          '          SVM \newline(validation simple)',...
          '          SVM \newline(validation croisée)'};
   set(gca, 'XTick', 1:5, 'XTickLabel', Labels); 
 
 