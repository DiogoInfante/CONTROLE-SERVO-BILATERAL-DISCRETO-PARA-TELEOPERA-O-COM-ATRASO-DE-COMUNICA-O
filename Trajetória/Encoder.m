classdef Encoder
   properties
        vstd
        q
   end
   methods
        function obj = Encoder(vstd, q)
            obj.vstd = vstd;
            obj.q = q;
        end
   end
end