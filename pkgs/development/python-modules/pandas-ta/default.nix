{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pandas,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  pytz,
  setuptools,
  six,
  ta-lib-python,
  types-pkg-resources,
}:

buildPythonPackage rec {
  pname = "pandas-ta";
  version = "0.23.86";
  pyproject = true;
  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "twopirllc";
    repo = "pandas-ta";
    rev = "refs/tags/v${version}";
    hash = "sha256-JIwtAtP2TpnPG/KHHtuuLZxAiwllAG0J6paAy/AS80c=";
  };

  dependencies = [
    numpy
    pandas
    python-dateutil
    pytz
    six
    types-pkg-resources
  ];

  # nativeCheckInputs = [
  #   pytestCheckHook
  #   ta-lib-python
  # ];

  pythonImportsCheck = [ "pandas_ta" ];

  meta = {
    description = "Technical Analysis Indicators";
    homepage = "https://github.com/twopirllc/pandas-ta";
    changelog = "https://github.com/pennersr/django-allauth/blob/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}
