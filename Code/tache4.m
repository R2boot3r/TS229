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




%impulsion pO encodant le bit 0
po = [zeros(1,Fse/2) ones(1,Fse/2)];
%impulsion p1 encodant le bit 1
p1 = [ones(1,Fse/2) zeros(1,Fse/2)];
%impulsion p(t) filtre de reception
p = [-0.5*ones(1,Fse/2) 0.5*ones(1,Fse/2)];
p_inverse = fliplr(p);




signal_bits = randi(2,1,Ns)-1; % génération du signal a envoyé



%ajout preambule 
pream=[ones(1,Fse/2) zeros(1,Fse/2) ones(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2) ones(1,Fse/2) zeros(1,Fse/2) ones(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2)];%equivalent a 8 bits

sl=pream;
for i=length(pream)+1:length(signal_bits)+length(pream)%ajout preambule et modulation uniquement pour l information utile
    if signal_bits(i-length(pream)) == 0       
        sl=[sl po];       
    else    
        sl=[sl p1];
    end
end

ecart_type = 0;
nl = ecart_type * randn(1, length(sl));

yl=sl+nl;
yl=yl(length(pream):1:length(yl)); % on traite uniquement l information utile

%module au carré 
rl=abs(yl).^2;

%synchronisation



vl = conv(rl, p_inverse); % pour mettre le signal dans la même base il y a deux période car l'un est échantilloné a Ts et l'autre a Te

vm = vl(Fse:Fse:Fse*(Ns));

signal_recu=[];
for k=1:length(vm)
    if(vm(k)<0)
        signal_recu(k)=1;
    else
        signal_recu(k)=0;
    end
end






    


