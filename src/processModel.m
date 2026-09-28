function output = processModel(data)
    % PROCESSMODEL Scale the model intensity by the multiplier
    %   Internal: users should call demopackage.runModel.
    arguments (Input)
        data (1, 1) demopackage.ModelData
    end

    arguments (Output)
        output (1, 1) demopackage.ModelOutput
    end

    output = demopackage.ModelOutput(data.intensity * data.multiplier);
end
