{ lib
, mkDerivation
, cmake
, extra-cmake-modules
, kcoreaddons
, ki18n
, mauikit
, mauikit-filebrowsing
, qtmultimedia
, gst_all_1
}:

mkDerivation {
  pname = "booth";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    mauikit
    mauikit-filebrowsing
    qtmultimedia
    kcoreaddons
    ki18n
  ] ++ (with gst_all_1; [
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gstreamer
  ]);

  postInstall = ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  meta = with lib; {
    description = "Camera application";
    homepage = "https://invent.kde.org/maui/booth";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ onny ];
  };
}
