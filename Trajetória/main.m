%% Controle Discreto de um Sistema Mestre-Escravo Composto por 2 Manipuladores 2-DOF Paralelogramo
%
% Autor: Diogo de Freitas Infante Vieira
% Matrícula: 1711093
% 
% Simulação de um sistema mestre-escravo de manipuladores 2 DOF na geometria de paralelogramo
% Ambos os robôs foram modelados com a mesma dinâmica e geometria
%
% Parâmetros do manipulador projetados para desacoplamento: Modelo Linear
% Caso as entradas de dados violem esta condição, o programa é interrompido
%
%% Métodos de Controle das Simulações e Condições do Contorno
%
% Trajetória: Circular
%
% Manipulador Mestre: 
%
%   - Simulações 1 a 5: LQR + Condições Ideais
%
% Manipulador Escravo: 
% 
%   - Simulação 1: LQR
%   - Simulação 2: Kalman
%   - Simulação 3: Kalman + Atraso de 2T na Comunicação
%   - Simulação 4: Kalman + Atraso de 2T e Ruído na Comunicação
%   - Simulação 5: Kalman + Atraso de 2T e Ruído na Comunicação +
%   Quantização do Sensores e Perturbações externas no escravo
%
%% Estruturas de Dados
%
% Modelagem de dados seguindo orientação a objetos
% Trecho documentando as estruturas utilizadas
%
% % Dinâmica
% Elo: class('l', 'm', 'lc', 'I');
% Dinamica: class('elo1', 'elo2', 'elo3', 'elo4');
% 
% % Sensores
% Encoder: class('vstd','q'); 
% Sensores: class('encoder1', 'encoder2');
% 
% % Atuadores
% Motor: class('tau_min', 'tau_max');
% Atuacoes: class('motor1', 'motor2');
% 
% % Perturbações
% Perturbacoes: class('wstd1', 'wstd2');
% 
% % Manipulador
% Manipulador: class('dinamica', 'motores', 'sensores', 'perturbacoes');
%
% % Trajetoria
% Trajetoria: struct('coordenadas_x', 'coordenadas_xp','coordenadas_y', 'coordenadas_yp')
%
% % Espaco de Estado Discreto
% ModeloEspacoEstadoDiscreto: struct('Fi','Gama','Gamaw', 'H','J', 'V', 'W');
%
%% Métodos de Apoio Desenvolvidos:
%
%    - modelagemSensores: Retorna a matriz de covariâncias referentes aos
%      sensores
%
%    - modelagemPerturbacoes: Retorna a matriz de covariâncias referente as
%      perturbacões
%
%    - cinematicaInversa: Retorna posiçoes e velocidades angulares nas 
%      juntas confrome posições e velocidades lineares fornecidas 
%
%    - extremidade: Retornada as coordenadas da extremidade do robô
%
%    - estimadorPreditivo: Retorna os polos do observador
%
%    - rmsd: Retorna o desvio calculado através de mínimos quadrados
%
%    - animacaoMestreEscravo: Animação do manipulador para trajetória
%
%% Setup
close all
clear all
clc

%% Parâmetros de Simulação

T = 0.01;                     % Período de controle [s]
tf = 5;                       % Tempo final de simulação

t = [0:T:tf];                 % Janela de simulação

x_offset = 4;                 % Distância horizontal entre o mestre e escravo na animação
y_offset = 0;                 % Distância vertical entre o mestre e escravo na animação

%% Parâmetros da Trajetória

formato = 'circulo';          % Formatos disponívies: 'circulo', 'retaVertical

tf_traj = 5;                  % Tempo para simular o círculo completo
T_traj = (tf_traj*T)/tf;      % Período da trajetória calculado conforme o período de controle
t_traj = [0:T_traj:tf_traj];  % Janela de construção da trajetória

%% Parâmetros Construtivos

% Comprimento dos Elos [m]
l1 = 3; 
l2 = 1; 
l3 = 3; 
l4 = 3; 

% Massas dos Elos [Kg]
m1 = 1; 
m2 = 1; 
m3 = 3; 
m4 = 1;

%% Parâmetros dos Sensores

% Ideias
vstd1 = 0.0;    % Desvio padrão dos erros de medição do encoder da junta 1
vstd2 = 0.0;    % Desvio padrão dos erros de medição do encoder da junta 2

