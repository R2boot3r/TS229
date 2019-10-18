%__________________________________________________________________%
%_______________Projet de Communication Numérique ________________%
%__________________________________________________________________%
%____________Alexandra Abulaeva & Julien Choveton-Caillat__________%

clear ;close all ; clc


addpath('../PHY');

%% 
Fe = 20e6; % Frequence d'echantillonnage (imposee par le serveur)
Fs = 1e6;
Ts = 1/Fs;
Rb = 1e6;% Debit binaire (=debit symbole)
Fse = floor(Fe/Rb); % Nombre d'echantillons par symboles
Nfft = 256;
Nb = 1e4; % Nombre de bits g�n�r�s


%% Cha�ne TX
b = randi([0,1],1,Nb);
sl = modulatePPM(b,Fse);

[X,freq_ax] = Mon_Welch1(sl, Nfft, Fe);


% On a juste un offset voir a quoi il est du


%% Resultats


% Calcule de la DSP th�orique

Dsp0 = 0.25 * double(freq_ax==0); % ajout du ==0 pour la continuit� car la fonction a un probl�me de continuit� en 0

Dsp = (Ts/4).*(sinc(freq_ax * Ts/2).^2).*(sin((pi/2)*freq_ax*Ts).^2);

dspTh = abs(Dsp+ Dsp0).^2;




%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%  Figures de résultats  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%#passer la frequence d'echantillon
%# il retour l'axe fr�quentiel
%# axe frequentiel on peux le calculer s�par
figure,
semilogy(f,X)
hold on
semilogy(freq_ax,dspTh);
[X1, f1] = Mon_Welch(sl, Nfft, Fe);
semilogy(f1,X1)

%%
%%%% Commentaire
% il reste a dertermin� l'offset pr�sent sur les deux courbes


