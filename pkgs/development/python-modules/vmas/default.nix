{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gym,
  gymnasium,
  matplotlib,
  moviepy,
  numpy,
  opencv4,
  pyglet,
  pytestCheckHook,
  pyyaml,
  setuptools,
  shimmy,
  six,
  torch,
  tqdm,
}:

buildPythonPackage rec {
  pname = "vmas";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "proroklab";
    repo = "VectorizedMultiAgentSimulator";
    tag = version;
    hash = "sha256-YnAG4LcfnAM0DnldxBuYS3IA4UbWTnyEndZhEy8sWP8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    gym
    numpy
    pyglet
    six
    torch
  ];

  optional-dependencies = {
    gymnasium = [
      gymnasium
      shimmy
    ];

    render = [
      matplotlib
      moviepy
      opencv4
    ];
  };

  pythonRelaxDeps = [ "pyglet" ];

  disabledTests = [
    # pyglet.display.xlib.NoSuchDisplayException: Cannot connect to "None"
    "test_use_vmas_env"
    # Missing python3Packages.cvxpylayers
    "test_heuristic"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
    tqdm
  ]
  ++ optional-dependencies.gymnasium;

  pythonImportsCheck = [ "vmas" ];

  meta = {
    description = "A vectorized differentiable simulator designed for efficient Multi-Agent Reinforcement Learning benchmarking";
    homepage = "https://github.com/proroklab/VectorizedMultiAgentSimulator";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}
