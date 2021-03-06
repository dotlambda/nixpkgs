{ stdenv, fetchFromGitHub, cmake, doxygen ? null, pkgconfig, freetype ? null, glib, harfbuzz ? null
, liblcf, libpng, libsndfile ? null, libvorbis ? null, libxmp ? null
, libXcursor, libXext, libXi, libXinerama, libXrandr, libXScrnSaver, libXxf86vm
, mpg123 ? null, opusfile ? null, pcre, pixman, SDL2_mixer, speexdsp ? null, wildmidi ? null, zlib }:

stdenv.mkDerivation rec {
  name = "easyrpg-player-${version}";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "EasyRPG";
    repo = "Player";
    rev = version;
    sha256 = "1k1b5ws48h1ylarbcfsxyvajl0fdzmi3db8y3m8iq4fg3f0yslg8";
  };

  nativeBuildInputs = [ cmake doxygen pkgconfig ];

  buildInputs = [
    freetype
    glib
    harfbuzz
    liblcf
    libpng
    libsndfile
    libvorbis
    libxmp
    libXcursor
    libXext
    libXi
    libXinerama
    libXrandr
    libXScrnSaver
    libXxf86vm
    mpg123
    opusfile
    SDL2_mixer
    pcre
    pixman
    speexdsp
    wildmidi
    zlib
  ];

  meta = with stdenv.lib; {
    description = "RPG Maker 2000/2003 and EasyRPG games interpreter";
    homepage = https://easyrpg.org/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ yegortimoshenko ];
    platforms = platforms.linux;
  };
}
