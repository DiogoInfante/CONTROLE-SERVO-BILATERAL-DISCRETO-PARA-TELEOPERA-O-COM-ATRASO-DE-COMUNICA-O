function displayRMSD(Erro, simulacao)
disp(" "); 
    teta1_rmsd = rmsd(rad2deg(Erro(:,1)));
    teta2_rmsd = rmsd(rad2deg(Erro(:,3)));
    teta1p_rmsd = rmsd(rad2deg(Erro(:,2)));
    teta2p_rmsd = rmsd(rad2deg(Erro(:,4)));
    disp(strcat("RMSD entre Mestre e Escravo na Simulação ", num2str(simulacao), ":"));
    disp(['theta1 RMSD = ',  num2str(teta1_rmsd), ' graus'])
    disp(['theta2 RMSD = ',  num2str(teta2_rmsd), ' graus']) 
    disp(['theta1p RMSD = ', num2str(teta1p_rmsd), ' graus/s']) 
    disp(['theta2p RMSD = ', num2str(teta2p_rmsd), ' graus/s'])
disp(" "); 
end