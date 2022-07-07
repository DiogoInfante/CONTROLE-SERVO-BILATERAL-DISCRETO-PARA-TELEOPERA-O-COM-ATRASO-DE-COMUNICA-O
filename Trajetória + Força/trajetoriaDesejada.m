function [trajetoria] = trajetoriaDesejada(formato,l1,l2,t)

xc = 0.6*l1; % offset x
yc = 0.6*l1; % offset y
r = 0.5*l2;  % raio
f = 0.2;     % frequencia

disp('');

    switch formato
    case 'retaVertical'
        disp('Trajetória de Referência: Segmento de Reta Vertical');
        xd= repmat(xc,size(t,2),1);
        yd = yc + f*t;
        xdp = repmat(0,size(t,2),1);
        ydp = repmat(f,size(t,2),1);
    case 'circulo'
        disp('Trajetória de Referência: Círculo');
        xd = xc + r*cos(2*pi*f*t);
        yd = yc + r*sin(2*pi*f*t);
        xdp = -r*sin(2*pi*f*t)*(2*pi*f);
        ydp = r*cos(2*pi*f*t)*(2*pi*f);
    otherwise
        disp('Trajetória de Referência: Não encontrada');
        disp('Utilizando círculo como padrão');
        xd = xc + r*cos(2*pi*f*t);
        yd = yc + r*sin(2*pi*f*t);
        xdp = -r*sin(2*pi*f*t)*(2*pi*f);
        ydp = r*cos(2*pi*f*t)*(2*pi*f);
    end
   
trajetoria = Trajetoria(xd,xdp,yd,ydp);

disp('');

end