function encoded = CRC_encode(bits)
    % variables
    polynomial = [1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 0 1 0 0 1]; % polynome generateur
    generator = crc.generator(polynomial); % generateur crc
    detector = crc.detector(polynomial); % detecteur crc
    
    encoded = generate(generator,bits); % resultat en  colonne
    
end

