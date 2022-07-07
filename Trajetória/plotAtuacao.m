function plotAtuacao(U_m, U_s1, U_s2, U_s3, U_s4, U_s5, junta, t)

figure;
hold on

plot(t,U_m(:,junta));
plot(t,U_s1(:,junta));
plot(t,U_s2(:,junta));
plot(t,U_s3(:,junta));
plot(t,U_s4(:,junta));
plot(t,U_s5(:,junta));

grid on; xlabel('Tempo [s]'); legend('Mestre','Simulação 1', 'Simulação 2', 'Simulação 3', 'Simulação 4', 'Simulação 5','linewidth',2);
title(strcat('Atuações na Junta ', num2str(junta), ' [Nm]'));
xlim([0 t(end)])
hold off

end