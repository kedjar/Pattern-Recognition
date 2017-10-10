%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016

w = [ 2468320       16160      313200           0          80;
    112504800      244144       83968           0         176;
    112648800      244144       83968           0         176;
    6936800      297320       13600     1863764         268;
    7080800      297320       13600     1863764         268];

b = bar(log10(w));
grid
Labels = {'Quadratique \newline     Bayes',...
    '          k-PPV \newline(validation simple)',...
    '          k-PPV \newline(validation croisée)',...
    '          SVM \newline(validation simple)',...
    '          SVM \newline(validation croisée)'};
set(gca, 'XTick', 1:5, 'XTickLabel', Labels);
h = legend('matrices', 'vecteurs', 'cellules', 'structures', 'valeurs singulières');
set(h, 'FontSize', 14)
b(1).FaceColor = azure_colorwheel;
b(2).FaceColor = parisgreen;
b(3).FaceColor = neoncarrot;
b(4).FaceColor = awesome;
b(5).FaceColor = ube;

set(gca, 'YtickLabel', {'0', '10^{1}','10^{2}','10^{3}','10^{3}','10^{4}','10^{5}', '10^{6}','10^{7}', '10^{8}'})
ylabel('taille en mémoire(octets)', 'FontSize', 14)
xlabel('phases de l''algorithme', 'FontSize', 14)