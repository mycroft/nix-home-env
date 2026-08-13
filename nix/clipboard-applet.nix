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
    rev = "e771994d4f0035d35d4397822ffcfd45ed70145a";
    hash = "sha256-1qD1B3hkNG0xP3Vu3uVNZZ5eJX7epEG47iCQYgWHsb4=";
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
