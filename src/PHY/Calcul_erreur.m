function [outputArg1,outputArg2] = Calcul_erreur(inputArg2)
%CALCULERREUR Summary of this function goes here
%   Detailed explanation goes here
nb_erreur = 0;



for l=1:size(signal_recu_teb,2)
    if (signal_recu_teb(l) ~= signal_bits_teb(l))*
        nb_erreur = nb_erreur + 1;
    end
end 
outputArg1 = inputArg1;
outputArg2 = inputArg2;
end

