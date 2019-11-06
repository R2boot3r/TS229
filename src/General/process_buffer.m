
function [list_new_registre, list_corrval] = process_buffer(cplxBuffer, REF_LON, REF_LAT,seuil_Detection, Fse)


%-> synchro temps :              couche PHY
%-> decodePPM(packet,pulse0,pulse1) :              couche PHY
%-> bits2registre(bitPacketCRC,refLon,refLat) :    couche MAC

%%
%%%%%%%%%%%%%%%%%%%  Variables   %%%%%%%%%%%%%%%%%%%%
    
    rl = abs(cplxBuffer).^2;
    
    preambule = get_preamble(Fse);
    size_cplx = length(rl);
    size_preambule = length(preambule);                                     
    cursor = 1;                                                             % Initialisation de la varible du while
    
    list_new_registre = {};
    list_corrval = [];
    size_data = 112;                                                        % taile d'une trame adsb
    
    Pcorr = sum(preambule.^2); % Le calcul de Pcorr de fait ici car il est inutile de le recalculer a chaque fois dans synchro, on a toujours la même valeur
    
    
    %%
    %%%%%%%%%%%%% Coeur de la Fonction  %%%%%%%%%%%%%%
    
    
    longeur_util_buff = size_cplx-size_preambule-size_data*Fse-1;
    
    while cursor < longeur_util_buff  % Le while permet de parcourir l'ensemble des élements du buffer, On pourrait s'arreter à size_cplx-size_preambule-size_data*Fse -1
        
    [maxi, ~] = synchro(rl(cursor:cursor+size_preambule),1,preambule,Fse,Pcorr); %% on réalise la synchronisation sur des segments de 32 bits taille du préambule
    
    if maxi > seuil_Detection

       [signal_recu] = demodulatePPM(rl(cursor+size_preambule:cursor+size_preambule+size_data*Fse-1),Fse);
       
       b = bit2registre(signal_recu,REF_LON,REF_LAT);
       
        if ~isempty(b.adresse) % On rempli la liste de registre que si on se trouve dans le ou l'avion a une adresse pour l'identifier
            list_new_registre = [list_new_registre b];
            list_corrval = [list_corrval maxi];
        end
    end
    cursor = cursor + 1;
end

    
    %[list_new_registre, list_corrval] = process_buffer_(cplxBuffer, REF_LON, REF_LAT,seuilDetection, Fse);
end

