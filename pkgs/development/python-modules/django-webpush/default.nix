{ lib
, buildPythonPackage
, django
, fetchFromGitHub
, pytest-django
, python
, pythonOlder
, pywebpush
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "django-webpush";
  version = "0.3.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "safwanrahman";
    repo = "django-webpush";
    rev = "refs/tags/${version}";
    hash = "sha256-Mwp53apdPpBcn7VfDbyDlvLAVAG65UUBhT0w9OKjKbU=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pywebpush==1.9.4" "pywebpush"
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    django
    pywebpush
  ];

  # nothing to test
  doCheck = false;

  pythonImportsCheck = [
    "webpush"
  ];

  meta = with lib; {
    description = "Django-Webpush is a Package made for integrating and sending Web Push Notification in Django Application.";
    homepage = "https://github.com/safwanrahman/django-webpush/";
    changelog = "https://github.com/safwanrahman/django-webpush/releases/tag/${version}";
    license = licenses.gpl3;
    maintainers = with maintainers; [ derdennisop ];
  };
}
