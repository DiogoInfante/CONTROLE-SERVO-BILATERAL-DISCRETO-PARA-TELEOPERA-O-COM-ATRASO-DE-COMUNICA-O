function W = modelagemPerturbacoes(wstd1, wstd2)
    % Matriz de covariância das perturbações
    W = [[wstd1^2         0     ]
         [      0        wstd2^2]]; 
end