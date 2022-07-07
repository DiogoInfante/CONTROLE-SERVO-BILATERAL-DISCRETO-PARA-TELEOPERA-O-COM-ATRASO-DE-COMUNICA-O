function displayDiferenca(Erro, simulacao)
disp(" ");
    disp(strcat("Diferença Final entre Mestre e Escravo na Simulação", num2str(simulacao), ":"));
    disp(['theta1 = ', num2str(round(rad2deg(Erro(end,1)),4)), ' graus']) 
    disp(['theta2 = ', num2str(round(rad2deg(Erro(end,3)),4)), ' graus'])
    disp(['theta1 = ', num2str(round(rad2deg(Erro(end,2)),4)), ' graus/s']) 
    disp(['theta2 = ', num2str(round(rad2deg(Erro(end,4)),4)), ' graus/s'])
disp(" "); 

end