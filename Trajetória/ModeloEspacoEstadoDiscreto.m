function modeloEspacoEstadoDiscreto = ModeloEspacoEstadoDiscreto(manipulador, T)

%% Estruturas de Dados
elo1 = manipulador.dinamica.elo1;
elo2 = manipulador.dinamica.elo2;
elo3 = manipulador.dinamica.elo3;
elo4 = manipulador.dinamica.elo4;

encoder1 = manipulador.sensores.encoder1;
encoder2 = manipulador.sensores.encoder2;

perturbacoes = manipulador.perturbacoes;

%% Modelagem do Sistema em Tempo Contínuo
F = [0 1 0 0;
     0 0 0 0;
     0 0 0 1;
     0 0 0 0];

G2 = 1/(elo4.m*elo1.l^2 + elo1.m*elo1.lc^2 + elo3.m*elo3.lc^2 + elo1.I + elo3.I); 
G4 = 1/(elo3.m*elo2.l^2 + elo2.m*elo2.lc^2 + elo4.m*elo4.lc^2 + elo2.I + elo4.I);

G = [0 G2 0 0; 0 0 0 G4]';

% Posição dos Sensores
H = [1 0 0 0; 
     0 0 1 0]; 

J = [0 0; 0 0]';

%% Discretização ZOH
[~,Gama,H,J] = c2dm(F,G,H,J,T,'zoh');

Gw = Gama; 

[Fi,Gamaw,H,J] = c2dm(F,Gw,H,J,T,'zoh');

%% Controlabilidade e Observabilidade
co = ctrb (Fi,Gama);
ob = obsv (Fi,H);
controlabilidade = rank(co);
observabilidade = rank(ob);

%disp(['Posto da Matriz de Controlabilidade: ', num2str(controlabilidade)]) 
%disp(['Posto da Matriz de Observabilidade: ', num2str(observabilidade)]) 

%% Matrizes de Covariância
V = modelagemSensores(encoder1.vstd, encoder2.vstd, encoder1.q, encoder2.q);
W = modelagemPerturbacoes(perturbacoes.wstd1, perturbacoes.wstd2);

%% Retorno
modeloEspacoEstadoDiscreto = struct('Fi', Fi, 'Gama', Gama, 'Gamaw', Gamaw, 'H', H, 'J', J, 'V', V, 'W', W);

end
