function [bitPacket, error_flag] = CRC_decode(bit_packet)
    % variables
    polynomial = [1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 0 1 0 0 1]; % polynome generateur
    generator = crc.generator(polynomial); % generateur crc
    detector = crc.detector(polynomial); % detecteur crc
    
    [bitPacket, error_flag] = detector.detect(bit_packet); %detector(signal_recu_code') detect(detector, signal_recu_code')
    
    % [bitPacket, error_flag] = CRC_decode_(bit_packet)
    
end

