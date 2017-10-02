{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "fiche-${version}";
  version = "2017-09-19";

  src = fetchFromGitHub {
    owner = "solusipse";
    repo = "fiche";
    rev = "e2daffecd3bda2e68e2b0231e1783d8b77e9b11e";
    sha256 = "082wgy6nxzklga6cxjarj6h7a0y02cg9kwy9qiqdw565gcmw9i9i";
  };

  installPhase = ''
    mkdir $out
    install -m 0755 fiche $out
  '';

  installFlags = [ "prefix=$(out)" ];
}
