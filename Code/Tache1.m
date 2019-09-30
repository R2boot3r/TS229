%____________________________________________________________%
%_______________Projet de Communication Numérique ___________%
%____________________________________________________________%
%____________Agnia Savina & Julien Choveton-Caillat__________%

clear ;close all ; clc


%%%%%%%%%%%%%%%%%%%  Variables D'activation  %%%%%%%%%%%%%%%%%%%%
%Variables gén
TEB_activation = false;
Affichage_courbe = true;

%%%%%%%%%%%%%%%%%%%  Initialisation des variables  %%%%%%%%%%%%%%%%%%%%
%Variables général

M = 2;          % Nombre de symboles
Fe = 2*1e7;       % fréquence d'échantillonage
Te = 1/Fe;      % Période d'échantillonage
Ts = 1e-6;      % Temps Symbole
Ds = 1/Ts;       % Debit symbole
Fse = Ts*Fe;    % Facteur de sur-échantillonnage
Ns = 5;      % Nombre de symbole/bits par messages
Nb = Ns;        % Nombre de bits par messages on a �galit� cas particulier d'une 2 PPM

%Variables pour le TEB

Eb = 5;%10 % a trouver l'erreur binaire th�orique donner par Yassine
eb_sur_No_db = 0:1:10; % cr�ation du vecteur qui contient les vecteur espac� de 0.5 pour le trac� de la TEB
eb_sur_no_dc = 10.^(eb_sur_No_db./10);% Calcule du vecteur qui contient les vecteurs espac� en decimale pour la TEB
sigma = sqrt((1/2)*(1./eb_sur_no_dc)*Eb);%NO/2 % vecteur qui r�pr�sente l'ensemble des sigma a injecter dans la teb
TEB = zeros(1,size(sigma,2)); % initialisation du vecteur de la teb
compteur_paquet = 0; % compteur necessaire au bon fonctionnement de la teb
erreur = 0; % seuil d'erreur pour arrete un calcule le teb



%impulsion pO encodant le bit 0
po = [zeros(1,Fse/2) ones(1,Fse/2)];
%impulsion p1 encodant le bit 1
p1 = [ones(1,Fse/2) zeros(1,Fse/2)];
%impulsion p(t) filtre de reception
p = [-0.5*ones(1,Fse/2) 0.5*ones(1,Fse/2)];
p_inverse = fliplr(p);




signal_bits = randi(2,1,Ns)-1; % génération du signal a envoyé
signal_bits = [1 0 0 1 0]

sl=[];
for i=1:length(signal_bits)
    if signal_bits(i) == 0       
        sl=[sl po];       
    else    
        sl=[sl p1];
    end
end

ecart_type = 0;
nl = ecart_type * randn(1, length(sl));

yl=sl+nl;
rl = conv(yl, p_inverse); % pour mettre le signal dans la même base il y a deux période car l'un est échantilloné a Ts et l'autre a Te

rm = rl(Fse:Fse:Fse*Ns);

signal_recu=[];
for k=1:length(rm)
    if(rm(k)<0)
        signal_recu(k)=1;
    else
        signal_recu(k)=0;
    end
end
nb_erreur=0;
for i=1:size(signal_recu,2)
                 if (signal_recu(i) ~= signal_bits(i))
                     nb_erreur = nb_erreur + 1
                 end
end

if TEB_activation==true
     for k=1:size(sigma,2) % pour chanque valeur de sigma nous allons calculer un teb
     
         % génération du signal a envoyé
         signal_bits_teb = randi(2,1,Ns)-1; 
         sl=[];
         for i=1:length(signal_bits_teb)
              if signal_bits_teb(i) == 0       
                   sl=[sl po];       
              else    
                   sl=[sl p1];
              end
         end

            while erreur < 100 % si le nombre d'erreur depasse 100 on sort de la boucle
                % dans cette partie nous repetons le nombre de fois la partie pr�c�dente
                compteur_paquet = compteur_paquet+1;
                
                %g�n�ration du bruit du signal
                nl = sigma(k) * randn(1, length(sl));
                yl=sl+nl;
                %reception du signal
                rl = conv(yl, p_inverse);
                rm = rl(Fse:Fse:Fse*Ns);      


                %Filtre de d�cision
                signal_recu_teb=[];
                for j=1:length(rm)
                    if(rm(j)<0)
                        signal_recu_teb(j)=1;
                    else
                        signal_recu_teb(j)=0;
                    end
                end

                 nb_erreur = 0;
                 for l=1:size(signal_recu_teb,2)
                     if (signal_recu_teb(l) ~= signal_bits_teb(l))
                         nb_erreur = nb_erreur + 1;
                     end
                 end
                 k
                 erreur = erreur + nb_erreur
            end
            TEB(k)= erreur/(Nb*compteur_paquet);
            erreur = 0;
            compteur_paquet = 0;
     end
end

pb = 1/2*erfc(sqrt(eb_sur_no_dc));

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%  Figures de résultats  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if Affichage_courbe==true
    tiledlayout(2,1)
    % Représentation de sl(t)
    
    nexttile;
    plot(linspace(0,50*Ts-Te,length(sl)),sl,'linewidth',2);
    title("Allure temporelle de sl(t)");
    xlabel("t en secondes");
    ylabel("sl(t) en amplitude symbol");

    % Représentation de rl(t)

    nexttile;
    plot(linspace(0,50*Ts-Te,length(rl)),rl,'g','linewidth',2);
    title("Allure temporelle de rl(t)");
    xlabel("t en secondes");
    ylabel("Amplitude symbol");
   
    % Représentation de rm(t)
    
    nexttile;
    plot(linspace(0,50*Ts-Te,length(rm)),rm,'r','linewidth',2);
    title("Allure temporelle de rm(t)");
    xlabel("t en secondes");
    ylabel("Amplitude symbol");

    
   if TEB_activation==true
    figure;
    semilogy(pb,'LineWidth',2);
    hold on;
    semilogy(TEB,'LineWidth',2);
    title('TEB');
    xlabel('Eb/No db');
    ylabel('TEB ');
    legend('Pb', 'Teb');
    set(gca,'FontSize',14);
   end
end