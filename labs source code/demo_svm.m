%Demo sur l'utilisation de la fonction mexsvmlearn.dll
%conçu par Tom Briggs, interface matlab et SVMlight
%SVMlight a été developpé par  Thorsten Joachims en C.
%% SYS800 - Reconnaissance de formes et inspection
% M'Hand Kedjar - December 2016
clear all
fprintf('*** Formation de la base de donnée *** \n');
X=[1 2;2 1;3 2;3 3;2 4;4 7;5 2;5 4;7 2;7 4];
Y=[1;1;1;1;1;-1;-1;-1;-1;-1];
fprintf('*** Apprentissage du SVM *** \n');
model = mexsvmlearn(X,Y,'-t 0 -c 0.5');

fprintf('*** Affichage des valeurs de alpha avec signe de Yi *** \n');
Yalpha=model.a

fprintf('*** Affichage de la valeur du biais  *** \n');
biais=-model.b

fprintf('*** Affichage de l indice des vecteurs de support *** \n');
index_vs = find(Yalpha~=0)

fprintf('*** Dessin de la frontière de décision ***\n');
%Récupérer les vecteurs de support 
VS=X(index_vs,:);
%Afficher les données d'apprentissage
plot(X(1:5,1),X(1:5,2),'+',X(6:10,1),X(6:10,2),'.');
%Encercler en rouge les vecteurs de support
hold on
plot(VS(:,1),VS(:,2),'or');
%Calculer les paramètres de la droite de sépapration a1.x+a2.y+bias=0
a1=Yalpha(index_vs)'*X(index_vs,1)
a2=Yalpha(index_vs)'*X(index_vs,2)
%Tracer la droite de séparation
hold on
plot([2.5 4.7],[-(biais+2.5*a1)/a2 -(biais+4.7*a1)/a2]);
%Tracer la marge de séparation a1.x+a2.y+bias=-1
hold on
plot([2 4],[-(-1+biais+2*a1)/a2 -(-1+biais+4*a1)/a2]);
%Tracer la marge de séparation a1.x+a2.y+bias=1
hold on
plot([3 5.5],[-(1+biais+3*a1)/a2 -(1+biais+5.5*a1)/a2]);

%Trouver la classe d'un exemple représenté par Xt1=(6,7)
Xt1=[6,7];
Kt1 = X(index_vs,:)*Xt1'  %Noyau lineaire
Yt1 = sign(Yalpha(index_vs)'*Kt1+biais)

%Trouver la classe d'un exemple représenté par Xt2=(3,0)
Xt2=[3,0];
Kt2 = X(index_vs,:)*Xt2'  %Noyau lineaire
Yt2 = sign(Yalpha(index_vs)'*Kt2+biais)
