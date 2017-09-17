{ stdenv, buildPythonPackage, fetchPypi
, pytest, portmidi, pygame, rtmidi }:

buildPythonPackage rec {
  pname = "mido";
  name = "${pname}-${version}";
  version = "1.2.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0griab8f54d3phf07p99s750xjw7vx2sdhydxgyca7ajsis2h51m";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ portmidi pygame rtmidi ];

  postPatch = ''
    substituteInPlace mido/backends/portmidi_init.py --replace "dll_name = 'libportmidi.so'" "dll_name = '${portmidi}/lib/libportmidi.so'"
  '';

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/olemb/mido/;
    description = "MIDI Objects for Python";
    license = licenses.mit;
    maintainers = [ maintainers.dotlambda ];
  };
}
