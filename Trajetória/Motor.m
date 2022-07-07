classdef Motor
   properties
        tauMin
        tauMax
   end
   methods
        function obj = Motor(tauMin, tauMax)
            obj.tauMin = tauMin;
            obj.tauMax = tauMax;
        end
   end
end