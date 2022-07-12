{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, substituteAll
, isPyPy
, python
, pillow
, pycairo
, pkg-config
, boost
, cairo
, harfbuzz
, icu
, libjpeg
, libpng
, libtiff
, libwebp
, mapnik
, proj
, zlib
, libxml2
, sqlite
}:

buildPythonPackage rec {
  pname = "python-mapnik";
  version = "unstable-2020-09-08";

  src = fetchFromGitHub {
    owner = "mapnik";
    repo = "python-mapnik";
    rev = "a2c2a86eec954b42d7f00093da03807d0834b1b4";
    sha256 = "sha256-tKBES7ZlpvNa4f2gs5wQhCfKGli1vxsFD4jzNNPdVXY=";
    # Only needed for test data
    fetchSubmodules = false;
  };

  patches = [
    # https://github.com/mapnik/python-mapnik/issues/239
    (fetchpatch {
      url = "https://github.com/koordinates/python-mapnik/commit/318b1edac16f48a7f21902c192c1dd86f6210a44.patch";
      sha256 = "sha256-cfU8ZqPPGCqoHEyGvJ8Xy/bGpbN2vSDct6A3N5+I8xM=";
    })
    ./find-pycairo-with-pkg-config.patch
    # python-mapnik seems to depend on having the mapnik src directory
    # structure available at build time. We just hardcode the paths.
    (substituteAll {
      src = ./find-libmapnik.patch;
      libmapnik = "${mapnik}/lib";
    })
  ];

  nativeBuildInputs = [
    mapnik # for mapnik_config
    pkg-config
  ];

  buildInputs = [
    mapnik
    boost
    cairo
    harfbuzz
    icu
    libjpeg
    libpng
    libtiff
    libwebp
    proj
    zlib
    libxml2
    sqlite
  ];

  propagatedBuildInputs = [ pillow pycairo ];

  configureFlags = [
    "XMLPARSER=libxml2"
  ];

  disabled = isPyPy;

  doCheck = false; # segfaults at python_tests.datasource_test.test_vrt_referring_to_missing_files

  preBuild = ''
    export BOOST_PYTHON_LIB="boost_python${"${lib.versions.major python.version}${lib.versions.minor python.version}"}"
    export BOOST_THREAD_LIB="boost_thread"
    export BOOST_SYSTEM_LIB="boost_system"
    export PYCAIRO=true
    export XMLPARSER=libxml2
  '';

  pythonImportsCheck = [ "mapnik" ];

  meta = with lib; {
    description = "Python bindings for Mapnik";
    maintainers = with maintainers; [ erictapen ];
    homepage = "https://mapnik.org";
    license = licenses.lgpl21Plus;
  };
}
