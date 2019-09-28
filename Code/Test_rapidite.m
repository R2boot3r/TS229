Ns = 10000;

signal_bits_1 = randi(2,1,Ns)-1; 
signal_bits_2 = randi(2,1,Ns)-1;

nb_erreur = 0;
tic
for i=1:size(signal_bits_1,2)
                 if (signal_bits_1(i) ~= signal_bits_2(i))
                     nb_erreur = nb_erreur + 1;
                 end
end
toc


tic
mean(abs(signal_bits_1-signal_bits_2))*Ns;
toc

%conclusion la méthode de parcours de la liste est plus rapide pour de
%petit vecteur que la méthode vectoriel mais la méthode vectoriel est plus
%compacte