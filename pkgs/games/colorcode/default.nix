{ stdenv, fetchurl, qmake, qtbase }:

stdenv.mkDerivation rec {
  name = "colorcode-${version}";
  version = "0.8.5";

  src = fetchurl {
    url = "http://colorcode.laebisch.com/download/ColorCode-${version}.tar.gz";
    sha256 = "118sgk2zpzfsr2kx64ad79ah10a498dhj45pkr1i3azn5aqqs4kw";
  };

  nativeBuildInputs = [ qmake ];

  propagatedBuildInputs = [ qtbase ];

  enableParallelBuilding = true;

  installPhase = ''
    install -Dt $out/bin colorcode
  '';

  meta = with stdenv.lib; {
    homepage = http://colorcode.laebisch.com/;
    description = "Advanced MasterMind game and solver";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dotlambda ];
    platforms = with platforms; linux;
  };
}
