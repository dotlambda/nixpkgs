{ stdenv, fetchFromGitHub
, qmake, qtmultimedia, qtdeclarative, qtquick1, tree
, libv4l, libusb1, libav }:

stdenv.mkDerivation rec {
  name = "qtcam-${version}";
  version = "35ec2ea0e544909ca4f0fba519a77137c87a250a";

  src = fetchFromGitHub {
    owner = "econsysqtcam";
    repo = "qtcam";
    rev = version;
    sha256 = "09z1xz5ink2m4bc33mp7bqrf657mlf7bjb4q8sayc2y4qapxprad";
  };

  postUnpack = "sourceRoot=$sourceRoot/src";

  patches = [ ./launchpad-macro.patch ];

  nativeBuildInputs = [ qmake ];
  buildInputs = [
    tree qtmultimedia qtdeclarative qtquick1
    libv4l libusb1 libav
  ];

  qmakeFlags = "INCLUDEPATH=${libusb1.dev}/include/libusb-1.0";

  installPhase = ''
    mkdir -p $out/bin
    cp Qtcam $out/bin
  '';

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" && mkdir "$(pwd)"'';

  meta = with stdenv.lib; {
    homepage = https://www.e-consystems.com/opensource-linux-webcam-software-application.asp;
    description = "Free, Open Source Linux Webcamera Software";
    license = with licenses; gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    platforms = with platforms; linux;
  };
}
