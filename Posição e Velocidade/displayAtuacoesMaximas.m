function displayAtuacoesMaximas(U, label)
tau1_max = max(abs(U(:,1)));
tau2_max = max(abs(U(:,2))); 
disp(" ")
    disp(strcat("Módulo das Atuações Máximas ", label))
    disp(['tau1 = ', num2str(tau1_max), ' Nm']) 
    disp(['tau2 = ', num2str(tau2_max), ' Nm']) 
disp(" ")
end
