function [y,f] = Mon_Welch1(x,Nfft, Fe)
%MON_WELCH1 Summary of this function goes here
%   Detailed explanation goes here
Nb = length(x);
nombre_fenetre = round(Nb/Nfft);
matrix = zeros(nombre_fenetre,Nfft);
DSP_vector = zeros(1,Nfft);

%% Calcul de la DSP par fenètre
for i = 0 : nombre_fenetre -1  
    fourier_transform = fftshift(fft(x(i*Nfft+1:(i*Nfft+1)+Nfft)));
    matrix(i+1,:) = abs(fourier_transform(1:length(matrix))).^2;
    
end

%% Calcul de la moyenne de la DSP

for j = 0 : Nfft-1
    DSP_vector(j+1) = mean(matrix(:,j+1));
end
y = DSP_vector;

f = -Fe/2:Fe/Nfft:(Fe/2)-(Fe/Nfft);
end

