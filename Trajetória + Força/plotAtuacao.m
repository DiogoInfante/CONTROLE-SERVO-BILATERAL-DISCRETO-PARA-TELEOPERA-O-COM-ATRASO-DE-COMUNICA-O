function plotAtuacao(U_m, U_s, f_ext, junta, t)

figure;
hold on

plot(t,U_m(:,junta));
plot(t,U_s(:,junta));

grid on; xlabel('Tempo [s]'); legend('Mestre','Escravo','linewidth',2);
title(strcat('Atuações na Junta ', num2str(junta), ' [Nm] e com força externa: fx = ', num2str(f_ext(1)), ', fy = ', num2str(f_ext(2)), ' [N]'));
xlim([0 t(end)])
hold off

end