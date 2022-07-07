classdef Sensores
   properties
        encoder1
        encoder2
   end
   methods
        function obj = Sensores(encoder1, encoder2)
            obj.encoder1 = encoder1;
            obj.encoder2 = encoder2;
        end
   end
end