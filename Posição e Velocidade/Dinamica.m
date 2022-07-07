classdef Dinamica
   properties
        elo1
        elo2
        elo3
        elo4
   end
   methods
        function obj = Dinamica(elo1, elo2, elo3, elo4)
            obj.elo1 = elo1;
            obj.elo2 = elo2;
            obj.elo3 = elo3;
            obj.elo4 = elo4;
            if elo3.m*elo2.l*elo3.lc-elo4.m*elo1.l*elo4.lc ~= 0
                 msg = 'Os parâmetros não satisfazem a condição de desacomplamento';
                 error(msg)
            end
        end
   end
end