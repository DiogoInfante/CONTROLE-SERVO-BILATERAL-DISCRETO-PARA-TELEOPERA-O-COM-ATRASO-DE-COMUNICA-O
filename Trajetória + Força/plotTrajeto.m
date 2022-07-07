function plotTrajeto(Xd_m, Y_m, Y_s, f_ext, manipulador, t)

%% Estruturas de Dados
l1 = manipulador.dinamica.elo1.l;
l2 = manipulador.dinamica.elo2.l;
l3 = manipulador.dinamica.elo3.l;
l4 = manipulador.dinamica.elo4.l;

%% Eixos

figure;
hold on
bound = max([l1; l2; l3;l4]);
axis([-bound/2,2*bound,-bound/2,2*bound])
axis equal

e_d = extremidade([Xd_m(:,1) Xd_m(:,3)], manipulador);
e_m = extremidade(Y_m, manipulador);
e_s = extremidade(Y_s, manipulador);

plot(e_d(:,1), e_d(:,2))
plot(e_m(:,1), e_m(:,2))
plot(e_s(:,1), e_s(:,2))

grid on; legend('Referência', 'Mestre','Escravo','linewidth', 2);
title(strcat('Trajetórias Percorridas com força externa: fx = ', num2str(f_ext(1)), ', fy = ', num2str(f_ext(2)), ' [N]'));

end