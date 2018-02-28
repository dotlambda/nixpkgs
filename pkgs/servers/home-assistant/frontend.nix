{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "home-assistant-frontend";
  version = "20180227.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "49c59231b10ca44b7d7ec62e3c2ebbbbf969f88e898efc8219f111920234b334";
  };
}
