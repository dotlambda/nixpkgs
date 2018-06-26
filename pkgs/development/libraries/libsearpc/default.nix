{stdenv, fetchFromGitHub, automake, autoconf, pkgconfig, libtool, python2Packages, glib, jansson}:

stdenv.mkDerivation rec {
  version = "3.1-latest";
  name = "libsearpc-${version}";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "libsearpc";
    rev = "v${version}";
    sha256 = "0sv92na3ca1c8k0v9fbaqkmsk31q7gp0562mqa1wxb4llig6kfwj";
  };

  patches = [ ./libsearpc.pc.patch ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ automake autoconf libtool python2Packages.python python2Packages.simplejson ];
  propagatedBuildInputs = [ glib jansson ];

  preConfigure = "./autogen.sh";

  buildPhase = "make -j1";

  meta = {
    homepage = https://github.com/haiwen/libsearpc;
    description = "A simple and easy-to-use C language RPC framework (including both server side & client side) based on GObject System";
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ ];
  };
}
