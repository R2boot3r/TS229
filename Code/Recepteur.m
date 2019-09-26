function [rl,rl_ech] = Recepteur(yl,p_inverse,Fse,Ns)
%RECEPTEUR Summary of this function goes here
%   Detailed explanation goes here
rl = conv(yl, p_inverse); % pour mettre le signal dans la même base il y a deux période car l'un est échantilloné a Ts et l'autre a Te
rg = 9.5; % retard du filtre g causal calculé par fvtool(g)

rl_ech = rl(9+(0:Fse:Fse*(Ns-1))); % dans le code d'avant il y avait +1 a comprendre a quoi ca sert et pk on en a pas besion



end

