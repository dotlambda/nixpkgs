{ lib, buildPythonPackage, pythonOlder, fetchPypi, setuptools-markdown }:

buildPythonPackage rec {
  pname = "eth-hash";
  version = "0.1.4";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "42e6604e879b998002c915c1061ab317927329d7f47d3cbb80b83132dc7b58a4";
  };

  nativeBuildInputs = [ setuptools-markdown ];

  # No tests in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "The Ethereum hashing function, keccak256, sometimes (erroneously) called sha3";
    homepage = https://github.com/ethereum/eth-hash;
    license = licenses.mit;
  };
}
