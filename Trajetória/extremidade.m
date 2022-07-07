function coordenadas = extremidade(Y, manipulador)

    %% Estruturas de Dados
    l1 = manipulador.dinamica.elo1.l;
    l2 = manipulador.dinamica.elo2.l;
    l3 = manipulador.dinamica.elo3.l;
    l4 = manipulador.dinamica.elo4.l;

    xe=  l1*cos(Y(:,1)) + (l4-l2)*cos(Y(:,2));
    ye = l1*sin(Y(:,1)) + (l4-l2)*sin(Y(:,2));
    
    coordenadas = [xe, ye];
end