function displayEstadosFinais(X, label)
disp(" ")
    disp(strcat("Estados Finais ", label, ":"));
    disp(['theta1 = ',  num2str(round(rad2deg(X(end,1)),4)), ' graus']) 
    disp(['theta2 = ',  num2str(round(rad2deg(X(end,3)),4)), ' graus'])
    disp(['theta1p = ', num2str(round(rad2deg(X(end,2)),4)), ' graus/s']) 
    disp(['theta2p = ', num2str(round(rad2deg(X(end,4)),4)), ' graus/s'])
disp(" ")
end