function plotEstado(X_m, X_1, X_2, X_3, X_4, X_5, estado, t)
    label_estado = '';
    label_unidade = '';
if estado == 1
    label_estado = 'Ângulos da Junta 1';
    label_unidade = ' [graus]';
elseif estado == 2
    label_estado = 'Velocidades da Junta 1';
    label_unidade = ' [graus/s]';
elseif estado == 3
    label_estado = 'Ângulos da Junta 2';
    label_unidade = ' [graus]';
elseif estado == 4
    label_estado = 'Velocidades da Junta 2';
    label_unidade = ' [graus/s]';
else 
    return
end

figure;
hold on
plot(t,rad2deg(X_m(:,estado)));
plot(t,rad2deg(X_1(:,estado)));
plot(t,rad2deg(X_2(:,estado)));
plot(t,rad2deg(X_3(:,estado)));
plot(t,rad2deg(X_4(:,estado)));
plot(t,rad2deg(X_5(:,estado)));

grid on; xlabel('Tempo [s]'); legend('Mestre','Simulação 1', 'Simulação 2', 'Simulação 3', 'Simulação 4', 'Simulação 5','linewidth',2);
title(strcat(label_estado, label_unidade));
xlim([0 t(end)])

end