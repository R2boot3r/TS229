function [Corr, dt]=synchro(bits,errmax,pream,Fse,Pcorr)
    %% Focntion qui permet de renvoyer la corrélation entre le signal et le préambule
    
    M=[];
    Coef=[];
    
    for g = 1:errmax    % dans le cas de notre programme on parcours qu'une seul fois la boucle voir si ca ne ralenti pas trop les choses
        
        r = sum(bits(g:g+8*Fse-1).^2); 
        M = [M sum(bits(g:g+8*Fse-1).*pream)./sqrt(Pcorr*r)]; %Rcorr(g,1)
        Coef = [Coef (M(g))];
        
    end
    
[Corr, dt] = max(Coef);
end