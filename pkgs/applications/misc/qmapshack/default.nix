{ stdenv, fetchFromBitbucket, cmake, qtscript, qtwebkit, gdal, proj, quazip }:

stdenv.mkDerivation rec {
  name = "QMapShack-${version}";
  version = "1.9.1";

  src = fetchFromBitbucket {
    owner = "maproom";
    repo = "qmapshack";
    rev = "V ${version}"; #"864d15f";
    sha256 = "1yswdq1s9jjhwb3wfiy3kkiiaqzagw28vjqvl13jxcnmq7y763sr";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qtscript qtwebkit gdal proj quazip ];

  meta = with stdenv.lib; {
    homepage = https://bitbucket.org/maproom/qmapshack/wiki/Home;
    description = "Plan your next outdoor trip";
    license = licenses.gpl3;
    maintainter = with maintainers; [ dotlambda ];
    platforms = with platforms; linux;
  };
}
