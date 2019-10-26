function modSig = modulatePPM(sig, Fse)


    %impulsion pO encodant le bit 0
    po = [zeros(1,Fse/2) ones(1,Fse/2)];    
    %impulsion p1 encodant le bit 1
    p1 = [ones(1,Fse/2) zeros(1,Fse/2)];

    modSig=[]; 
    %% voir si cela ne peux pas être fait de manière vectoriel
for i=1:length(sig)
    if sig(i) == 0       
        modSig=[modSig po];       
    else    
        modSig=[modSig p1];
    end
end
   
    
    %modSig = modulatePPM_(sig, Fse);
end
%% Voir si on ne peux pas eviter la boucle ? 