{ lib
, python3
, fetchFromGitHub
, m4
, meson
, ninja
, sphinx
, wrapQtAppsHook
, libseccomp
, bubblewrap
, xdg-dbus-proxy
}:

python3.pkgs.buildPythonApplication rec {
  pname = "bubblejail";
  version = "0.6.2";

  format = "other";

  src = fetchFromGitHub {
    owner = "igo95862";
    repo = "bubblejail";
    rev = version;
    hash = "sha256-9ABg36Hzq4pz+OWfmR3juAYErgRSxDw0P7SkDnJzB24=";
  };

  nativeBuildInputs = [
    m4
    meson
    ninja
    sphinx
    wrapQtAppsHook
  ];

  dontWrapQtApps = true;

  buildInputs = [
    libseccomp
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pyqt5
    pyxdg
    tomli
    tomli-w
  ];

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ bubblewrap xdg-dbus-proxy ])
  ];

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = {
    description = "Bubblewrap based sandboxing for desktop applications";
    homepage = "https://github.com/igo95862/bubblejail";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
  };
}
