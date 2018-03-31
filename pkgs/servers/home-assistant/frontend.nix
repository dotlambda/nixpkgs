{ stdenv, fetchPypi, buildPythonPackage, user-agents }:

buildPythonPackage rec {
  pname = "home-assistant-frontend";
  version = "20180330.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bf841325c51cb72b84ab2632281c9f73d0a63d33d845f200eb7c50dede0b6be3";
  };

  propagatedBuildInputs = [ user-agents ];
}
