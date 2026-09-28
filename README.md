# MatlabToolingDemo

A repository to demonstrate software engineering tools for MATLAB/Octave.

## The Tools

- Formatter: [mh_style][mh_style]
- Linter: [mh_lint][mh_lint]
- Pre-commit hooks: [pre-commit][pre-commit]
- Test framework: [matlab.unittest][matlab-unittest]
- Code coverage analyser: [matlab.unittest.plugins.CodeCoveragePlugin][coverage-plugin]

## Using the toolbox

Download `demopackage.mltbx` from the [latest release][releases] and
double-click it, or run:

```matlab
matlab.addons.install("demopackage.mltbx")
```

Everything the toolbox provides is in the `demopackage` namespace:

```matlab
demopackage.maxEven([1, 2, 3, 4, 5])   % returns 4

data = demopackage.ModelData(x, y, z, element_indices, intensity, ...
                             multiplier = 2);
output = demopackage.runModel(data);
output.intensity
```

## Code layout

- `api/+demopackage/` holds the public API: the functions and classes users
  can call as `demopackage.<name>`.
- `src/` holds the internal code. It is not changed for packaging.

`buildtool stage` copies `api/+demopackage/` into `build/toolbox/+demopackage/`
and `src/*.m` into `build/toolbox/+demopackage/private/`. MATLAB only lets
functions in `+demopackage/` call anything in `private/`, so users can reach
only what `api/` exposes.

To expose another function from `src/`, add a wrapper with the same name to
`api/+demopackage/` that calls it (see `api/+demopackage/maxEven.m`).

Rules this layout relies on:

- `src/` must stay flat, because private folders cannot have subfolders.
- `src/` must not contain classes, because private folders cannot hold
  classes. Write public classes in `api/+demopackage/` and refer to them as
  `demopackage.ClassName` everywhere, including inside the class itself.

## Development setup

1. Clone the repository

   ```sh
   git clone https://github.com/dc2917/MatabToolingDemo.git
   ```

1. Install the python tools

   ```sh
   python -m venv .venv
   .venv/bin/activate
   pip install -r dev-requirements.txt
   ```

1. Install the pre-commit hooks

   ```sh
   pre-commit install
   ```

## Usage

Formatting

```sh
mh_style .
```

Linting/static analysis

```sh
mh_lint .
```

Pre-commit hooks

```sh
pre-commit run --all-files
```

Testing

```sh
matlab -batch "run tests/runTests.m"
```

Building (MATLAB R2024a or later)

```sh
matlab -batch "buildtool"                    # code checks and unit tests
matlab -batch "buildtool package"            # release/demopackage.mltbx
matlab -batch "buildtool package('1.2.3')"   # with a version number
```

`buildtool package` also stages the toolbox and runs `tests/PackageTest.m`
against it, which checks that internal functions are hidden.

## Releasing

The version comes from the git tag. Tag a commit on `main` and push the tag:

```sh
git tag v1.2.3
git push origin v1.2.3
```

The release workflow runs the CI checks, builds `demopackage.mltbx` with
version 1.2.3 and attaches it to a new GitHub release. It fails if the tagged
commit is not on `main`.

The toolbox identifier in `buildfile.m` must never change, otherwise MATLAB
treats each release as a different toolbox instead of an upgrade.

### File Exchange

One-time setup: on [File Exchange][file-exchange], publish a new submission,
choose to link it to this GitHub repository, and select GitHub Releases as the
source. File Exchange then picks up each new release, and users can install the
toolbox from the Add-On Explorer in MATLAB.

[releases]: https://github.com/Aurashk/MatabToolingDemoDeployed/releases/latest
[file-exchange]: https://www.mathworks.com/matlabcentral/fileexchange/
[mh_style]: https://florianschanda.github.io/miss_hit/style_checker.html
[mh_lint]: https://florianschanda.github.io/miss_hit/lint.html
[pre-commit]: https://pre-commit.com/
[matlab-unittest]: https://uk.mathworks.com/help/matlab/matlab-unit-test-framework.html
[coverage-plugin]: https://uk.mathworks.com/help/matlab/ref/matlab.unittest.plugins.codecoverageplugin-class.html
