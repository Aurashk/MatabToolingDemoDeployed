classdef ModelData
    % MODELDATA Input data for demopackage.runModel
    %   data = demopackage.ModelData(x, y, z, element_indices, intensity)
    %   data = demopackage.ModelData(..., multiplier=2)
    %
    %   x, y, z and intensity hold one value per node. Each row of
    %   element_indices lists the nodes (indices into x, y, z) of one element.

    properties (SetAccess = immutable)
        x (:, 1) double
        y (:, 1) double
        z (:, 1) double
        element_indices (:, :) double
        intensity (:, 1) double
        multiplier (1, 1) double = 1
    end

    methods

        function obj = ModelData(x, y, z, element_indices, intensity, options)
            % MODELDATA Construct and validate the model input data
            arguments
                x (:, 1) double {mustBeReal}
                y (:, 1) double {mustBeReal}
                z (:, 1) double {mustBeReal}
                element_indices (:, :) double {mustBeInteger, mustBePositive}
                intensity (:, 1) double {mustBeReal}
                options.multiplier (1, 1) double {mustBeReal, mustBeFinite} = 1
            end

            num_nodes = numel(x);
            if any([numel(y), numel(z), numel(intensity)] ~= num_nodes)
                error('demopackage:ModelData:sizeMismatch', ...
                      'x, y, z and intensity must all have one value per node.');
            end
            if any(element_indices(:) > num_nodes)
                error('demopackage:ModelData:badElementIndex', ...
                      'element_indices refers to a node that does not exist.');
            end

            obj.x = x;
            obj.y = y;
            obj.z = z;
            obj.element_indices = element_indices;
            obj.intensity = intensity;
            obj.multiplier = options.multiplier;
        end

    end
end
