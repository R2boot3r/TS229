%_____________________________________________________________%
%______________Projet de Communication Numérique ____________%
%_____________________________________________________________%
%__________Alexandra Abulaeva & Julien Choveton-Caillat_______%

clc;clear;close all;
tic
load('../data/buffers.mat')

addpath('../src/Client', '../src/General', '../src/MAC', '../src/PHY'); % Ajout d'emplacement de certains scripts/fonctions

%%
%%%%%%%%%%%%%%%%%%%  Variables   %%%%%%%%%%%%%%%%%%%%

Fe = 4e6; % Frequence d'echantillonnage (imposee par le serveur)
Rb = 1e6;% Debit binaire (=debit symbole)
Fse = floor(Fe/Rb); % Nombre d'echantillons par symboles

% Variables propre � l'affichage dans la console

DISPLAY_MASK1 = '| %12.12s | %10.10s | %6.6s | %3.3s | %8.8s | %3.3s | %8.8s | %11.11s | %4.4s | %12.12s | %12.12s | %3.3s |\n'; % Format pour l'affichage
DISPLAY_MASK2 = '| %12.12s |      %1.0f     | %6.6s | %3.0f | %8.8s | %3.0f | %8.8s | %11.0f | %4.0f | %12.9f | %12.9f | %3.3s |\n'; % Format pour l'affichage
CHAR_LINE =  '+--------------+------------+--------+-----+----------+-----+----------+-------------+------+--------------+--------------+-----+\n'; % Lignes


seuil_detection = 0.75; % Seuil pour la detection des trames (entre 0 et 1)

% Coordonnees de reference (endroit de l'antenne)
REF_LON = -0.606629; % Longitude de l'ENSEIRB-Matmeca
REF_LAT = 44.806884; % Latitude de l'ENSEIRB-Matmeca
affiche_carte(REF_LON, REF_LAT);



%% %%%%%%%%%%%% Boucle principal %%%%%%%%%%%%%%%%%%%

listOfPlanes = [];
n = 1;
load('../data/buffers.mat')
fprintf(DISPLAY_MASK1,'     n      ',' t (in s) ','Corr.', 'DF', '  AA  ','FTC','   CS   ','ALT (in ft)','CPRF','LON (in deg)','LAT (in deg)','CRC')

for k = 1:length(buffers(1,:))
    cprintf('blue',CHAR_LINE)
    cplxBuffer = buffers(:,k)'; %%get_buffer(SERVER_ADDRESS);
    
    [liste_new_registre, liste_corrVal] = process_buffer(cplxBuffer, REF_LON, REF_LAT, seuil_detection, Fse);
    listOfPlanes = update_liste_avion(listOfPlanes, liste_new_registre, DISPLAY_MASK1, Fe, n, liste_corrVal);
    for plane_ = listOfPlanes
        plot(plane_);
    end
 
end   


toc
