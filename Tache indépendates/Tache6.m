%_____________________________________________________________%
%______________Projet de Communication NumÃ©rique ____________%
%_____________________________________________________________%
%__________Alexandra Abulaeva & Julien Choveton-Caillat_______%

clear ;close all ; clc
addpath('../src/Client', '../src/General', '../src/MAC', '../src/PHY'); % Ajout d'emplacement de certains scripts/fonctions
load('../data/adsb_msgs.mat'); %Chargement des données 


%%
%%%%%%%%%%%%%%%%%%%  Initialisation des variables  %%%%%%%%%%%%%%%%%%%%


% Variables général du programme

List_Planes = [];
List_Corrval = ones(1,27); 
List_new_registre = {};
n = 1;
Fe = 4e6; % Frequence d'echantillonnage (imposee par le serveur)

% Variables propre à l'affichage dans la console

DISPLAY_MASK1 = '| %12.12s | %10.10s | %6.6s | %3.3s | %8.8s | %3.3s | %8.8s | %11.11s | %4.4s | %12.12s | %12.12s | %3.3s |\n'; % Format pour l'affichage
DISPLAY_MASK2 = '| %12.12s |      %1.0f     | %6.6s | %3.0f | %8.8s | %3.0f | %8.8s | %11.0f | %4.0f | %12.9f | %12.9f | %3.3s |\n'; % Format pour l'affichage
CHAR_LINE =  '+--------------+------------+--------+-----+----------+-----+----------+-------------+------+--------------+--------------+-----+\n'; % Lignes

% Variables de Position de reference de l'antenne

REF_LON = -0.606629; %longitute de l'antenne
REF_LAT = 44.806884; %latitude de l'antenne
affiche_carte(REF_LON, REF_LAT);


% Variable liée a la couche physique
Fe = 4e6; % fréquence d'échantillonage du server
Rb = 1e6; % Debit binaire
Fse = floor(Fe/Rb); % Nombre d'échantillons par symboles
floor_detection = 0.75; % Seuil pour detection des trames a voir comment et pk

%


%%
%%%%%%%%%%%%%%%%%%%%% Programme principale %%%%%%%%%%%%%%%%%%%%%%

% Impression de l'entete
fprintf(CHAR_LINE)
fprintf(DISPLAY_MASK1,'     n      ',' t (in s) ','Corr.', 'DF', '   AA   ','FTC','   CS   ','ALT (in ft)','CPRF','LON (in deg)','LAT (in deg)','CRC')
fprintf(CHAR_LINE)



% Variables/logo d'affichage sur la carte
for i = 1:1:size(adsb_msgs,2)
    registre = bit2registre(adsb_msgs(:,i)',REF_LON,REF_LAT);
    
    if ~isempty(registre.adresse) % On rempli la liste de registre que si on se trouve dans le ou l'avion a une adresse pour l'identifier
        List_new_registre = [List_new_registre registre];
    end
end


List_Planes = update_liste_avion(List_Planes, List_new_registre, DISPLAY_MASK1, Fe, n, List_Corrval);

for plane_ = List_Planes
        plot(plane_);
end










