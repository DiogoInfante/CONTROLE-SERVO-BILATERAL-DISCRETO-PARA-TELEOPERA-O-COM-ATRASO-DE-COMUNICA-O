function [U_m, X_m, Y_m, Xest_m, Erro_m, U_s, X_s, Y_s, Xest_s, Erro_s] = simuladorMestreEscravo5(modeloEspacoEstadoDiscreto_m, modeloEspacoEstadoDiscreto_s, manipulador_m, manipulador_s, trajetoria, Lp_m, K_m, K_s, t)

%% Estruturas de Dados dos Modelos

Fi_m = modeloEspacoEstadoDiscreto_m.Fi;
Gama_m = modeloEspacoEstadoDiscreto_m.Gama;
H_m = modeloEspacoEstadoDiscreto_m.H;
V_m = modeloEspacoEstadoDiscreto_m.V;
q1_m = manipulador_m.sensores.encoder1.q;
q2_m = manipulador_m.sensores.encoder2.q;

Fi_s = modeloEspacoEstadoDiscreto_s.Fi;
Gama_s = modeloEspacoEstadoDiscreto_s.Gama;
Gamaw_s = modeloEspacoEstadoDiscreto_s.Gamaw;
H_s = modeloEspacoEstadoDiscreto_s.H;
V_s = modeloEspacoEstadoDiscreto_s.V;
W_s = modeloEspacoEstadoDiscreto_s.W;
wstd1_s = manipulador_s.perturbacoes.wstd1;
wstd2_s = manipulador_s.perturbacoes.wstd2;
vstd1_s = manipulador_s.sensores.encoder1.vstd;
vstd2_s = manipulador_s.sensores.encoder2.vstd;
q1_s = manipulador_m.sensores.encoder1.q;
q2_s = manipulador_m.sensores.encoder2.q;

%% Trajetória de Referência do Mestre

xd = trajetoria.coordenadas_x;
xdp = trajetoria.coordenadas_xp;
yd = trajetoria.coordenadas_y;
ydp = trajetoria.coordenadas_yp;

%% Estado Inicial

X0 = cinematicaInversa(xd(1), xdp(1), yd(1), ydp(1), manipulador_m);

%% Simulação em Tempo Discreto com Filtro de Kalman Linear

% Parâmetros Gerais:
k = 0;                          % Tempo inicial
n_m = size(Fi_m,1);             % Ordem do sistema mestre
n_s = size(Fi_s,1);             % Ordem do sistema escravo

% Estado Inicial Mestre:
X_m = X0;                     % Estado inicial
Xd_m = X0;                    % Condições desejadas inicais
Xest_m = X0;                  % Estimativa inicial perfeita

% Expansão do Estado para Contemplar Atraso de 2T:
Xd_s = X0;
Xd_s = [Xd_s;[Xd_s(1)]];
Xd_s = [Xd_s;[Xd_s(3)]];
Xd_s = [Xd_s;[Xd_s(1)]];
Xd_s = [Xd_s;[Xd_s(3)]];
   
X0 = [X0;[X0(1)]];          % Coluna referente ao atraso 1 de teta1
X0 = [X0;[X0(3)]];          % Coluna referente ao atraso 1 de teta2
X0 = [X0;[X0(1)]];          % Coluna referente ao atraso 2 de teta1
X0 = [X0;[X0(3)]];          % Coluna referente ao atraso 2 de teta2

% Estado Inicial do Escravo:
X_s = X0;                     % Estado inicial
Xd_s = X0;                    % Condições desejadas inicais
Xest_s = X0;                  % Estimativa inicial perfeita

% Vetores de dados Mestre:
Uvector_m = [];               % Vetor de atuações tau1 e tau2
Xestvector_m = [];            % Vetor de estados estimados
Xvector_m = [];               % Vetor de estados reais
Yvector_m = [];               % Vetor de medições perfeitas

Xdvector_m = [];              % Vetor de estados desejados
Errovector_m = [];            % Diferença entre o estado real e desejado

% Predição inicial
Xpred_s = X0;

% Matriz de covariância inicial
Ppred_s = 0*ones(n_s,n_s);

