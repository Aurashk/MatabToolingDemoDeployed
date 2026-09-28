function runTests()
    % RUNTESTS Run all tests
    %   Runs the tests
    import matlab.unittest.plugins.CodeCoveragePlugin
    import matlab.unittest.plugins.codecoverage.CoverageReport
    import matlab.unittest.plugins.codecoverage.CoberturaFormat

    root_dir = fileparts(mfilename('fullpath'));
    src_dir = fullfile(root_dir, '../src');
    api_dir = fullfile(root_dir, '../api');
    tests_dir = fullfile(root_dir, '../tests');
    report_dir = fullfile(root_dir, '../htmlcov');
    coverage_file = fullfile(root_dir, '../coverage.xml');

    suite = testsuite(tests_dir, IncludingSubfolders = true);
    runner = testrunner('textoutput');

    coverage_plugin = CodeCoveragePlugin.forFolder( ...
        {src_dir, api_dir}, ...
        'IncludingSubfolders', true, ...
        'Producing', [CoverageReport(report_dir), CoberturaFormat(coverage_file)]);
    runner.addPlugin(coverage_plugin);

    results = runner.run(suite);
end
