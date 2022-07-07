function plotEstado(X_m, X_s, f_ext, estado, t)
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
plot(t,rad2deg(X_s(:,estado)));

grid on; xlabel('Tempo [s]'); legend('Mestre','Escravo','linewidth',2);
title(strcat(label_estado, label_unidade, ' com força externa: fx = ', num2str(f_ext(1)), ', fy = ', num2str(f_ext(2)), ' [N]'));
xlim([0 t(end)])

end