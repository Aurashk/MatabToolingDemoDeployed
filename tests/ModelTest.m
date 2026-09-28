classdef ModelTest < matlab.unittest.TestCase
    % MODELTEST Unit tests for the demopackage model API

    methods (TestClassSetup)

        function addSourceToPath(test_case)
            % ADDSOURCETOPATH Make the public API and internal code available
            here = fileparts(mfilename('fullpath'));
            src_dir = fullfile(here, '..', 'src');
            api_dir = fullfile(here, '..', 'api');
            test_case.applyFixture(matlab.unittest.fixtures.PathFixture(src_dir));
            test_case.applyFixture(matlab.unittest.fixtures.PathFixture(api_dir));
        end

    end

    methods (Test, TestTags = {'Unit'})

        function testRunModelScalesIntensity(test_case)
            % TESTRUNMODELSCALESINTENSITY Check intensity is multiplied
            data = demopackage.ModelData([0; 1; 0], [0; 0; 1], [0; 0; 0], ...
                                         [1, 2, 3], [1; 2; 3], multiplier = 2);
            output = demopackage.runModel(data);

            test_case.verifyClass(output, 'demopackage.ModelOutput');
            test_case.verifyEqual(output.intensity, [2; 4; 6]);
        end

        function testDefaultMultiplier(test_case)
            % TESTDEFAULTMULTIPLIER Check the multiplier defaults to 1
            data = demopackage.ModelData(0, 0, 0, 1, 5);
            output = demopackage.runModel(data);

            test_case.verifyEqual(output.intensity, 5);
        end

        function testRowVectorsBecomeColumns(test_case)
            % TESTROWVECTORSBECOMECOLUMNS Check inputs are stored as columns
            data = demopackage.ModelData([0, 1], [0, 1], [0, 1], [1, 2], [3, 4]);

            test_case.verifyEqual(data.x, [0; 1]);
            test_case.verifyEqual(data.intensity, [3; 4]);
        end

        function testSizeMismatch(test_case)
            % TESTSIZEMISMATCH Check node arrays must have matching lengths
            test_case.verifyError( ...
                @() demopackage.ModelData([0; 1], [0; 1], 0, [1, 2], [1; 2]), ...
                'demopackage:ModelData:sizeMismatch');
        end

        function testBadElementIndex(test_case)
            % TESTBADELEMENTINDEX Check elements can only refer to existing nodes
            test_case.verifyError( ...
                @() demopackage.ModelData([0; 1], [0; 1], [0; 1], [1, 3], [1; 2]), ...
                'demopackage:ModelData:badElementIndex');
        end

        function testRunModelRejectsOtherTypes(test_case)
            % TESTRUNMODELREJECTSOTHERTYPES Check runModel needs a ModelData
            test_case.verifyError(@() demopackage.runModel(struct()), ?MException);
        end

    end
end
