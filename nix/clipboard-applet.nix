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
    rev = "b1abd04137533ecd2a90e17df0f0383e911ecc88";
    hash = "sha256-iw9CFF2ABFrxnxwV9J14OBhp/LJ5uNRpjgKHb9LFnlE=";
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
