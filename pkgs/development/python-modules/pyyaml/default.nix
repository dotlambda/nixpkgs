{ lib, buildPythonPackage, fetchPypi, libyaml }:

buildPythonPackage rec {
  pname = "PyYAML";
  version = "4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a9b322285f419429402d5ce15e8f6d5c7a64f659eb87251af8b35c106f00a8e3";
  };

  propagatedBuildInputs = [ libyaml ];

  meta = with lib; {
    description = "The next generation YAML parser and emitter for Python";
    homepage = https://github.com/yaml/pyyaml;
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
