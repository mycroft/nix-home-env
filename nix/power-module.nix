{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "power-module";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "mycroft";
    repo = "power-module";
    rev = "42433dcef54ef741f5e00170fee64efbe8ed6aec";
    hash = "sha256-M/+NAcP96NEBGthVl0OeJE4kNmTJWOeKOxli3ZL/SPY=";
  };

  cargoHash = "sha256-6jFXu7BMti+EatiikUoYzeQPbRXRpdjnfxx83yQqwIo=";

  meta = {
    description = "AC adapter and battery state for the CLI and for waybar";
    homepage = "https://github.com/mycroft/power-module";
    mainProgram = "power-module";
    platforms = lib.platforms.linux;
  };
}
