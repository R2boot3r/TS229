function [signal_recu] = Decision(rl_ech)
%DECISION Summary of this function goes here
%   Detailed explanation goes here
signal_recu=[];
for k=1:length(rl_ech)
    if(rl_ech(k)<0)
        signal_recu(k)=1;
    else
        signal_recu(k)=0;
    end
end

end

