function signal_recu = demodulatePPM(packet,Fse)
    

Ns = 1000;

%impulsion p(t) filtre de reception
p = [-0.5*ones(1,Fse/2) 0.5*ones(1,Fse/2)];
p_inverse = fliplr(p);


% _________________Filtre de reception_______________________

rl = conv(packet, p_inverse);                          % pour mettre le signal dans la même base il y a deux période car l'un est échantilloné a Ts et l'autre a Te
rm = rl(Fse:Fse:Fse*Ns);                           % a vori ce que cela fait je me rapelle plus

%_________________ Filtre de decision_________________________

signal_recu = (rm >= 0); %Impl�mentation de la decision de mani�re vectoriel
% signal_recu = [];
% for k=1:length(rm)
%     if(rm(k)<0)
%         signal_recu(k)=1;
%     else
%         signal_recu(k)=0;
%     end
% end
% 








    %bits = demodulatePPM_(packet,Fse);
    signal_recu = demodulatePPM_(packet,Fse);
end