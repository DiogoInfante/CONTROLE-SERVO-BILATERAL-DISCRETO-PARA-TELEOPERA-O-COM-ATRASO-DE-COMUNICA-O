classdef Elo
   properties
        l
        m
        lc
        I
   end
   methods
        function obj = Elo(l, m)
            obj.l = l;
            obj.m = m;
            obj.lc = l/2;
            obj.I = m*l^2/12;
        end
   end
end