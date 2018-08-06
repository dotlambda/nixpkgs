{ lib, buildPythonPackage, fetchFromGitHub, m2r }:

buildPythonPackage rec {
  pname = "setuptools-markdown";
  version = "unstable-2018-07-31";

  src = fetchFromGitHub {
    owner = "msabramo";
    repo = pname;
    rev = "d6e56b53094896e96a9cec8e9bbb3a7d58db392b";
    sha256 = "05jls4anq68qvfh69ss8xjdp9f3wzrvnm53v6hsz54dx1ymmqmm8";
  };

  propagatedBuildInputs = [ m2r ];

  # There are no tests
  doCheck = false;

  meta = with lib; {
    description = "Use Markdown for your project description";
    homepage = https://github.com/msabramo/setuptools-markdown;
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
