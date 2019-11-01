%_____________________________________________________________%
%______________Projet de Communication Numérique ____________%
%_____________________________________________________________%
%__________Alexandra Abulaeva & Julien Choveton-Caillat_______%

clear ;close all ; clc
addpath('../src/Client', '../src/General', '../src/MAC', '../src/PHY'); % Ajout d'emplacement de certains scripts/fonctions

%%%%%%%%%%%%%%%%%%%  Initialisation des variables  %%%%%%%%%%%%%%%%%%%%
%Variables général

M = 2;          % Nombre de symboles
Fe = 2*1e7;       % fréquence d'échantillonage
Te = 1/Fe;      % Période d'échantillonage
Ts = 1e-6;      % Temps Symbole
Ds = 1/Ts;       % Debit symbole
Fse = Ts*Fe;    % Facteur de sur-échantillonnage
Ns = 88;      % Nombre de symbole/bits par messages
Nb = Ns;        % Nombre de bits par messages on a �galit� cas particulier d'une 2 PPM
Npolynome = 24;% taille du polynome generateur
tailletotale = Nb+Npolynome; % taille totale de la trame






%impulsion pO encodant le bit 0
po = [zeros(1,Fse/2) ones(1,Fse/2)];
%impulsion p1 encodant le bit 1
p1 = [ones(1,Fse/2) zeros(1,Fse/2)];
%impulsion p(t) filtre de reception
p = [-0.5*ones(1,Fse/2) 0.5*ones(1,Fse/2)];
p_inverse = fliplr(p);

% preambule equivalent a 8 bits

pream = [po po po po po po po po]; 
lenpream = length(pream);


% generation du signal

signal_bits = randi(2,1,Ns)-1; 


%codage CRC

msg = signal_bits'; %reshape(signal_bits,88,1);
encoded = CRC_encode(msg); % colonne
signal_bits_code = encoded'; % ligne,contient le CRC 


% modulation

sl=modulatePPM(signal_bits_code,Fse);

% preambule

sl=[pream sl];

% canal

ecart_type = 0;
nl = ecart_type * randn(1, length(sl));
yl= sl+nl;

% demodulation

signal_recu_code = demodulatePPMtache4(yl,Fse,length(pream));


% decodeur crc

[outdata error] = CRC_decode(signal_recu_code'); %detector(signal_recu_code') detect(detector, signal_recu_code')
signal_recu=outdata';% information decode en ligne

if error==0
    disp("message est integre en l'absence d erreur");
else
    disp("message n'est pas integre en l'absence d'erreur parmis les 112 bits de données ")
end
    
%%commentaire prof 
% quand on detect une erreur on ne sait pas si il y a une erreur sur le crc
% ou sur le message utile

