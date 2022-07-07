function [U_m, X_m, Y_m, Xest_m, Erro_m, U_s, X_s, Y_s, Xest_s, Erro_s] = simuladorMestreEscravo2(modeloEspacoEstadoDiscreto, manipulador, X0, Xd, Lp_m, K_m, K_s, t)

%% Estruturas de Dados dos Modelos

Fi = modeloEspacoEstadoDiscreto.Fi;
Gama = modeloEspacoEstadoDiscreto.Gama;
H = modeloEspacoEstadoDiscreto.H;
V = modeloEspacoEstadoDiscreto.V;

%% Simulação em Tempo Discreto com Filtro de Kalman Linear

% Parâmetros Gerais:
k = 0;                      % Tempo inicial
n = size(Fi,1);             % Ordem do sistema

% Estado Inicial:
X_m = X0;      X_s = X0;                  % Estado inicial
Xd_m = X0;     Xd_s = X0;                 % Condições desejadas inicais
Xest_m = X0;   Xest_s = X0;               % Estimativa inicial perfeita

% Predição inicial
Xpred_s = X0;

% Matriz de covariância inicial
Ppred_s = 0*ones(n,n);

% Vetores de dados Mestre:
Uvector_m = [];               % Vetor de atuações tau1 e tau2
Xestvector_m = [];            % Vetor de estados estimados
Xvector_m = [];               % Vetor de estados reais
Yvector_m = [];               % Vetor de medições perfeitas

Errovector_m = [];            % Diferença entre o estado real e desejado

% Vetores de dados Escravo:
Uvector_s = [];               % Vetor de atuações tau1 e tau2
Xestvector_s = [];            % Vetor de estados estimados
Xvector_s = [];               % Vetor de estados reais
Yvector_s = [];               % Vetor de medições perfeitas

Errovector_s = [];            % Diferença entre o estado real e desejado
 
for t0 = t
    
   % Leitura dos sensores
   Y_m = H*X_m;
   Y_s = H*X_s;
   
   % Estados desejados
   Xd_m = Xd;  % Mestre conhece os estados desejados
   Xd_s = [Y_m(1); 0; Y_m(2); 0];  % Escravo conhece os sensores de posição do mestre
   
   % Ganho ótimo de Kalman Escravo
   Lc_s = Ppred_s*H'*inv(H*Ppred_s*H'+V); 
   
   % Estimativa corrigida do estado X do Escravo
   Xcorr_s = Xpred_s + Lc_s*(Y_s - H*Xpred_s); 
   
   % Estimativa corrigida de P do Escravo
   Pcorr_s = (eye(n)-Lc_s*H)*Ppred_s;
   
   % Cálculo do Uref
   Uref_m = pinv(Gama)*(eye(size(Fi))-Fi+Gama*K_m)*Xd_m;
   Uref_s = pinv(Gama)*(eye(size(Fi))-Fi+Gama*K_s)*Xd_s;
    
   % Lei de controle
   U_m = Uref_m - K_m*Xest_m;
   U_s = Uref_s - K_s*(Xcorr_s-Xd_s); 
   
   % Comportamento do sistema
   X_m = Fi*X_m + Gama*U_m;
   X_s = Fi*X_s + Gama*U_s;
    
   % Estimativa de X contemplando o oservador do Mestre
   Xest_m = Fi*Xest_m + Gama*U_m + Lp_m*(Y_m - H*Xest_m);
      
   % Predição do próximo estado X 
   Xpred_s = Fi*Xcorr_s + Gama*U_s; 
   
   % Predição do próximo P
   Ppred_s = Fi*Pcorr_s*Fi';
   
   % Atribuição dos vetores
   Xestvector_m = [Xestvector_m Xest_m];
   Xvector_m = [Xvector_m X_m];
   Yvector_m = [Yvector_m Y_m];
   
   Xestvector_s = [Xestvector_s Xcorr_s];
   Xvector_s = [Xvector_s X_s];
   Yvector_s = [Yvector_s Y_s];
   
   % Atribuição do vetor U
   Uvector_m = [Uvector_m U_m];
   Uvector_s = [Uvector_s U_s];
  
   % Cálculo do Erro - Não utilizado para controle
   erro_m = Xd_m - X_m;
   Errovector_m = [Errovector_m erro_m];
   
   erro_s = Xd_s - X_s; 
   Errovector_s = [Errovector_s erro_s];
   
   % Atualiza k
   k = k+1;
end

U_m = Uvector_m'; U_s = Uvector_s';
X_m = Xvector_m'; X_s = Xvector_s';
Y_m = Yvector_m'; Y_s = Yvector_s';
Xest_m = Xestvector_m'; Xest_s = Xestvector_s';
Erro_m = Errovector_m'; Erro_s = Errovector_s';