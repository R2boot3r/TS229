clear 
close all
clc

addpath('../PHY');

%% 
Fe = 20e6; % Frequence d'echantillonnage (imposee par le serveur)
Fs = 1e6;
Ts = 1/Fs;
Rb = 1e6;% Debit binaire (=debit symbole)
Fse = floor(Fe/Rb); % Nombre d'echantillons par symboles
Nfft = 1024;
Nb = 1e4; % Nombre de bits g�n�r�s
freq_ax = -Fe/2:Fe/Nfft:Fe/2-Fe/Nfft;

%% Cha�ne TX
b = randi([0,1],1,Nb);
sl = modulatePPM(b,Fse);

% Calcule de la DSP th�orique
a = 1./(Ts*pi^2*(freq_ax.^2));
b = (sin(pi*freq_ax*Ts*0.5));

dsp0 = 0.25 * double(freq_ax==0);
dsp = (Ts/4).*(sinc(freq_ax * Ts/2).^2).*(sin((pi/2)*freq_ax*Ts).^2);
dspTh = abs(dsp+ dsp0).^2;



dspth = 0.25*dirac(freq_ax)+a.*b;

% On a juste un offset voir a quoi il est du


%% Resultats
[X, f] = Mon_Welch1(sl, Nfft, Fe);
%#passer la frequence d'echantillon
%# il retour l'axe fr�quentiel
%# axe frequentiel on peux le calculer s�par
figure,
semilogy(f,X)
hold on
semilogy(freq_ax,dspTh);
[X1, f1] = Mon_Welch(sl, Nfft, Fe);
semilogy(f1,X1)


