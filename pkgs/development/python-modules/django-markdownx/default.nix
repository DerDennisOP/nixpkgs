{ lib
, buildPythonPackage
, django
, fetchFromGitHub
, markdown
, pillow
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "django-markdownx";
  version = "4.0.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "neutronX";
    repo = "django-markdownx";
    rev = "refs/tags/v${version}";
    hash = "sha256-FZPUlogVd3FMGeH1vfKHA3tXVps0ET+UCQJflpiV2lE=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "install_requires=get_requirements()," ""
  '';

  propagatedBuildInputs = [
    django
    markdown
    pillow
  ];

  # tests only executeable in vagrant
  doCheck = false;

  pythonImportsCheck = [
    "markdownx"
  ];

  meta = with lib; {
    description = "Comprehensive Markdown plugin built for Django";
    homepage = "https://github.com/neutronX/markdownx/";
    changelog = "https://github.com/neutronX/markdownx/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ derdennisop ];
  };
}
