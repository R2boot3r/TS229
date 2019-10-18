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
n = 1;
registre = struct('adresse',[],'format',[],'type',[],'nom',[],'altitude',[],'timeFlag',[],'cprFlag',[],'latitude',[],'longitude',[],'trajectoire',[]);


% Variables propre à l'affichage dans la console

DISPLAY_MASK1 = '| %12.12s | %10.10s | %6.6s | %3.3s | %8.8s | %3.3s | %8.8s | %11.11s | %4.4s | %12.12s | %12.12s | %3.3s |\n'; % Format pour l'affichage
DISPLAY_MASK2 = '| %12.12s |      %1.0f     | %6.6s | %3.0f | %8.8s | %3.0f | %8.8s | %11.0f | %4.0f | %12.9f | %12.9f | %3.3s |\n'; % Format pour l'affichage
CHAR_LINE =  '+--------------+------------+--------+-----+----------+-----+----------+-------------+------+--------------+--------------+-----+\n'; % Lignes

% Variables de Position de reference de l'antenne

Ref_Lon = -0.606629; %longitute de l'antenne
Ref_Lat = 44.806884; %latitude de l'antenne

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


% Plot trajectoire + logo avion
STYLES = {'-','--',':'};
STYLES_HEAD = {'x','o','<'};
COLORS = lines(6);
COLORS(4,:)=[];

figure(1);
hold on;

%% Tracé du graph
x = linspace(-1.3581,0.7128,1024);
y = linspace(44.4542,45.1683,1024);

[X,Y] = meshgrid(x,y(end:-1:1));

%tracé de l'image
im = imread('fond.png');
image(x,y(end:-1:1),im);

% Tracé de la position actuelle
plot(Ref_Lon,Ref_Lat,'.r','MarkerSize',20);
text(Ref_Lon+0.05,Ref_Lat,0,'Actual pos','color','b')


% Variables/logo d'affichage sur la carte
for i = 1:1:size(adsb_msgs,2)
    registre = bit2registre(adsb_msgs(:,i)',registre,Ref_Lon,Ref_Lat);

    fprintf(DISPLAY_MASK2,'            ', registre.timeFlag   ,'   1   ',registre.format,registre.nom,registre.type,'   CS   ',registre.altitude,registre.cprFlag,registre.longitude,registre.latitude,' 0 ')
    fprintf(CHAR_LINE)
    plot(registre.longitude,registre.latitude,'.g','MarkerSize',20);


end

%% il va falloir rajouter en plus dans le registre le cas ou on obtiens plusieurs avions,un indice i a passer en argument de registre ? 

% Definition des axes et des limites d'axes
set(gca,'YDir','normal')
xlabel('Longitude en degres');
ylabel('Lattitude en degres');
zlim([0,4e4]);

% Bdx
xlim([-1.3581,0.7128]);
ylim([44.4542,45.1683]);













