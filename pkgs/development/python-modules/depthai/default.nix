{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "depthai";
  version = "2.24.0.0";
  format = "wheel";

  # Too complicated to build by source due to Hunter dependency.
  src = fetchPypi {
    inherit pname version format;
    python = "cp311";
    dist = "cp311";
    abi = "cp311";
    platform = "manylinux_2_17_x86_64.manylinux2014_x86_64";
    hash = "sha256-9E59bDSnTY1jJCj92MD5xDySW40OqkuO2qxseSGFs+8=";
  };

  meta = with lib; {
    description = "Universal payment handling for Django.";
    homepage = "https://github.com/luxonis/depthai-python/";
    changelog = "https://github.com/luxonis/depthai-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ derdennisop ];
  };
}
