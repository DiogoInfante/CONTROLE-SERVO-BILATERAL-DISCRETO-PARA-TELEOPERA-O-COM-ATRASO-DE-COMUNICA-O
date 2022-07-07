function V = modelagemSensores(vstd1, vstd2, q1, q2)
    % Matriz de covariância do ruído dos sensores
    V = [[vstd1^2+q1^2/12          0     ]
         [    0               vstd2^2+q2^2/12]];
end