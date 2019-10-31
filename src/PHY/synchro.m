function [seuil dt]=synchro(bits,errmax,pream,Fse)
    
    M=[];
    Coef=[];
    Pcorr=sum(pream.^2); %% a sortir d'ici pas besoin de la recalculer a chaque boucle inéffica car la valeur de pream ne change jamais
    for g=1:errmax % formule de la prediction sur des segments de 160 cases,taille de pream
        r = sum(bits(g:g+8*Fse-1).^2); % a remplacer par g
        M=[M ;sum(bits(g:g+8*Fse-1).*pream)./sqrt(Pcorr*r)];%Rcorr(g,1)
        Coef=[Coef;(M(g))];
        
    end
[seuil dt]=max(Coef);
end