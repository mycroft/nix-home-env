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
    rev = "311dd9053b1e31c390bfc87503f4512fbe390857";
    hash = "sha256-uGNRuHmNSsc3gEmrPAAvp9YO+/zd5/UABet0zAPkwPQ=";
  };

  cargoHash = "sha256-6jFXu7BMti+EatiikUoYzeQPbRXRpdjnfxx83yQqwIo=";

  meta = {
    description = "AC adapter and battery state for the CLI and for waybar";
    homepage = "https://github.com/mycroft/power-module";
    mainProgram = "power-module";
    platforms = lib.platforms.linux;
  };
}
