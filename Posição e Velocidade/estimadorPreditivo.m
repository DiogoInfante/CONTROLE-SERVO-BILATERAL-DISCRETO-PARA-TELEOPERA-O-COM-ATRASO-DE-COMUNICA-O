function polos_observador = estimadorPreditivo(polos_controlador, n)

    % Pólo de referência corresponde ao mais rápido do controlador
    polo_ref = inf;

    for i=1:size(polos_controlador)
        if polos_controlador(i) < polo_ref
            polo_ref = polos_controlador(i);
        end
    end

    % Cálculo dos pólos desejados para o observador
    polo_ref = abs(polo_ref);

    n_c = 1/(1-polo_ref);
    n_cp = n_c/n;

    z_obs = (1 - 1/n_cp);

    polos_observador = [z_obs z_obs z_obs-0.1 z_obs-0.1];
end