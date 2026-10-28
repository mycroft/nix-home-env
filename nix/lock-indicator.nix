{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "lock-indicator";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "mycroft";
    repo = "lock-indicator";
    rev = "v${version}";
    hash = "sha256-i+vulYucW2p1Y9+aJ5+4h3GqdqLw5X0tpHkvBjcBX1I=";
  };

  cargoHash = "sha256-4YdSz0f3luubqgekJoArKVSV2fyJYIIGBu7HPZBZjGc=";

  meta = {
    description = "Whether gpg keys, AWS SSO sessions, gcloud credentials, Vault tokens and Docker registry credentials are unlocked, for the CLI and for waybar";
    homepage = "https://github.com/mycroft/lock-indicator";
    license = lib.licenses.mit;
    mainProgram = "lock-indicator";
    platforms = lib.platforms.linux;
  };
}
