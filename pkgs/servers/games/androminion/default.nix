{ stdenv, fetchFromGitHub, jdk, ant, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "vdom-${version}";
  version = "v8.05-prealpha5";

  src = fetchFromGitHub {
    owner = "mehtank";
    repo = "androminion";
    rev = version;
    sha256 = "09lim3qdshqk2d9a6j49fms2avpm88d2953rx6v6zf4igwfwzg5h";
  };
  sourceRoot = "source/vdom";

  buildInputs = [ jdk ant makeWrapper ];

  buildPhase = "ant";

  installPhase = ''
    install -Dt $out/share/java vdom.jar
    mkdir $out/bin
    makeWrapper ${jre}/bin/java $out/bin/vdom \
      --add-flags "-cp $out/share/java/vdom.jar com.vdom.core.Game"
  '';
}
