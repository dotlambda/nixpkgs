{ stdenv, buildPythonPackage, fetchPypi, dlib }:

buildPythonPackage rec {
  pname = "face_recognition";
  version = "1.0.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname, version;
    sha256 = "a159abc723eb3860303bc26cd981f4c6ef9a58e5807d7793d8e3141a8cb11e78";
  };

  buildInputs = [ dlib ]
}
