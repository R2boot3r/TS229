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

errmax=100;


%impulsion pO encodant le bit 0
po = [zeros(1,Fse/2) ones(1,Fse/2)];
%impulsion p1 encodant le bit 1
p1 = [ones(1,Fse/2) zeros(1,Fse/2)];
%impulsion p(t) filtre de reception
p = [-0.5*ones(1,Fse/2) 0.5*ones(1,Fse/2)];
p_inverse = fliplr(p);




signal_bits = randi(2,1,Ns)-1; % génération du signal a envoyé



%ajout preambule 
zero=zeros(1,Fse);
pream=[p1 p1 zero po po zero zero zero];

sl=pream;
for i=length(pream)+1:length(signal_bits)+length(pream)%ajout preambule et modulation 
    if signal_bits(i-length(pream)) == 0       
        sl=[sl po];       
    else    
        sl=[sl p1];
    end
end

%canal
ecart_type = 0;
dt=randi(errmax,1);
df=randi(2000,1)-1000;
decaltemp=zeros(1,dt);% decalage temporel
sl=[decaltemp sl];
nl = ecart_type * randn(1, length(sl));
sl2=sl*exp(j*2*pi*df);
yl=sl2+nl;% decalage frequentiel


%module au carré 
rl=abs(yl).^2; %afin d eviter de chercher df

%synchronisation
Pcorr=sum(pream.^2);
Rcorr=[];
for y=1:errmax
    Rcorr=[Rcorr;sum(rl(y:y+8*Fse).^2)];
end

M=[];
for g=1:errmax %formule de la prediction sur des segments de 160 cases,taille de pream
    M=[M ;xcorr(pream,rl(g:g+8*Fse),8*Fse-1)./sqrt(Pcorr*Rcorr(g,1))];
end
Coef=[];
for u=1:errmax%contient la valeur de la prediction a la case 159,soit en 0 puisqu matlab decale tout du coté des positif
    Coef=[Coef;(M(u,8*Fse-1))];
end
[max dtrecu]=max(Coef);%on prend le maximum du tableau,le maxim de l intercorrelation en 0 et on prend l indice de la ligne


vl = conv(rl, p_inverse); % pour mettre le signal dans la même base il y a deux période car l'un est échantilloné a Ts et l'autre a Te

vm = vl(Fse:Fse:Fse*Ns);

signal_recu=[];
for k=1:length(vm)
    if(vm(k)<0)
        signal_recu(k)=1;
    else
        signal_recu(k)=0;
    end
end

nb_erreur = 0;
for l=1:length(signal_recu)
    if (signal_recu(l) ~= signal_bits(l))
        nb_erreur = nb_erreur + 1;
    end
end





    


