%____________________________________________________________%
%_______________Projet de Communication Numérique ___________%
%____________________________________________________________%
%____________Alexandra Abulaeva & Julien Choveton-Caillat__________%



%% ADSB Application
%% Initialisation
clc
clear
close all
load('../data/buffers.mat'); %Chargement des donn�es 

addpath('../src/Client', '../src/General', '../src/MAC', '../src/PHY'); % Ajout d'emplacement de certains scripts/fonctions
load('../data/adsb_msgs.mat'); %Chargement des donn�es 

% addpath('Client', 'General', 'MAC', 'PHY');
%% Constants definition
DISPLAY_MASK = '| %12.12s | %10.10s | %6.6s | %3.3s | %6.6s | %3.3s | %8.8s | %11.11s | %4.4s | %12.12s | %12.12s | %3.3s |\n'; % Format pour l'affichage
CHAR_LINE = '+--------------+------------+--------+-----+--------+-----+----------+-------------+------+--------------+--------------+-----+\n'; % Lignes

% SERVER_ADDRESS = 'mader';

% Coordonnees de reference (endroit de l'antenne)
REF_LON = -0.606629; % Longitude de l'ENSEIRB-Matmeca
REF_LAT = 44.806884; % Latitude de l'ENSEIRB-Matmeca

%affiche_carte(REF_LON, REF_LAT);

%% Couche Physique
Fe = 4e6; % Frequence d'echantillonnage (imposee par le serveur)
Rb = 1e6;% Debit binaire (=debit symbole)
Fse = floor(Fe/Rb); % Nombre d'echantillons par symboles
seuil_detection = 0.75; % Seuil pour la detection des trames (entre 0 et 1)
p = [-0.5*ones(1,Fse/2) 0.5*ones(1,Fse/2)];
p_inverse = fliplr(p);




List_Planes = [];
List_Corrval = ones(1,27); 
n = 1;
registre = struct('adresse',[],'format',[],'type',[],'nom',[],'altitude',[],'timeFlag',[],'cprFlag',[],'latitude',[],'longitude',[],'trajectoire',[]);
tableau_car = struct('A',1,'B',2,'C',3,'D',4,'E',5,'F',6,'G',7,'H',8,'I',9,'J',10,'K',11,'L',12,'M',13,'N',14,'O',15,'P',16,'Q',17,'R',18,'S',19,'T',20,'U',21,'V',22,'W',23,'X',24,'Y',25,'Z',26,'SP',32,"A0",48,'A1',49,'A2',50,'A3',51,'A4',52,'A5',53,'A6',54,'A7',55,'A8',56,'A9',57);

% Variables propre � l'affichage dans la console

DISPLAY_MASK1 = '| %12.12s | %10.10s | %6.6s | %3.3s | %8.8s | %3.3s | %8.8s | %11.11s | %4.4s | %12.12s | %12.12s | %3.3s |\n'; % Format pour l'affichage
DISPLAY_MASK2 = '| %12.12s |      %1.0f     | %6.6s | %3.0f | %8.8s | %3.0f | %8.8s | %11.0f | %4.0f | %12.9f | %12.9f | %3.3s |\n'; % Format pour l'affichage
CHAR_LINE =  '+--------------+------------+--------+-----+----------+-----+----------+-------------+------+--------------+--------------+-----+\n'; % Lignes

% Variables de Position de reference de l'antenne

Ref_Lon = -0.606629; %longitute de l'antenne
Ref_Lat = 44.806884; %latitude de l'antenne

%

%% Boucle principale
% listOfPlanes = [];
% n = 1;
% while true
%     cprintf('blue',CHAR_LINE)
%     cplxBuffer = get_buffer(SERVER_ADDRESS);
%     
%     [liste_new_registre, liste_corrVal] = process_buffer(cplxBuffer, REF_LON, REF_LAT, seuil_detection, Fse);
%     listOfPlanes = update_liste_avion(listOfPlanes, liste_new_registre, DISPLAY_MASK, Fe, n, liste_corrVal);
%     
%      for plane_ = listOfPlanes
%         plot(plane_);
%      end
% end   
yl=buffers(:,1)';
zero=zeros(1,Fse);
%impulsion pO encodant le bit 0
po = [zeros(1,Fse/2) ones(1,Fse/2)];
%impulsion p1 encodant le bit 1
p1 = [ones(1,Fse/2) zeros(1,Fse/2)];
pream=[p1 p1 zero po po zero zero zero];

rl=abs(yl).^2; %afin d eviter de chercher df

%synchronisation
a=length(rl);
curs=1;

b = bit2registre(adsb_msgs(:,1)',registre,Ref_Lon,Ref_Lat)

registre = {};
p=1;
% while curs< a-length(pream)-1
%    
%     [maxi dt]=synchro(rl(curs:end),1,pream,Fse);
%     if maxi>seuil_detection
%         signal_recu=[];
%     for k=1: 112
%         if(real(yl(curs+k+length(pream)-1))<0)
%             signal_recu(k)=1;
%         else
%             signal_recu(k)=0;
%         
%         end
%     end
%         registre =[registre, bit2registre(signal_recu(1:112),registre,Ref_Lon,Ref_Lat)]
%    
%     end
%     p=p+1;
%      curs=curs+1;
%     
% end