% Ruídos
vstd1_ruido = 1.0; 
vstd2_ruido = 1.0; 

% Quantização
q1 = 1;         % Encoder ideal
q2 = 1;         % Encoder ideal

q1_qnt = 2*pi/1024;  % Encoder com 1024 pulsos / volta
q2_qnt = 2*pi/1024;  % Encoder com 1024 pulsos / volta

%% Parâmetros de Atuação

% Atuações [Nm]
tau1_min = -10^10; % Nm
tau1_max =  10^10; % Nm
tau2_min = -10^10; % Nm
tau2_max =  10^10; % Nm

%% Parâmetros de Perturbações
wstd1 = 0.0;  % Desvio padrão das pertubações sobre a junta 1
wstd2 = 0.0;  % Desvio padrão das pertubações sobre a junta 2

wstd1_pert = 1.0;  % Desvio padrão das pertubações sobre a junta 1
wstd2_pert = 1.0;  % Desvio padrão das pertubações sobre a junta 2

%% Dinâmica

elo1 = Elo(l1,m1);
elo2 = Elo(l2,m2);
elo3 = Elo(l3,m3);
elo4 = Elo(l4,m4);

dinamica = Dinamica(elo1, elo2, elo3, elo4);

%% Sensores

encoder1 = Encoder(vstd1, q1);
encoder2 = Encoder(vstd2, q2);

sensores = Sensores(encoder1, encoder2);

encoder1_qnt = Encoder(vstd1, q1_qnt);
encoder2_qnt = Encoder(vstd2, q2_qnt);

sensores_qnt = Sensores(encoder1_qnt, encoder2_qnt);

encoder1_ruido = Encoder(vstd1_ruido, q1);
encoder2_ruido = Encoder(vstd2_ruido, q2);

sensores_ruido = Sensores(encoder1_ruido, encoder2_ruido);

encoder1_ruido_qnt = Encoder(vstd1_ruido, q1_qnt);
encoder2_ruido_qnt = Encoder(vstd2_ruido, q2_qnt);

sensores_ruido_qnt = Sensores(encoder1_ruido_qnt, encoder2_ruido_qnt);

%% Atuações

motor1 = Motor(tau1_min, tau1_max);
motor2 = Motor(tau2_min, tau2_max);

atuacoes = Atuacoes(motor1, motor2);

%% Perturbações

perturbacoes = Perturbacoes(wstd1, wstd2);

perturbacoes_pert = Perturbacoes(wstd1_pert, wstd2_pert);

%% Manipuladores

manipulador = Manipulador(dinamica, atuacoes, sensores, perturbacoes);

manipulador_qnt = Manipulador(dinamica, atuacoes, sensores_qnt, perturbacoes);

manipulador_ruido = Manipulador(dinamica, atuacoes, sensores_ruido, perturbacoes);

manipulador_ruido_qnt_pert = Manipulador(dinamica, atuacoes, sensores_ruido_qnt, perturbacoes_pert);

%% Modelagem em Espaço de Estados Discreta

modeloEspacoEstadoDiscreto = ModeloEspacoEstadoDiscreto(manipulador, T);

modeloEspacoEstadoDiscretoQnt = ModeloEspacoEstadoDiscreto(manipulador_qnt, T);

modeloEspacoEstadoDiscretoExpandido = ModeloEspacoEstadoDiscretoAtraso2T(manipulador, T);

modeloEspacoEstadoDiscretoExpandidoRuido = ModeloEspacoEstadoDiscretoAtraso2T(manipulador_ruido, T);

modeloEspacoEstadoDiscretoExpandidoRuidoQntPert = ModeloEspacoEstadoDiscretoAtraso2T(manipulador_ruido, T);

%% Trajetória Desejada para o Mestre:
trajetoria = trajetoriaDesejada(formato,3,1,t_traj);

%% LQR Mestre

% Matriz de pesos Q1
Q1_m = [     50000000      0       0         0;
                 0       50000     0         0;
                 0         0    50000000     0;
                 0         0       0       50000];
  
% Matriz de pesos Q2
Q2_m = [10^1 0; 0 10^1]; 

% Cálculo do ganho
K_m = dlqr(modeloEspacoEstadoDiscreto.Fi, modeloEspacoEstadoDiscreto.Gama, Q1_m, Q2_m);

