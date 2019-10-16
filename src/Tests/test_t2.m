clear 
close all
clc

addpath('../PHY');

%% 
Fe = 20e6; % Frequence d'echantillonnage (imposee par le serveur)
Rb = 1e6;% Debit binaire (=debit symbole)
Fse = floor(Fe/Rb); % Nombre d'echantillons par symboles
Nfft = 1024;
Nb = 1e4; % Nombre de bits g�n�r�s

%% Cha�ne TX
b = randi([0,1],1,Nb);
sl = modulatePPM(b,Fse);

%% Resultats
[X, f] = Mon_Welch1(sl, Nfft, Fe);
%#passer la frequence d'echantillon
%# il retour l'axe fr�quentiel
%# axe frequentiel on peux le calculer s�par
figure,
semilogy(f,X)
hold on
[X1, f1] = Mon_Welch(sl, Nfft, Fe);
semilogy(f1,X1)