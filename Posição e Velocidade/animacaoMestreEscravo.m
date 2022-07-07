function animacaoMestreEscravo(Y_mestre, Y_escravo, manipulador, x_offset, y_offset, delay, skip)  

%% Estruturas de Dados
l1 = manipulador.dinamica.elo1.l;
l2 = manipulador.dinamica.elo2.l;
l3 = manipulador.dinamica.elo3.l;
l4 = manipulador.dinamica.elo4.l;

%% Input para confirmar animação
prompt = "Deseja visualizar a animação? (y/n)\n";
x = input(prompt, "s");
if x ~= "y" 
    return
end

%% Propriedades da Janela
fh = figure(10);
set(fh, 'doublebuffer', 'on'); % for smoothness in the animation
fh.WindowState = 'maximized';
drawnow;

%% Coordenadas:
x1_mestre = l1*cos(Y_mestre(:,1));
y1_mestre = l1*sin(Y_mestre(:,1));

x2_mestre = -l2*cos(Y_mestre(:,2));
y2_mestre = -l2*sin(Y_mestre(:,2));

x3_mestre = l3*cos(Y_mestre(:,1));
y3_mestre = l3*sin(Y_mestre(:,1));

xe_mestre = l1*cos(Y_mestre(:,1)) + (l4-l2)*cos(Y_mestre(:,2));
ye_mestre = l1*sin(Y_mestre(:,1)) + (l4-l2)*sin(Y_mestre(:,2));

%% Coordenadas:
x1_escravo = l1*cos(Y_escravo(:,1)) + x_offset;
y1_escravo = l1*sin(Y_escravo(:,1)) + y_offset;

x2_escravo = -l2*cos(Y_escravo(:,2)) + x_offset;
y2_escravo = -l2*sin(Y_escravo(:,2)) + y_offset;

x3_escravo = l3*cos(Y_escravo(:,1)) + x_offset;
y3_escravo = l3*sin(Y_escravo(:,1)) + y_offset;

xe_escravo = l1*cos(Y_escravo(:,1)) + (l4-l2)*cos(Y_escravo(:,2)) + x_offset;
ye_escravo = l1*sin(Y_escravo(:,1)) + (l4-l2)*sin(Y_escravo(:,2)) + y_offset;

%% Eixos
plot(0,0,'bo')
hold on
bound = max([l1; l2; l3;l4]);
axis([-bound/2,2*bound,-bound/2,2*bound])
axis equal

%% Loop de Animação
 for k = 1:skip:size(Y_escravo,1) %Skip ajusta a velocidade ao pular frames

   %% Desenho
   
   % Mestre
   plot([0 x1_mestre(k)],[0 y1_mestre(k)],'b','Linewidth',3); % desenha o elo 1
   plot([0 x2_mestre(k)],[0 y2_mestre(k)],'r','Linewidth',3); % desenha o elo 2
   plot([x2_mestre(k) x2_mestre(k)+x3_mestre(k)],[y2_mestre(k) y2_mestre(k)+y3_mestre(k)],'b','Linewidth',3); % desenha o elo 3
   plot([x2_mestre(k)+x3_mestre(k) xe_mestre(k)],[y2_mestre(k)+y3_mestre(k) ye_mestre(k)],'r','Linewidth',3); % desenha o elo 4

   % Escravo
   plot([0+x_offset x1_escravo(k)],[0+y_offset y1_escravo(k)],'g','Linewidth',3); % desenha o elo 1
   plot([0+x_offset x2_escravo(k)],[0+y_offset y2_escravo(k)],'k','Linewidth',3); % desenha o elo 2
   plot([x2_escravo(k) x2_escravo(k)+x3_escravo(k)-x_offset],[y2_escravo(k) y2_escravo(k)+y3_escravo(k)-y_offset],'g','Linewidth',3); % desenha o elo 3
   plot([x2_escravo(k)+x3_escravo(k)-x_offset xe_escravo(k)],[y2_escravo(k)+y3_escravo(k)-y_offset ye_escravo(k)],'k','Linewidth',3); % desenha o elo 4

   drawnow;   

   %% Apaga
   
   % Mestre
   plot([0 x1_mestre(k)],[0 y1_mestre(k)],'w','Linewidth',3); % apaga o elo 1
   plot([0 x2_mestre(k)],[0 y2_mestre(k)],'w','Linewidth',3); % apaga o elo 2
   plot([x2_mestre(k) x2_mestre(k)+x3_mestre(k)],[y2_mestre(k) y2_mestre(k)+y3_mestre(k)],'w','Linewidth',3); % apaga o elo 3
   plot([x2_mestre(k)+x3_mestre(k) xe_mestre(k)],[y2_mestre(k)+y3_mestre(k) ye_mestre(k)],'w','Linewidth',3); % apaga o elo 4
  
   % Escravo
   plot([0+x_offset x1_escravo(k)],[0+y_offset y1_escravo(k)],'w','Linewidth',3); % apaga o elo 1
   plot([0+x_offset x2_escravo(k)],[0+y_offset y2_escravo(k)],'w','Linewidth',3); % apaga o elo 2
   plot([x2_escravo(k) x2_escravo(k)+x3_escravo(k)-x_offset],[y2_escravo(k) y2_escravo(k)+y3_escravo(k)-y_offset],'w','Linewidth',3); % apaga o elo 3
   plot([x2_escravo(k)+x3_escravo(k)-x_offset xe_escravo(k)],[y2_escravo(k)+y3_escravo(k)-y_offset ye_escravo(k)],'w','Linewidth',3); % apaga o elo 4

   plot(xe_mestre(k),ye_mestre(k),'r.');   % desenha o rastro da extremidade
      
   plot(xe_escravo(k),ye_escravo(k),'r.'); % desenha o rastro da extremidade
      
   pause(delay) % T segundos por frame
 end 
end
