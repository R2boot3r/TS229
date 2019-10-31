%_____________________________________________________________%
%______________Projet de Communication Numérique ____________%
%_____________________________________________________________%
%__________Alexandra Abulaeva & Julien Choveton-Caillat_______%

clc;clear;close all;


load('data/adsb_msgs.mat'); %Chargement des donn�es 
%%load('data/buffers.mat');
load('C:\Users\R2boot3r\Documents\TS229\data\buffers.mat')
addpath('src/Client', 'src/General', 'src/MAC', 'src/PHY'); % Ajout d'emplacement de certains scripts/fonctions

Fe = 4e6; % Frequence d'echantillonnage (imposee par le serveur)
Rb = 1e6;% Debit binaire (=debit symbole)
Fse = floor(Fe/Rb); % Nombre d'echantillons par symboles
zero=zeros(1,Fse);

%impulsion pO encodant le bit 0
po = [zeros(1,Fse/2) ones(1,Fse/2)];
%impulsion p1 encodant le bit 1
p1 = [ones(1,Fse/2) zeros(1,Fse/2)];

pream=[p1 p1 zero po po zero zero zero];

seuil_detection = 0.75; % Seuil pour la detection des trames (entre 0 et 1)

% Coordonnees de reference (endroit de l'antenne)
REF_LON = -0.606629; % Longitude de l'ENSEIRB-Matmeca
REF_LAT = 44.806884; % Latitude de l'ENSEIRB-Matmeca
Ref_Lon = -0.606629; %longitute de l'antenne
Ref_Lat = 44.806884; %latitude de l'antenne




A = [1 0 1 0 pream adsb_msgs(:,1)' 0 1 0 1 pream adsb_msgs(:,2)']; 
yl = buffers(:,1)';
rl=abs(yl).^2; %afin d eviter de chercher df

a=length(rl);
curs=1;
list_new_registre = {};

compteur = 0;
p=1;

%pream = get_preamble(Fse);
%% Boucle principal


while curs< a-length(pream)-1
   
    [maxi, dt]=synchro(rl(curs:curs+32),1,pream,Fse);
    if maxi>seuil_detection
       maxi
       dt
       curs
       
       [signal_recu] = demodulatePPM(rl(curs+length(pream):curs+length(pream)+112*Fse-1),Fse,length(pream),curs);
       signal_recu
       b = bit2registre1(signal_recu,Ref_Lon,Ref_Lat)
        if ~isempty(b.format)
            list_new_registre = [list_new_registre b];
        end
%      list_new_registre = [list_new_registre   bit2registre1(A(curs+length(pream):curs+length(pream)+112),Ref_Lon,Ref_Lat)];
       compteur = compteur + 1;
    end
    curs=curs+1;
    if (mod(curs,1000)==0)
        curs;
    end
end
