{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, substituteAll
, boost
, cairo
, freetype
, gdal
, harfbuzz
, icu
, libjpeg
, libpng
, libtiff
, libwebp
, libxml2
, proj
, python3
, sqlite
, zlib
, catch2
, sconsPackages

  # supply a postgresql package to enable the PostGIS input plugin
, postgresql ? null
}:

let
  scons = sconsPackages.scons_3_0_1;
in stdenv.mkDerivation rec {
  pname = "mapnik-unstable";
  version = "2021-11-02";

  src = fetchFromGitHub {
    owner = "mapnik";
    repo = "mapnik";
    rev = "dc5f497495961185997bc490109239a0c3e8d6a9";
    sha256 = "sha256-OXMNRaKJdTvY3F9jg1AEAXO0ddhK9VxAcJQSn5opY0Y=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace configure \
      --replace '$PYTHON scons/scons.py' ${scons}/bin/scons
    rm -r scons
  '';

  # a distinct dev output makes python-mapnik fail
  outputs = [ "out" ];

  patches = [
    # The lib/cmake/harfbuzz/harfbuzz-config.cmake file in harfbuzz.dev is faulty,
    # as it provides the wrong libdir. The workaround is to just rely on
    # pkg-config to locate harfbuzz shared object files.
    # Upstream HarfBuzz wants to drop CMake support anyway.
    # See discussion: https://github.com/mapnik/mapnik/issues/4265
    ./cmake-harfbuzz.patch
    # prevent CMake from trying to get libraries on the Internet
    (substituteAll {
      src = ./catch2-src.patch;
      catch2_src = catch2.src;
    })

  ];

  nativeBuildInputs = [ cmake pkg-config scons ];

  buildInputs = [
    boost
    cairo
    freetype
    gdal
    harfbuzz
    icu
    libjpeg
    libpng
    libtiff
    libwebp
    proj
    python3
    sqlite
    zlib
    libxml2

    # optional inputs
    postgresql
  ];

  cmakeFlags = [
    # Would require qt otherwise.
    "-DBUILD_DEMO_VIEWER=OFF"
  ];

  # mapnik-config is currently not build with CMake. So we use the SCons for this one.
  preBuild = ''
    cd ..
    python3 scons/scons.py utils/mapnik-config
    cd build
  '';

  preInstall = ''
    mkdir -p $out/bin
    cp ../utils/mapnik-config/mapnik-config $out/bin/mapnik-config
  '';

  meta = with lib; {
    description = "An open source toolkit for developing mapping applications";
    homepage = "https://mapnik.org";
    maintainers = with maintainers; [ hrdinka erictapen ];
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
  };
}
