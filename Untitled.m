clear ;close all ; clc
addpath('../src/Client', '../src/General', '../src/MAC', '../src/PHY'); % Ajout d'emplacement de certains scripts/fonctions��load('/data/buffers.mat'); %Chargement des donn�es 


Fe = 4e6; % Frequence d'echantillonnage (imposee par le serveur)
Rb = 1e6;% Debit binaire (=debit symbole)
Fse = floor(Fe/Rb) % Nombre d'echantillons par symboles

a = get_preamble(Fse)









