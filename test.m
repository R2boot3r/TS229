%_____________________________________________________________%
%______________Projet de Communication Numérique ____________%
%_____________________________________________________________%
%__________Alexandra Abulaeva & Julien Choveton-Caillat_______%




load('data/adsb_msgs.mat'); %Chargement des donn�es 
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



a=length(A);
curs=1;
list_new_registre = {};
registre = struct('adresse',[],'format',[],'type',[],'nom',[],'altitude',[],'timeFlag',[],'cprFlag',[],'latitude',[],'longitude',[],'trajectoire',[]);

compteur = 0;
p=1;


%% Boucle principal


while curs< a-length(pream)-1
   
    [maxi, dt]=synchro(A(curs:end),1,pream,Fse);
    if maxi>seuil_detection
       dt
       curs
       list_new_registre = [list_new_registre   bit2registre1(A(curs+length(pream):curs+length(pream)+111),Ref_Lon,Ref_Lat)];
       compteur = compteur + 1;
    end
    p=p+1;
     curs=curs+1;
    
end
