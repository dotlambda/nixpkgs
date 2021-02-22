{ lib
, fetchurl
, python3
, glib
, gobject-introspection
, meson
, ninja
, pkg-config
, wrapGAppsHook
, atk
, libhandy
, libnotify
, pango
}:

python3.pkgs.buildPythonApplication rec {
  pname = "caerbannog";
  version = "0.3";
  format = "other";

  src = fetchurl {
    url = "https://git.sr.ht/~craftyguy/caerbannog/archive/${version}.tar.gz";
    sha256 = "0ip5hs34v9a4ia75dv25z41cwp5vhgrmp30hkfs33p2xkmpakikz";
  };

  nativeBuildInputs = [
    glib
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    atk
    gobject-introspection
    libhandy
    libnotify
    pango
  ];

  propagatedBuildInputs = with python3.pkgs; [
    anytree
    fuzzyfinder
    gpgme
    pygobject3
  ];

  meta = with lib; {
    description = "Mobile-friendly Gtk frontend for password-store";
    homepage = "https://sr.ht/~craftyguy/caerbannog/";
    changelog = "https://git.sr.ht/~craftyguy/caerbannog/refs/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
