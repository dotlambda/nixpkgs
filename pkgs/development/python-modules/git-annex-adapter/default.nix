{ stdenv, buildPythonPackage, isPy3k, fetchPypi, pygit2 }:

buildPythonPackage rec {
  name = "git-annex-adapter-${version}";
  version = "0.2.0";
  format = "wheel";

  src = fetchPypi {
    inherit version format;
    pname = "git_annex_adapter";
    python = "py3";
    sha256 = "1hcmbl6qlwi2rlnwzchh655sh2qj9amnz2a0vzdh8bp79z275ybw";
  };

  propagatedBuildInputs = [ pygit2 ];

  doCheck = false;
}
