%____________________________________________________________%
%_______________Projet de Communication Numérique ___________%
%____________________________________________________________%
%____________Alexandra Abulaeva & Julien Choveton-Caillat__________%

clear ;close all ; clc




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
errmax=100;     %decalage temporel maximale


%Variables pour le TEB

Eb = 5;%10 % a trouver l'erreur binaire th�orique donner par Yassine
eb_sur_No_db = 1:1:10; % cr�ation du vecteur qui contient les vecteur espac� de 0.5 pour le trac� de la TEB
eb_sur_no_dc = 10.^(eb_sur_No_db./10);% Calcule du vecteur qui contient les vecteurs espac� en decimale pour la TEB
sigma = sqrt((1/2)*(1./eb_sur_no_dc)*Eb);%NO/2 % vecteur qui r�pr�sente l'ensemble des sigma a injecter dans la teb
TEB = zeros(1,size(sigma,2)); % initialisation du vecteur de la teb
compteur_paquet = 0; % compteur necessaire au bon fonctionnement de la teb
erreur = 0; % seuil d'erreur pour arrete un calcule le teb
pb = 1/2*erfc(sqrt(eb_sur_no_dc));

%impulsion pO encodant le bit 0
po = [zeros(1,Fse/2) ones(1,Fse/2)];
%impulsion p1 encodant le bit 1
p1 = [ones(1,Fse/2) zeros(1,Fse/2)];
%impulsion p(t) filtre de reception
p = [-0.5*ones(1,Fse/2) 0.5*ones(1,Fse/2)];
p_inverse = fliplr(p);
% preambule 
zero=zeros(1,Fse);
pream=[p1 p1 zero po po zero zero zero];
% decalage temporel et frequentiel
dt = randi(errmax,1);
df = randi(2000,1)-1000;
decaltemp =zeros(1,dt);



% génération du signal a envoyé

signal_bits = randi(2,1,Ns)-1; 

% modulation
sl=modulatePPM(signal_bits,Fse);

% preambule

sl=[pream sl];

%canal
ecart_type = 0;

sl=[decaltemp sl];
nl = ecart_type * randn(1, length(sl));
sl2=sl*exp(j*2*pi*df);
yl=sl2+nl;% decalage frequentiel


%module au carré 
rl=abs(yl).^2; %afin d eviter de chercher df on "converti" toutes les valeurs complexe

%synchronisation
Pcorr=sum(pream.^2);

[maxi dtrecu]=synchro(rl,errmax,pream,Fse,Pcorr); % on prend le maximum du tableau,le maxim de l intercorrelation en 0 et on prend l indice de la ligne


% demodulation
signal_recu=demodulatePPMtache4(rl,Fse,length(pream)+dtrecu);


nb_erreur = 0;
for l=1:length(signal_recu)
    if (signal_recu(l) ~= signal_bits(l))
        nb_erreur = nb_erreur + 1;
        
    end
end

%% TEB

signal_bits_teb = randi(2,1,Ns)-1; % génération du signal a envoyé

% modulation
sl=modulatePPM(signal_bits_teb,Fse);

% preambule

sl_teb=[pream sl];



% decalage temporel et frequentiel
dt_teb = randi(errmax,1);
df_teb=randi(2000,1)-1000;
decaltemp_teb=zeros(1,dt_teb);
sl_teb=[decaltemp_teb sl_teb];
sl2_teb=sl_teb*exp(j*2*pi*df);

%canal
% pour chanque valeur de sigma nous allons calculer un teb
for k=1:size(sigma,2) 
    
         % génération du signal a envoyé
         
            while erreur < 100 % si le nombre d'erreur depasse 100 on sort de la boucle,dans cette partie nous repetons le nombre de fois la partie pr�c�dente
                compteur_paquet = compteur_paquet+1;
                
                %g�n�ration du bruit du signal
                nl = sigma(k) * randn(1, length(sl_teb));
                yl_teb=sl2_teb+nl;% decalage frequentiel 
                
                
                %module au carré 
                rl_teb=abs(yl_teb).^2; %afin d eviter de chercher df
                
                %synchronisation

                [maxi dtrecuteb]=synchro(rl_teb,errmax,pream,Fse,Pcorr); % on prend le maximum du tableau,le maxim de l intercorrelation en 0 et on prend l indice de la ligne

                % demodulation
                
                signal_recu_teb=demodulatePPMtache4(rl_teb,Fse,dtrecuteb+length(pream));  
                
                 nb_erreur = 0;
                 for lte=1:Ns
                     if (signal_recu_teb(lte) ~= signal_bits_teb(lte))
                         nb_erreur = nb_erreur + 1;
                     end
                 end
                 
                 erreur = erreur + nb_erreur;
            end
            TEB(k)= erreur/(Nb*compteur_paquet);
            erreur = 0;
            compteur_paquet = 0;
end
     
%% tracé du TEB
figure;
    semilogy(pb,'LineWidth',2);
    hold on;
    semilogy(TEB,'LineWidth',2);
    title('TEB');
    xlabel('Eb/No db');
    ylabel('TEB ');
    legend('Pb', 'Teb');
    set(gca,'FontSize',14);
    grid on;
    






