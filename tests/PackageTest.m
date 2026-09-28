classdef PackageTest < matlab.unittest.TestCase
    % PACKAGETEST Tests for the staged toolbox in build/toolbox
    %   Run "buildtool testPackage" to stage the toolbox and run these tests.

    methods (TestClassSetup)

        function addToolboxToPath(test_case)
            % ADDTOOLBOXTOPATH Put only the staged toolbox on the path
            here = fileparts(mfilename('fullpath'));
            toolbox_dir = fullfile(here, '..', 'build', 'toolbox');
            test_case.assumeTrue(isfolder(toolbox_dir), ...
                                 'Run "buildtool stage" first.');
            test_case.applyFixture( ...
                matlab.unittest.fixtures.PathFixture(toolbox_dir));
        end

    end

    methods (Test, TestTags = {'Package'})

        function testMaxEven(test_case)
            % TESTMAXEVEN Check the public maxEven reaches the internal one
            test_case.verifyEqual(demopackage.maxEven([1, 2, 3, 4, 5]), 4);
        end

        function testRunModel(test_case)
            % TESTRUNMODEL Check the public runModel reaches processModel
            data = demopackage.ModelData(0, 0, 0, 1, 5, multiplier = 3);
            output = demopackage.runModel(data);

            test_case.verifyEqual(output.intensity, 15);
        end

        function testInternalsAreHidden(test_case)
            % TESTINTERNALSAREHIDDEN Check src functions are not on the path
            test_case.verifyEqual(exist('maxEven', 'file'), 0);
            test_case.verifyEqual(exist('processModel', 'file'), 0);
        end

    end
end
