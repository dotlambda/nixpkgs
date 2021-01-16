{ stdenv, buildPythonPackage, fetchPypi, pytestCheckHook }:

buildPythonPackage rec {
  pname = "colorlog";
  version = "4.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18d05b616438a75762d7d214b9ec3b05d274466c9f3ddd92807e755840c88251";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck =  [ "colorlog" ];

  meta = with stdenv.lib; {
    description = "Log formatting with colors";
    homepage = "https://github.com/borntyping/python-colorlog";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