% Posicionamento dos polos do controlador
polos_controlador_m = eig(modeloEspacoEstadoDiscreto.Fi-modeloEspacoEstadoDiscreto.Gama*K_m);

%% LQR Escravo

% Matriz de pesos Q1
Q1_s = [     50000000      0       0         0;
                 0       50000     0         0;
                 0         0    50000000     0;
                 0         0       0       50000];
  
% Matriz de pesos Q2
Q2_s = [10^1 0; 0 10^1]; 


% Cálculo do ganho
K_s = dlqr(modeloEspacoEstadoDiscreto.Fi, modeloEspacoEstadoDiscreto.Gama, Q1_s, Q2_s);

% Posicionamento dos polos do controlador
polos_controlador_s = eig(modeloEspacoEstadoDiscreto.Fi-modeloEspacoEstadoDiscreto.Gama*K_s);

%% LQR Escravo Estado Expandido

coef = 50000000;
coefb = 50000;
coefc = 1;
% Matriz de pesos Q1
Q1_s_expandido = [  coefc        0       0         0       0         0       0      0;
          0         coefb      0         0       0         0       0      0;
          0         0       coefc        0       0         0       0      0;
          0         0       0         coefb      0         0       0      0;
          0         0       0         0       coefc        0       0      0;
          0         0       0         0       0         coefc      0      0;
          0         0       0         0       0         0       coef     0;
          0         0       0         0       0         0       0     coef];
  
% Matriz de pesos Q2
Q2_s_expandido = [10^1 0; 0 10^1]; 

% Cálculo do ganho
K_s_expandido = dlqr(modeloEspacoEstadoDiscretoExpandido.Fi, modeloEspacoEstadoDiscretoExpandido.Gama, Q1_s_expandido, Q2_s_expandido);

% Posicionamento dos polos do controlador
polos_controlador_s_expandido = eig(modeloEspacoEstadoDiscretoExpandido.Fi-modeloEspacoEstadoDiscretoExpandido.Gama*K_s_expandido);

%% Estimador Preditivo / Observador Mestre

n_m = 3; % Número de vezes que o observador é mais rápido que o controlador

polos_observador_m = estimadorPreditivo(polos_controlador_m, n_m)

% Método de posicionamento de pólos
Lp_m = place(modeloEspacoEstadoDiscreto.Fi',modeloEspacoEstadoDiscreto.H', polos_observador_m)';

%% Estimador Preditivo / Observador Escravo

n_s = 3; % Número de vezes que o observador é mais rápido que o controlador

polos_observador_s = estimadorPreditivo(polos_controlador_s, n_s)

% Método de posicionamento de pólos
Lp_s = place(modeloEspacoEstadoDiscreto.Fi',modeloEspacoEstadoDiscreto.H', polos_observador_s)';

%% Simulação 1 em Tempo Discreto com LQR
[U_m1, X_m1, Y_m1, Xest_m1, Erro_m1, U_s1, X_s1, Y_s1, Xest_s1, Erro_s1] = simuladorMestreEscravo1(modeloEspacoEstadoDiscreto, manipulador, trajetoria, Lp_m, Lp_s, K_m, K_s, t);
Erro1 = X_m1 - X_s1;

%% Simulação 2 em Tempo Discreto com Mestre LQR e Escravo Kalman
[U_m2, X_m2, Y_m2, Xest_m2, Erro_m2, U_s2, X_s2, Y_s2, Xest_s2, Erro_s2] = simuladorMestreEscravo2(modeloEspacoEstadoDiscreto, manipulador, trajetoria, Lp_m, K_m, K_s, t);
Erro2 = X_m2 - X_s2;

%% Simulação 3 em Tempo Discreto com Mestre LQR e Escravo Kalman com Atraso de 2T na Comuniação
[U_m3, X_m3, Y_m3, Xest_m3, Erro_m3, U_s3, X_s3, Y_s3, Xest_s3, Erro_s3] = simuladorMestreEscravo3(modeloEspacoEstadoDiscreto, modeloEspacoEstadoDiscretoExpandido, manipulador, trajetoria, Lp_m, K_m, K_s_expandido, t);
Erro3 = X_m3 - X_s3(:,1:4);

