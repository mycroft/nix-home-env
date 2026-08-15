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
    rev = "fd8fe7337f3dc664ff2d2187ffa054f7802d1e84";
    hash = "sha256-dKznyiDUCTJw+pSNIij44PBCiLTnI0z7xAZnjhbz7mk=";
  };

  cargoHash = "sha256-4fTfx6SPUqBfHJ84XF6tP8vryDyE3VKSi6GI4sG3ve0=";

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
