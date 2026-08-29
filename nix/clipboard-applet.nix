{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "clipboard-applet";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "mycroft";
    repo = "clipboard-applet";
    rev = "017dd6ec0c95f276da9e5aef824598fa4218c95e";
    hash = "sha256-Knl/8gTWBJsyi05+j4v0Ut8fZFtP2qUN2/kjyY/QFv4=";
  };

  cargoHash = "sha256-mJ8RnOTahzjuP5QEhcIjg0t58mH2ba4a6AsBhZneS84=";

  postInstall = ''
    install -Dm644 contrib/clipboard-applet.desktop \
      $out/share/applications/clipboard-applet.desktop
    substituteInPlace $out/share/applications/clipboard-applet.desktop \
      --replace-fail "Exec=clipboard-applet" "Exec=$out/bin/clipboard-applet"
  '';

  meta = {
    description = "Wayland clipboard tray applet";
    homepage = "https://github.com/mycroft/clipboard-applet";
    mainProgram = "clipboard-applet";
    platforms = lib.platforms.linux;
  };
}
