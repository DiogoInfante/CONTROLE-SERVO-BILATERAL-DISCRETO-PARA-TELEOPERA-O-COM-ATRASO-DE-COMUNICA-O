function rmsd = rmsd(Erro)
    rmsd = sqrt(sum(abs(Erro.^2))/size(Erro,1));
end