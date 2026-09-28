function plan = buildfile
    % BUILDFILE Build plan for the demopackage toolbox
    %   buildtool                     check the code and run the unit tests
    %   buildtool package             build release/demopackage.mltbx (0.0.0)
    %   buildtool package("1.2.3")    build it with the given version
    import matlab.buildtool.tasks.CodeIssuesTask

    plan = buildplan(localfunctions);
    plan("check") = CodeIssuesTask(["api", "src"]);
    plan("testPackage").Dependencies = "stage";
    plan("package").Dependencies = ["check", "test", "testPackage"];
    plan.DefaultTasks = ["check", "test"];
end

function testTask(context)
    % TESTTASK Run the unit tests against the source folders
    tests_dir = fullfile(context.Plan.RootFolder, "tests");
    results = runtests(tests_dir, Tag = "Unit");
    assertSuccess(results);
end

function stageTask(context)
    % STAGETASK Assemble the toolbox folder in build/toolbox
    %   Public files in api/+demopackage go into the namespace and the
    %   internal files in src go into its private folder, so users can only
    %   reach what api exposes.
    root_dir = context.Plan.RootFolder;
    src_dir = fullfile(root_dir, "src");
    staging_dir = fullfile(root_dir, "build", "toolbox");
    namespace_dir = fullfile(staging_dir, "+demopackage");
    private_dir = fullfile(namespace_dir, "private");

    src_entries = dir(src_dir);
    src_subfolders = src_entries([src_entries.isdir] & ...
                                 ~ismember({src_entries.name}, {'.', '..'}));
    assert(isempty(src_subfolders), ...
           "src must be flat: MATLAB private folders cannot have subfolders.");

    if isfolder(staging_dir)
        rmdir(staging_dir, "s");
    end
    mkdir(private_dir);
    copyfile(fullfile(root_dir, "api", "+demopackage", "*"), namespace_dir);
    copyfile(fullfile(src_dir, "*.m"), private_dir);
end

function testPackageTask(context)
    % TESTPACKAGETASK Run the tests against the staged toolbox
    tests_dir = fullfile(context.Plan.RootFolder, "tests");
    results = runtests(tests_dir, Tag = "Package");
    assertSuccess(results);
end

function packageTask(context, version)
    % PACKAGETASK Package the staged toolbox into release/demopackage.mltbx
    arguments
        context
        version (1, 1) string = "0.0.0"
    end

    assert(~isempty(regexp(version, '^\d+\.\d+\.\d+$', 'once')), ...
           "Version must look like 1.2.3, got ""%s"".", version);

    root_dir = context.Plan.RootFolder;
    staging_dir = fullfile(root_dir, "build", "toolbox");

    % The identifier must never change, otherwise MATLAB treats each release
    % as a different toolbox rather than an upgrade.
    identifier = "3f6c2a9e-7b41-4d8e-9c15-a2e4b7d90f63";
    opts = matlab.addons.toolbox.ToolboxOptions(staging_dir, identifier);
    opts.ToolboxName = "demopackage";
    opts.ToolboxVersion = version;
    opts.Summary = "Demo toolbox for MATLAB software engineering tooling.";
    opts.MinimumMatlabRelease = "R2023a";
    opts.ToolboxMatlabPath = staging_dir;
    opts.OutputFile = fullfile(root_dir, "release", "demopackage.mltbx");

    if ~isfolder(fileparts(opts.OutputFile))
        mkdir(fileparts(opts.OutputFile));
    end
    matlab.addons.toolbox.packageToolbox(opts);
end
