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
Npolynome=24;%taille du polynome generateur
tailletotale=Nb+Npolynome; %taille totale de la trame
polynomial=[1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 0 1 0 0 1];%polynome generateur
h=crc.generator(polynomial);%generateur crc
g=crc.detector(polynomial);%detecteur crc




%impulsion pO encodant le bit 0
po = [zeros(1,Fse/2) ones(1,Fse/2)];
%impulsion p1 encodant le bit 1
p1 = [ones(1,Fse/2) zeros(1,Fse/2)];
%impulsion p(t) filtre de reception
p = [-0.5*ones(1,Fse/2) 0.5*ones(1,Fse/2)];
p_inverse = fliplr(p);




signal_bits = randi(2,1,Ns)-1; % génération du signal a envoyé

%codage CRC
msg = reshape(signal_bits,88,1);
encoded=generate(h,msg);%colonne
signal_bits_code=encoded';%ligne

%ajout preambule 01010101
pream=[po po po po po po po po];%equivalent a 8 bits

sl=pream;
for i=length(pream)+1:length(signal_bits_code)+length(pream)%ajout preambule et modulation uniquement pour l information utile
    if signal_bits_code(i-length(pream)) == 0       
        sl=[sl po];       
    else    
        sl=[sl p1];
    end
end

ecart_type = 0;
nl = ecart_type * randn(1, length(sl));

yl=sl+nl;
yl=yl(length(pream):1:length(yl)); %on traite uniquement l information utile
rl = conv(yl, p_inverse); % pour mettre le signal dans la même base il y a deux période car l'un est échantilloné a Ts et l'autre a Te

rm = rl(Fse:Fse:Fse*(tailletotale));%taille crc

signal_recu_code=[];
for k=1:length(rm)
    if(rm(k)<0)
        signal_recu_code(k)=1;
    else
        signal_recu_code(k)=0;
    end
end


%decodeur crc
[outdata error] = detect(g, signal_recu_code');
signal_recu=outdata';%information decode



if error==0
    disp("message est integre en l absence d erreur");
else
    disp("message n'est pas integre en l absence d erreur parmis les 88 bits de données utile")
end
    


