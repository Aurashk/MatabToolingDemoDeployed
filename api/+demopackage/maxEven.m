function max_even = maxEven(vals)
    % MAXEVEN Return the maximum even number in an array
    %   max_even = demopackage.maxEven(vals) filters out odd values and returns
    %   the maximum of those that remain.
    arguments (Input)
        vals
    end

    arguments (Output)
        max_even
    end

    % Resolves to the internal maxEven in +demopackage/private once packaged
    max_even = maxEven(vals);
end
