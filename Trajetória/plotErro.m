function plotErro(Erro1, Erro2, Erro3, Erro4, Erro5, estado, t)

figure;
hold on

plot(t,rad2deg(Erro1(:,estado)));
plot(t,rad2deg(Erro2(:,estado)));
plot(t,rad2deg(Erro3(:,estado)));
plot(t,rad2deg(Erro4(:,estado)));
plot(t,rad2deg(Erro5(:,estado)));

grid on; xlabel('Tempo [s]'); legend('Simulação 1', 'Simulação 2', 'Simulação 3', 'Simulação 4', 'Simulação 5','linewidth',2);
title(['Diferença entre os Estados do Mestre e Escravo']);
xlim([0 t(end)])
hold off

end