%____________________________________________________________%
%_______________Projet de Communication Numérique ___________%
%____________________________________________________________%
%____________Agnia Savina & Julien Choveton-Caillat__________%

clear ;close all ; clc

addpath('../src/PHY');

%%%%%%%%%%%%%%%%%%%  Initialisation des variables  %%%%%%%%%%%%%%%%%%%%
%Variables général
TEB_activation = true;

M = 2;          % Nombre de symboles
Fe = 2*1e7;       % fréquence d'échantillonage
Te = 1/Fe;      % Période d'échantillonage
Ts = 1e-6;      % Temps Symbole
Ds = 1/Ts;       % Debit symbole
Fse = Ts*Fe;    % Facteur de sur-échantillonnage
Ns = 10;      % Nombre de symbole/bits par messages
Nb = Ns;        % Nombre de bits par messages on a �galit� cas particulier d'une 2 PAM
N = 512;        % Nombre de points pour la transformé de fourrier
axe_freq = -Fe/2 : Fe/N : Fe/2 - Fe/N; % cr�ation de l'axe fr�quentielle pour le trac� de r�sultats
lambda = 1;


%Variables pour le TEB

Eb = 5;%10
eb_sur_No_db = 0:1:10; % cr�ation du vecteur qui contient les vecteur espac� de 0.5 pour le trac� de la TEB
eb_sur_no_dc = 10.^(eb_sur_No_db./10);% Calcule du vecteur qui contient les vecteurs espac� en decimale pour la TEB
sigma = sqrt((1/2)*(1./eb_sur_no_dc)*Eb);%NO/2 % vecteur qui r�pr�sente l'ensemble des sigma a injecter dans la teb
TEB = zeros(1,size(sigma,2)); % initialisation du vecteur de la teb
compteur_paquet = 0; % compteur necessaire au bon fonctionnement de la teb
erreur = 0; % seuil d'erreur pour arrete un calcule le teb


%impulsion pO encodant le bit 0

po=[0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1];
% trouver fonction echelon plus jolie dans le code
%impulsion p1 encodant le bit 1

p1=[1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0];

%impulsion p(t) filtre de reception
p=[-0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 -0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 ];

p_inverse=fliplr(p);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%  Emetteur  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
signal_bits = randi(2,1,Ns)-1; % génération du signal a envoyé

sl = Emetteur(signal_bits,po,p1); % r�cup�ration du signal en sortie de l'�metteur


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%  Canal  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Filtre du canal
     %{
        On suppose que le signal est émis dans la bande passante du
        canal, ce dernier est donc non sélectif en fréquence et est
        modélisé par un dirac.
      %}
    
% Bruit   
ecart_type = 0;
yl = Canal(sl,ecart_type);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%  Recepteur  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%  Filtre de reception  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[rl,rl_ech] = Recepteur(yl,p_inverse,Fse,Ns); % dans le code d'avant il y avait +1 a comprendre a quoi ca sert et pk on en a pas besion

% vérifier avec le prof si le filtre marche bien et pourqoi on a
% différentes valeurs

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Decision%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
signal_recu = Decision(rl_ech);
nb_erreur = 0;


for i=1:size(signal_recu,2)
                 if (signal_recu(i) ~= signal_bits(i))
                     nb_erreur = nb_erreur + 1
                 end
             end




% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Calcul de la TEB %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if TEB_activation==true

     for k=1:size(sigma,2) % pour chanque valeur de sigma nous allons calculer un teb
 
        while erreur < 100 % si le nombre d'erreur depasse 100 on sort de la boucle
            % dans cette partie nous repetons le nombre de fois la partie pr�c�dente
             compteur_paquet = compteur_paquet+1;
             signal_bits_teb = randi([0,1],1,Nb);
             sl_teb = Emetteur(signal_bits,po,p1); %voir implementatino avec la fonction canal
%              nl =  sigma(k) * randn(1,size(sl_teb,2)); %cr�ation d'un bruit blanc haussien centr� a chaque parcours de la boucle
%              yl = sl_teb + nl;
             yl = Canal(sl_teb,sigma(k));
     % Recepteur
             [rl_teb,rl_ech_teb]=Recepteur(yl,p,Fse,Ns);
             signal_recu_teb = Decision(rl_ech_teb);
             %signal_recu_teb = demodulatePPM(yl,Fse);
             nb_erreur = 0;
             for i=1:size(signal_recu_teb,2)
                 if (signal_recu_teb(i) ~= signal_bits_teb(i))
                     nb_erreur = nb_erreur + 1;
                 end
             end
             erreur = erreur + nb_erreur;
        end
        TEB(k)= erreur/(Nb*compteur_paquet);
        erreur = 0;
        compteur_paquet = 0;
     end
 
%     % Calcul du Pb
% 
%     Pb = (1/2)*erfc(sqrt(eb_sur_no_dc)); 

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

 %Représentation de rl
 figure;
 plot(linspace(0,length(rl)-1,length(rl)),rl);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Trac� de la TEB %%%%%%%%%%%%%%%%%%%%%%%%%
figure;
% plot(eb_sur_No_db,10*log(Pb),'black','linewidth',1)
% hold on;
semilogy(eb_sur_No_db,TEB)
%plot(eb_sur_No_db,10*log(TEB),'r','linewidth',1)
title('TEB');
xlabel('Eb/No db');
ylabel('TEB en db');























%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%Commentaires%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%� mettre sous forme de fonctions pas ultra propre comme ca