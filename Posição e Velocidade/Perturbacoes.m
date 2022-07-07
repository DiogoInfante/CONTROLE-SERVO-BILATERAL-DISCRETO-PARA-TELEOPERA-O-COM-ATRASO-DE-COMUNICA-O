classdef Perturbacoes
   properties
        wstd1
        wstd2
   end
   methods
        function obj = Perturbacoes(wstd1, wstd2)
            obj.wstd1 = wstd1;
            obj.wstd2 = wstd2;
        end
   end
end