{ stdenv, fetchsvn, perl, zlib, bzip2 }:

stdenv.mkDerivation rec {
  name = "Routino-${version}";
  version = "3.2";

  src = fetchsvn {
    url = "http://routino.org/svn/trunk/";
    rev = 1903;
    sha256 = "0brrybd9jna47wbsxbdx2f21z1jl602n6686071fj69lmghv7ilz";
  };

  nativeBuildInputs = [ perl ];
  buildInputs = [ zlib bzip2 ];

  installPhase = ''
    make DESTDIR="$out" install
    mv $out/usr/local/* $out
    rmdir $out/usr/local $out/usr
  '';

  meta = with stdenv.lib; {
    homepage = http://www.routino.org/;
    description = "OpenStreetMap Routing Software";
    license = licenses.agpl3;
    maintainter = with maintainers; [ dotlambda ];
    platforms = with platforms; linux;
  };
}
