function [sl] = Emetteur(signal_bits,po,p1)
% Association bits/symboles
sl=[];
for i=1:length(signal_bits)
    if signal_bits(i) == 0       
        sl=[sl po];       
    else    
        sl=[sl p1];
    end
end

end
%peut etre moyen plus rapide que boucle
