{ lib
, mkDerivation
, fetchFromGitLab
, python3
, cmake
, extra-cmake-modules
, ki18n
, kirigami2
, qtdeclarative
, qtimageformats
, qtmultimedia
, qtquickcontrols2
}:

mkDerivation rec {
  pname = "audiotube";
  version = "unstable-2021-03-17";

  format = "other";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "jbbgameich";
    repo = "audiotube";
    rev = "f4499cae34b34793a7232d54eb86ced600e9037f";
    sha256 = "10jwl6wyg70fwd16yi7gl5wjsz3mqjw74y3x2ndqymfs2pv1wbbg";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    python3.pkgs.pybind11
  ];

  buildInputs = [
    ki18n
    kirigami2
    qtdeclarative
    qtimageformats
    qtmultimedia
    qtquickcontrols2
  ];

  pythonEnv = python3.withPackages (ps: with ps; [
    setuptools
    youtube-dl
    ytmusicapi
  ]);

  qtWrapperArgs = [
    "--prefix" "PYTHONPATH" ":" "${pythonEnv}/${python3.sitePackages}"
  ];
}
