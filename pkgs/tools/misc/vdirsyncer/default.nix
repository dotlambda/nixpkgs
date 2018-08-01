{ stdenv, python3Packages, glibcLocales, rustPlatform, pkgconfig, openssl }:

# Packaging documentation at:
# https://github.com/untitaker/vdirsyncer/blob/master/docs/packaging.rst
let
  pythonPackages = python3Packages;
  version = "0.17.0a3";
  pname = "vdirsyncer";
  name = pname + "-" + version;
  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "beb95baafa66de12975e6420282f2f8a31d7316a0f88fbc902b0a65e94fbf1d8";
  };
  native = rustPlatform.buildRustPackage {
    name = name + "-native";
    inherit src;
    sourceRoot = name + "/rust";
    cargoSha256 = "08xq9q5fx37azzkqqgwcnds1yd8687gh26dsl3ivql5h13fa2w3q";
    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ openssl ];
    postInstall = ''
      mkdir $out/include $out/lib
      cp $out/bin/libvdirsyncer_rustext* $out/lib
      rm -r $out/bin
      cp target/vdirsyncer_rustext.h $out/include
    '';
  };
in pythonPackages.buildPythonApplication rec {
  inherit version pname src;

  propagatedBuildInputs = with pythonPackages; [
    click click-log click-threading
    requests_toolbelt
    requests
    requests_oauthlib # required for google oauth sync
    atomicwrites
    milksnake
  ];

  buildInputs = with pythonPackages; [ setuptools_scm ];

  checkInputs = with pythonPackages; [ hypothesis pytest pytest-localserver pytest-subtesthack ] ++ [ glibcLocales ];

  postPatch = ''
    sed -i "/cargo build/d" Makefile
  '';

  preBuild = ''
    mkdir -p rust/target/release
    ln -s ${native}/lib/libvdirsyncer_rustext* rust/target/release/
    ln -s ${native}/include/vdirsyncer_rustext.h rust/target/
  '';

  LC_ALL = "en_US.utf8";

  preCheck = ''
    ln -sf ../dist/tmpbuild/vdirsyncer/vdirsyncer/_native__lib.so vdirsyncer
  '';

  checkPhase = ''
    runHook preCheck
    make DETERMINISTIC_TESTS=true test
    runHook postCheck
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/pimutils/vdirsyncer;
    description = "Synchronize calendars and contacts";
    maintainers = with maintainers; [ jgeerds ];
    platforms = platforms.all;
    license = licenses.mit;
  };
}
