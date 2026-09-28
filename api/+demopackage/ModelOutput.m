classdef ModelOutput
    % MODELOUTPUT Result returned by demopackage.runModel

    properties (SetAccess = immutable)
        intensity (:, 1) double
    end

    methods

        function obj = ModelOutput(intensity)
            % MODELOUTPUT Construct the model output
            arguments
                intensity (:, 1) double
            end

            obj.intensity = intensity;
        end

    end
end
