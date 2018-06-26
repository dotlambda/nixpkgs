{stdenv, fetchFromGitHub, which, autoreconfHook, pkgconfig, curl, vala, python, intltool, fuse, ccnet}:

stdenv.mkDerivation rec {
  version = "6.2.0";
  name = "seafile-shared-${version}";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile";
    rev = "v${version}";
    sha256 = "1n6ljvr6wcs76nhzwvzcx8652dacldjd8jkaj94gdm9cfsf1c9nm";
  };

  nativeBuildInputs = [ pkgconfig which autoreconfHook vala intltool ];
  buildInputs = [ python fuse ];
  propagatedBuildInputs = [ ccnet curl ];

  configureFlags = [
    "--disable-server"
    "--disable-console"
  ];

  postInstall = ''
    # Remove seafile binary
    rm "$out/bin/seafile"
    # Remove cli client binary
    rm "$out/bin/seaf-cli"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/haiwen/seafile;
    description = "Shared components of Seafile: seafile-daemon, libseafile, libseafile python bindings, manuals, and icons";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
