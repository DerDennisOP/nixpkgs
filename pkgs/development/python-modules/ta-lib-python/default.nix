{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  numpy,
  pandas,
  polaris,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  ta-lib,
}:

buildPythonPackage rec {
  pname = "ta-lib";
  version = "0.5.2";
  pyproject = true;
  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "TA-Lib";
    repo = "ta-lib-python";
    rev = "refs/tags/TA_Lib-${version}";
    hash = "sha256-fPhaCOtKzkvwDGyFl/POhKOZCDt6ezOqp9N0WRqpPio=";
  };

  dependencies = [
    cython
    numpy
    ta-lib
  ];

  nativeCheckInputs = [
    pandas
    polaris
    pytestCheckHook
  ];

  pythonImportsCheck = [ "talib" ];

  meta = {
    description = "Python wrapper for TA-Lib";
    homepage = "https://github.com/TA-Lib/ta-lib-python";
    changelog = "https://github.com/TA-Lib/ta-lib-python/releases/tag/TA_Lib-${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}
