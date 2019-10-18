%_____________________________________________________________%
%______________Projet de Communication NumÃ©rique ____________%
%_____________________________________________________________%
%__________Alexandra Abulaeva & Julien Choveton-Caillat_______%

% bit2registre
% bit2registre est une fonciton qui prend un paquet lu sur le canal et en
% extrait les informations.
%
% La syntaxte est la suivante : registre = decodeADSB(bitPacketCRC)
%
% bitPacketCRC est le message reï¿½u (sans le prï¿½ambule), c'est un message
% binaire de 112 bits
%
% la sortie est un registre contenant ...

%addpath('../PHY'); % Ajout d'emplacement de certains scripts/fonctions

function registre_ouput = bit2registre(bitPacketCRC,registre_input,refLon,refLat)
%% Variables
tableau_char = '_ABCDEFGHIJKLMNOPQRSTUVWXYZ_____ _______________0123456789______';


% Déclarations des variables/indices local de positions
%indice trame ADS-B
index_pre = 7; %Attention bitPacket ne contient pas le préambule il faut donc décaler toutes les valeurs suivantes de 7
index_format = [8 12]; %  1 debut, 2 fin
index_adress = [16 39];
index_Adsb = [40 95];

% variables pour le CRC
polynomial = [1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 0 1 0 0 1]; % polynome generateur
generator = crc.generator(polynomial); % generateur crc semble ne servir a rien a enlever
detector = crc.detector(polynomial); % detecteur crc

%indice données trame ADS-B
index_type = [1 5];
                
%variables pour le calcul de la longitude et de la latitude
Nz = 15;
Nb = 17;


%% Code de la fonction Principale
%% decodeur crc
[bitPacket, error_flag] = detector.detect(bitPacketCRC'); %detector(signal_recu_code') detect(detector, signal_recu_code')
bitPacket = bitPacket';% information decodé

% [bitPacket, error_flag] = CRC_decode(bitPacketCRC);
% bitPacket = bitPacket'; % inversion ligne/colone

if error_flag == 0 % prise en compte des tram sans erreurs, aucune erreur sur les donné
    
    DF = bi2de(fliplr(bitPacket((index_format(1):index_format(2))-index_pre)));

    % Verification qu'on se trouve dans un cas
    if DF == 17
        registre_input.format = DF;
        registre_input.adresse = bi2de(fliplr(bitPacket((index_adress(1):index_adress(2))-index_pre)));  % a convertir en hexa  
        
        ADS = bitPacket((index_Adsb(1):index_Adsb(2))-index_pre); % recupération des données ADS
        
        registre_input.type = bi2de(fliplr(ADS(index_type(1):index_type(2))));
        
        
        if registre_input.type >= 1 && registre_input.type <= 4
         
           char1 = bin2dec(num2str(ADS(9:14))); %% à utiliser reshape
           char2 = bin2dec(num2str(ADS(15:20)));
           char3 = bin2dec(num2str(ADS(21:26)));
           char4 = bin2dec(num2str(ADS(27:32)));
           char5 = bin2dec(num2str(ADS(33:38)));
           char6 = bin2dec(num2str(ADS(39:44)));
           char7 = bin2dec(num2str(ADS(45:50)));
           char8 =bin2dec(num2str(ADS(51:56)));
            
           registre_input.nom = strcat(tableau_char(char1+1),tableau_char(char2+1),tableau_char(char3+1),tableau_char(char4+1),tableau_char(char5+1),tableau_char(char6+1),tableau_char(char7+1),tableau_char(char8+1));
        end
          
        
        if (registre_input.type >= 5 && registre_input.type <= 18) || (registre_input.type >= 20 && registre_input.type <= 22)
            
            % Temps UTC
            registre_input.timeFlag = bi2de(ADS(21));
            
            % Format CPR
            registre_input.cprFlag = bi2de(ADS(22));

            % Altitude 
            if (registre_input.type >= 5 && registre_input.type <= 8) %si l'avion est au sol altitude = 0 voir si c'est bien le cas sur bordeaux
                registre_input = 0;
            else
                ba = fliplr(ADS(9:20));
                ra = bi2de([ba(1:7) ba(9:12)]);
                registre_input.altitude = 25*ra - 1000;
            end
            
            % Calcule de latitude:
            
            LAT = bi2de(fliplr(ADS(23:39)));
            Dlati = 360/(4*Nz-registre_input.cprFlag);
            Mod = @(x,y)(x-y*floor(x/y));

            %Calcul de j:
            j = floor(refLat/Dlati) + floor(1/2 + Mod(refLat,Dlati)/Dlati - LAT/2.^Nb);
            registre_input.latitude = Dlati*(j+ LAT/2.^Nb);


            % Calcul de Longitude

            Nlat = cprNL(registre_input.latitude);
            LON = bi2de(fliplr(ADS(40:56)));
            Dloni = 360/(Nlat - registre_input.cprFlag) * (Nlat>registre_input.cprFlag) + 360 * (Nlat == registre_input.cprFlag);
            m = floor(refLon/Dloni) + floor(1/2 + Mod(refLon,Dloni)/Dloni - LON/2.^Nb);
            registre_input.longitude = Dloni*(m + LON/2.^Nb);
            
            % Mise dans le vecteur trajectoire de la longitude/latitude
            %registre_input.trajectoire = {registre_input.trajectoire; [registre_input.longitude registre_input.latitude]};
        end
    end
end




registre_ouput = registre_input;


end



%% Comentaire
%il faut prendre a structure concatener en interne et renvoyer la struture
%complété on écrase a chaque fois l'ancienne structure