{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "lock-indicator";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "mycroft";
    repo = "lock-indicator";
    rev = "v${version}";
    hash = "sha256-4B2a/5cY9JThfIXQQ/+DIrSY9B5iVPOZTWAmNeaIdeQ=";
  };

  cargoHash = "sha256-vo/LdpnXEFX09v0j4TqGufKXkgsD7f/57LQBnPe3Db8=";

  meta = {
    description = "Whether gpg keys, AWS SSO sessions, gcloud credentials and Vault tokens are unlocked, for the CLI and for waybar";
    homepage = "https://github.com/mycroft/lock-indicator";
    license = lib.licenses.mit;
    mainProgram = "lock-indicator";
    platforms = lib.platforms.linux;
  };
}
