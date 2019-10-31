function [preamble] = get_preamble(Fse)
zero=zeros(1,Fse);
%impulsion pO encodant le bit 0
po = [zeros(1,Fse/2) ones(1,Fse/2)];
%impulsion p1 encodant le bit 1
p1 = [ones(1,Fse/2) zeros(1,Fse/2)];

p = [-0.5*ones(1,Fse/2) 0.5*ones(1,Fse/2)];

preamble=[p1 p1 zero po po zero zero zero];

%% a voir si on fait bien la convolution
preamble = conv(preamble,p);
preamble = preamble(Fse:end);
    %%[preamble] = get_preamble_(Fse);

end

    