% Vetores de dados Escravo:
Uvector_s = [];               % Vetor de atuações tau1 e tau2
Xestvector_s = [];            % Vetor de estados estimados
Xvector_s = [];               % Vetor de estados reais
Yvector_s = [];               % Vetor de medições perfeitas

Xdvector_s = [];              % Vetor de estados desejados
Errovector_s = [];            % Diferença entre o estado real e desejado
 
for t0 = t
    
   % Leitura dos sensores
   Y_m = H_m*X_m;
   Y_s = H_s*X_s;
   
   Ysensor_m(1,1) = q1_m*floor(Y_m(1,1)/q1_m);
   Ysensor_m(2,1) = q2_m*floor(Y_m(2,1)/q2_m);
   Ysensor_s(1,1) = q1_s*floor(Y_s(1,1)/q1_s);
   Ysensor_s(2,1) = q2_s*floor(Y_s(2,1)/q2_s);
   
   Y_m = Ysensor_m;
   Y_s = Ysensor_s;
   
   % Estados desejados
   Xd_m = cinematicaInversa(xd(k+1), xdp(k+1), yd(k+1), ydp(k+1), manipulador_m);  % Mestre conhece os estados desejados
   Xd_s = [Y_m(1); 0; Y_m(2); 0; 0; 0; 0; 0];  % Escravo conhece os sensores de posição do mestre
   
   % Ganho ótimo de Kalman Escravo
   Lc_s = Ppred_s*H_s'*inv(H_s*Ppred_s*H_s'+V_s); 
   
   % Estimativa corrigida do estado X do Escravo
   Xcorr_s = Xpred_s + Lc_s*(Y_s - H_s*Xpred_s); 
   
   % Estimativa corrigida de P do Escravo
   Pcorr_s = (eye(n_s)-Lc_s*H_s)*Ppred_s;
   
   % Cálculo do Uref
   Uref_m = pinv(Gama_m)*(eye(size(Fi_m))-Fi_m+Gama_m*K_m)*Xd_m;
   Uref_s = pinv(Gama_s)*(eye(size(Fi_s))-Fi_s+Gama_s*K_s)*Xd_s;
    
   % Lei de controle
   U_m = Uref_m - K_m*Xest_m;
   U_s = Uref_s - K_s*(Xcorr_s); 
   
   % Comportamento do sistema
   X_m = Fi_m*X_m + Gama_m*U_m;
   X_s = Fi_s*X_s + Gama_s*U_s + Gamaw_s*[wstd1_s; wstd2_s]*randn(1); 
    
   % Estimativa de X contemplando o oservador do Mestre
   Xest_m = Fi_m*Xest_m + Gama_m*U_m + Lp_m*(Y_m - H_m*Xest_m);
      
   % Predição do próximo estado X 
   Xpred_s = Fi_s*Xcorr_s + Gama_s*U_s; 
   
   % Predição do próximo P
   Ppred_s = Fi_s*Pcorr_s*Fi_s' + Gamaw_s*W_s*Gamaw_s';
   
   % Atribuição dos vetores
   Xestvector_m = [Xestvector_m Xest_m];
   Xvector_m = [Xvector_m X_m];
   Yvector_m = [Yvector_m Y_m];
   
   Xestvector_s = [Xestvector_s Xest_s];
   Xvector_s = [Xvector_s X_s];
   Yvector_s = [Yvector_s Y_s];
   
   % Atribuição do vetor U
   Uvector_m = [Uvector_m U_m];
   Uvector_s = [Uvector_s U_s];
  
   % Cálculo do Erro - Não utilizado para controle
   erro_m = Xd_m - X_m;
   Errovector_m = [Errovector_m erro_m];
   
   erro_s = Xd_s - X_s; % Com relação ao estado desejado para o mestre   
   Errovector_s = [Errovector_s erro_s];
   
   % Atualiza k
   k = k+1;
end

U_m = Uvector_m'; U_s = Uvector_s';
X_m = Xvector_m'; X_s = Xvector_s';
Y_m = Yvector_m'; Y_s = Yvector_s';
Xest_m = Xestvector_m'; Xest_s = Xestvector_s';
Erro_m = Errovector_m'; Erro_s = Errovector_s';