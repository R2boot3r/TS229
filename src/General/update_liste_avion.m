
function [ listOfPlanes ] = update_liste_avion(listOfPlanes, liste_new_registre, DISPLAY_MASK, Rs, n, liste_corrVal)

CHAR_LINE =  '+--------------+------------+--------+-----+----------+-----+----------+-------------+------+--------------+--------------+-----+\n'; % Lignes

for i = 1:length(liste_new_registre)
    test = 0;
    % Affichage dans la console
    fprintf(DISPLAY_MASK, num2str(n),num2str(1),num2str(liste_corrVal(i)),num2str(liste_new_registre{i}.format)...
        ,num2str(liste_new_registre{i}.adresse),num2str(liste_new_registre{i}.type),num2str(liste_new_registre{i}.planeName)...
        ,num2str(liste_new_registre{i}.altitude),num2str(liste_new_registre{i}.cprf),num2str(liste_new_registre{i}.longitude)...
        ,num2str(liste_new_registre{i}.latitude),num2str(liste_new_registre{i}.crcErrFlag))
    
    n = n + 1;
    
    for j = 1:length(listOfPlanes)
        if strcmp(listOfPlanes(j).adresse, liste_new_registre{i}.adresse)
            updateWithRegister(listOfPlanes(j),liste_new_registre{i});
            test = 1;
        end
    end
    
    if test == 0
       listOfPlanes = [Avion(liste_new_registre{i}.planeName,liste_new_registre{i}.longitude,liste_new_registre{i}.latitude...
           ,liste_new_registre{i}.altitude,liste_new_registre{i}.adresse) listOfPlanes];
       setStyle(listOfPlanes(1), i);
    end
end

%fprintf(CHAR_LINE)


%[ listOfPlanes ] = update_liste_avion_(listOfPlanes, liste_new_registre, DISPLAY_MASK, Rs, n, liste_corrVal);
end
