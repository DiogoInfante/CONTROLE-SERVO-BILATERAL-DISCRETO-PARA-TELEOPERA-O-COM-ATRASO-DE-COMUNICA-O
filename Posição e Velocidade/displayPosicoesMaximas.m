function displayPosicoesMaximas(X_m, X_s, n, t)

%% Posições Máximas
teta1_max_m  = max(abs(X_m(:,1)));
teta2_max_m  = max(abs(X_m(:,3)));
teta1_max_s  = max(abs(X_s(:,1)));
teta2_max_s  = max(abs(X_s(:,3)));

disp(' ')
disp("Simulação", num2str(n), "Módulo dos Máximos Valores dos Ângulos das Juntas 1 e 2:")
disp(['theta1 max mestre' num2str(n) ' = ',  num2str(rad2deg(teta1_max_m)), ' graus']) 
disp(['theta2 max mestre' num2str(n) ' = ',  num2str(rad2deg(teta2_max_m)), ' graus']) 
disp(['theta1 max escravo' num2str(n) ' = ',  num2str(rad2deg(teta1_max_s)), ' graus']) 
disp(['theta2 max escravo' num2str(n) ' = ',  num2str(rad2deg(teta2_max_s)), ' graus'])
disp(' ')

end