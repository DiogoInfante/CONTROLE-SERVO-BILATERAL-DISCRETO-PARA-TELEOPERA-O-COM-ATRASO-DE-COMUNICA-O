function plotTrajeto(Y_m, Y_s1, Y_s2, Y_s3, Y_s4, Y_s5, manipulador, t)

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

e_m = extremidade(Y_m, manipulador);
e_s1 = extremidade(Y_s1, manipulador);
e_s2 = extremidade(Y_s2, manipulador);
e_s3 = extremidade(Y_s3, manipulador);
e_s4 = extremidade(Y_s4, manipulador);
e_s5 = extremidade(Y_s5, manipulador);

plot(e_m(:,1), e_m(:,2))
plot(e_s1(:,1), e_s1(:,2))
plot(e_s2(:,1), e_s2(:,2))
plot(e_s3(:,1), e_s3(:,2))
plot(e_s4(:,1), e_s4(:,2))
plot(e_s5(:,1), e_s5(:,2))

grid on; legend('Mestre','Simulação 1', 'Simulação 2', 'Simulação 3', 'Simulação 4', 'Simulação 5','linewidth', 2);
title('Trajetórias Percorridas');

end