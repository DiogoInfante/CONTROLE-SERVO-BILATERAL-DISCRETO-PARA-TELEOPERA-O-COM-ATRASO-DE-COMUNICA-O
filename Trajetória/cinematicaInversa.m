function [Xdcorr] = cinematicaInversa(xd, xdp, yd, ydp, manipulador) 
%% Elos
l1 = manipulador.dinamica.elo1.l;
l2 = manipulador.dinamica.elo2.l;
l3 = manipulador.dinamica.elo3.l;
l4 = manipulador.dinamica.elo4.l;

%% Cinemática Inversa para Cálculo das Posições Desejadas Das Juntas

%teta1d = -2*atan((((- l1^2 + 2*l1*l2 - 2*l1*l4 - l2^2 + 2*l2*l4 - l4^2 + xd^2 + yd^2)*(l1^2 + 2*l1*l2 - 2*l1*l4 + l2^2 - 2*l2*l4 + l4^2 - xd^2 - yd^2))^(1/2) - 2*l2*yd + 2*l4*yd)/(l1^2 + 2*l1*xd - l2^2 + 2*l2*l4 - l4^2 + xd^2 + yd^2) - (2*(l1*yd - l2*yd + l4*yd))/(l1^2 + 2*l1*xd - l2^2 + 2*l2*l4 - l4^2 + xd^2 + yd^2));
teta1d =  2*atan((((- l1^2 + 2*l1*l2 - 2*l1*l4 - l2^2 + 2*l2*l4 - l4^2 + xd^2 + yd^2)*(l1^2 + 2*l1*l2 - 2*l1*l4 + l2^2 - 2*l2*l4 + l4^2 - xd^2 - yd^2))^(1/2) + 2*l2*yd - 2*l4*yd)/(l1^2 + 2*l1*xd - l2^2 + 2*l2*l4 - l4^2 + xd^2 + yd^2) + (2*(l1*yd - l2*yd + l4*yd))/(l1^2 + 2*l1*xd - l2^2 + 2*l2*l4 - l4^2 + xd^2 + yd^2));

%teta2d =  2*atan((((- l1^2 + 2*l1*l2 - 2*l1*l4 - l2^2 + 2*l2*l4 - l4^2 + xd^2 + yd^2)*(l1^2 + 2*l1*l2 - 2*l1*l4 + l2^2 - 2*l2*l4 + l4^2 - xd^2 - yd^2))^(1/2) - 2*l2*yd + 2*l4*yd)/(- l1^2 + l2^2 - 2*l2*l4 - 2*l2*xd + l4^2 + 2*l4*xd + xd^2 + yd^2));
teta2d = -2*atan((((- l1^2 + 2*l1*l2 - 2*l1*l4 - l2^2 + 2*l2*l4 - l4^2 + xd^2 + yd^2)*(l1^2 + 2*l1*l2 - 2*l1*l4 + l2^2 - 2*l2*l4 + l4^2 - xd^2 - yd^2))^(1/2) + 2*l2*yd - 2*l4*yd)/(- l1^2 + l2^2 - 2*l2*l4 - 2*l2*xd + l4^2 + 2*l4*xd + xd^2 + yd^2));

%% Jacobiano Para Cálculo das Velocidades Desejadas das Juntas
Jd = [[-l1*sin(teta1d),  sin(teta2d)*(l2 - l4)];[ l1*cos(teta1d), -cos(teta2d)*(l2 - l4)]];
tetadp = inv(Jd)*[xdp ydp]';
teta1dp = tetadp(1); teta2dp = tetadp(2); %velocidades desejadas das juntas

Xdcorr = [teta1d; teta1dp; teta2d; teta2dp];
end