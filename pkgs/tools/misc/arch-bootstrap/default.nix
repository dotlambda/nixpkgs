{ stdenv, fetchFromGitHub, makeWrapper, coreutils, wget, gnused, gawk, gnutar, gzip, xz, curl, libidn }:

stdenv.mkDerivation rec {
  name = "arch-bootstrap-${version}";
  version = "2017-09-13";

  src = fetchFromGitHub {
    owner = "tokland";
    repo = "arch-bootstrap";
    rev = "7605a69132a9700fa0d44b20aa7ff21485414e15";
    sha256 = "015sh2wqvh4qh7h4l2hkmkf7z3cm91y9lww1g62ry2wq8zcijy7y";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    install -Dm 755 arch-bootstrap.sh $out/bin/arch-bootstrap
    wrapProgram $out/bin/arch-bootstrap \
      --prefix PATH : ${stdenv.lib.makeBinPath [ coreutils wget gnused gawk gnutar gzip xz curl ]} \
      --prefix LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ libidn ]}
  '';

  meta = with stdenv.lib; {
    description = "Bootstrap a base Arch Linux system from any GNU distro";
    homepage = https://github.com/tokland/arch-bootstrap;
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
    platforms = with platforms; linux;
  };
}
