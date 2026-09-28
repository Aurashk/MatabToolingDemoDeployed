function output = runModel(data)
    % RUNMODEL Run the model on the given input data
    %   output = demopackage.runModel(data) takes a demopackage.ModelData and
    %   returns a demopackage.ModelOutput.
    arguments (Input)
        data (1, 1) demopackage.ModelData
    end

    arguments (Output)
        output (1, 1) demopackage.ModelOutput
    end

    output = processModel(data);
end