%% Simulação 4 em Tempo Discreto com Mestre LQR e Escravo Kalman com Atraso de 2T e Ruído na Comuniação
[U_m4, X_m4, Y_m4, Xest_m4, Erro_m4, U_s4, X_s4, Y_s4, Xest_s4, Erro_s4] = simuladorMestreEscravo4(modeloEspacoEstadoDiscreto, modeloEspacoEstadoDiscretoExpandido, manipulador_ruido, trajetoria, Lp_m, K_m, K_s_expandido, t);
Erro4 = X_m4 - X_s4(:,1:4);

%% Simulação 5 em Tempo Discreto com Mestre LQR e Escravo Kalman com Atraso de 2T e Ruído na Comuniação, Efeitos de Quantização e Perturbações Externas no Escravo
[U_m5, X_m5, Y_m5, Xest_m5, Erro_m5, U_s5, X_s5, Y_s5, Xest_s5, Erro_s5] = simuladorMestreEscravo5(modeloEspacoEstadoDiscretoQnt, modeloEspacoEstadoDiscretoExpandidoRuidoQntPert, manipulador_qnt, manipulador_ruido_qnt_pert, trajetoria, Lp_m, K_m, K_s_expandido, t);
Erro5 = X_m5 - X_s5(:,1:4);

%% Display & Plots

% Evolução dos Estados ao Longo do Tempo do Nestre e Escravos:
plotEstado(X_m1, X_s1, X_s2, X_s3, X_s4, X_s5, 1, t)
plotEstado(X_m1, X_s1, X_s2, X_s3, X_s4, X_s5, 2, t)
plotEstado(X_m1, X_s1, X_s2, X_s3, X_s4, X_s5, 3, t)
plotEstado(X_m1, X_s1, X_s2, X_s3, X_s4, X_s5, 4, t)
% 
% Evolução das Atuações ao Lngo do Rempo do Mestre e Escravo:
plotAtuacao(U_m1, U_s1, U_s2, U_s3, U_s4, U_s5, 1, t)
plotAtuacao(U_m1, U_s1, U_s2, U_s3, U_s4, U_s5, 2, t)
%
% Evolução da Diferença entre os Estados Desejados do Mestre e dos Escravos
plotErro(Erro1, Erro2, Erro3, Erro4, Erro5, 1, t)
plotErro(Erro1, Erro2, Erro3, Erro4, Erro5, 2, t)
plotErro(Erro1, Erro2, Erro3, Erro4, Erro5, 3, t)
plotErro(Erro1, Erro2, Erro3, Erro4, Erro5, 4, t)
%
% Trajetória Percorrida pelos Manipuladores
plotTrajeto(Y_m1, Y_s1, Y_s2, Y_s3, Y_s4, Y_s5, manipulador, t)
%
% Display dos Estados Finais
displayEstadosFinais(X_m1, 'Mestre')
displayEstadosFinais(X_s1, 'Simulação 1')
displayEstadosFinais(X_s2, 'Simulação 2')
displayEstadosFinais(X_s3, 'Simulação 3')
displayEstadosFinais(X_s4, 'Simulação 4')
displayEstadosFinais(X_s5, 'Simulação 5')
%
% Display Módulo das Atuações Máximas
displayAtuacoesMaximas(U_m1, 'Mestre')
displayAtuacoesMaximas(U_s1, 'Simulação 1')
displayAtuacoesMaximas(U_s2, 'Simulação 2')
displayAtuacoesMaximas(U_s3, 'Simulação 3')
displayAtuacoesMaximas(U_s4, 'Simulação 4')
displayAtuacoesMaximas(U_s5, 'Simulação 5')
%
% Display Diferença Entre os Estados Finais do Mestre e Escravo
displayDiferenca(Erro1, 1)
displayDiferenca(Erro2, 2)
displayDiferenca(Erro3, 3)
displayDiferenca(Erro4, 4)
displayDiferenca(Erro5, 5)
%
% Display do RMSD do Mestre e Escravo
displayRMSD(Erro1, 1)
displayRMSD(Erro2, 2)
displayRMSD(Erro3, 3)
displayRMSD(Erro4, 4)
displayRMSD(Erro5, 5)
%
%% Animação
animacaoMestreEscravo(Y_m1, Y_s1, manipulador, x_offset, y_offset, 0, 5)  