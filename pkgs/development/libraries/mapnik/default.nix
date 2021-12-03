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
  version = "2021-12-03";

  src = fetchFromGitHub {
    owner = "mapnik";
    repo = "mapnik";
    rev = "6d47d3b70f4e331efe6ec3468878a4a5ef1d51c3";
    sha256 = "sha256-PHjRy61eHF7/A5n1qHh0CZxXsJDx7RlGYK1Gr8DAP7c=";
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
    # Harfbuzz's .cmake file is faulty, so we need to explicitly use pkg-config for locating it.
    "CMAKE_DISABLE_FIND_PACKAGE_harfbuzz=OFF"
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
