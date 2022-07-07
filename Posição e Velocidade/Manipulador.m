classdef Manipulador
   properties
        dinamica
        atuacoes
        sensores
        perturbacoes
   end
   methods
        function obj = Manipulador(dinamica, atuacoes, sensores, perturbacoes)
            obj.dinamica = dinamica;
            obj.atuacoes = atuacoes;
            obj.sensores = sensores;
            obj.perturbacoes = perturbacoes;
        end
   end
end