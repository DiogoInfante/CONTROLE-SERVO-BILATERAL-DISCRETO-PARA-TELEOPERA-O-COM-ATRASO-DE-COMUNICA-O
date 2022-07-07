function displayVelocidadesMaximas(X_m, X_s, n, t)

%% Velocidades Máximas
teta1p_max_m  = max(abs(X_m(:,2)));
teta2p_max_m  = max(abs(X_m(:,4)));
teta1p_max_s  = max(abs(X_s(:,2)));
teta2p_max_s  = max(abs(X_s(:,4)));

disp(' ')
disp("Simulação", num2str(n), "Módulo dos Máximos Valores de Velocidades das Juntas 1 e 2:")
disp(['theta1p max mestre' num2str(n) ' = ',  num2str(rad2deg(teta1p_max_m)), ' graus/s']) 
disp(['theta2p max mestre' num2str(n) ' = ',  num2str(rad2deg(teta2p_max_m)), ' graus/s']) 
disp(['theta1p max escravo' num2str(n) ' = ',  num2str(rad2deg(teta1p_max_s)), ' grau/s']) 
disp(['theta2p max escravo' num2str(n) ' = ',  num2str(rad2deg(teta2p_max_s)), ' graus/s'])
disp(' ')

end