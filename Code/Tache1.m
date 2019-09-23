%____________________________________________________________%
%_______________Projet de Communication Numérique ___________%
%____________________________________________________________%
%____________Agnia Savina & Julien Choveton-Caillat__________%

clear ;close all ; clc


%%%%%%%%%%%%%%%%%%%  Initialisation des variables  %%%%%%%%%%%%%%%%%%%%
%Variables général

M = 2;          % Nombre de symboles
Fe = 2*1e7;       % fréquence d'échantillonage
Te = 1/Fe;      % Période d'échantillonage
Ts = 1e-6;      % Temps Symbole
Ds = 1/Ts;       % Debit symbole
Fse = Ts*Fe;    % Facteur de sur-échantillonnage
Ns = 100;      % Nombre de symbole/bits par messages
Nb = Ns;        % Nombre de bits par messages on a �galit� cas particulier d'une 2 PAM
N = 512;        % Nombre de points pour la transformé de fourrier
axe_freq = -Fe/2 : Fe/N : Fe/2 - Fe/N; % cr�ation de l'axe fr�quentielle pour le trac� de r�sultats
lambda = 1;

%impulsion pO encodant le bit 0

po=[0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1];
% trouver fonction echelon plus jolie dans le code
%impulsion p1 encodant le bit 1

p1=[1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0];

%impulsion p(t) filtre de reception
p=[-0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 ];



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%  Emetteur  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

signal_bits = randi(2,1,Ns)-1; % génération du signal a envoyé



% Association bits/symboles

sl=[];

for i=1:length(signal_bits)
    if signal_bits(i) == 0
        
        sl=[sl po];
        
    else    
        sl=[sl p1];

    end
end
%peut etre moyen plus rapide que boucle



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%  Canal  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Filtre du canal
    
     %{
        On suppose que le signal est émis dans la bande passante du
        canal, ce dernier est donc non sélectif en fréquence et est
        modélisé par un dirac.
      %}
    
    % Bruit
    
ecart_type = 0.1;
nl = ecart_type * randn(1, length(sl));
yl = sl + nl;









%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%  Recepteur  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%  Filtre de reception  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rl = conv(yl, p); % pour mettre le signal dans la même base il y a deux période car l'un est échantilloné a Ts et l'autre a Te
rg = 9.5; % retard du filtre g causal calculé par fvtool(g)

rl_ech = rl(9+(0:Fse:Fse*(Ns-1))); % dans le code d'avant il y avait +1 a comprendre a quoi ca sert et pk on en a pas besion

% vérifier avec le prof si le filtre marche bien et pourqoi on a
% différentes valeurs


%%decision
signal_recu=[];
for k=1:length(rl_ech)
    if(rl_ech(k)<0)
        signal_recu(k)=1;
    else
        signal_recu(k)=0;
    end
end









%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%  Figures de résultats  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Représentation de signal_bits
figure;
plot(linspace(0,Ns-1,Ns),signal_bits);
%ne pas relier les points

% Représentation de sl
figure;
plot(linspace(0,length(sl)-1,length(sl)),sl);

% Représentation de rl
figure;
plot(linspace(0,length(rl)-1,length(rl)),rl);

