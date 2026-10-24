{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "lock-indicator";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "mycroft";
    repo = "lock-indicator";
    rev = "v${version}";
    hash = "sha256-ldBdaRDG+AY6EVnx8MkPmBuZkCIHMw+qIOAJTa8N8xk=";
  };

  cargoHash = "sha256-kpCmq1+QfAGP+aXtDDgyXhVO10cZWMJUNCMTBqLhAoE=";

  meta = {
    description = "Whether gpg keys, AWS SSO sessions, gcloud credentials and Vault tokens are unlocked, for the CLI and for waybar";
    homepage = "https://github.com/mycroft/lock-indicator";
    license = lib.licenses.mit;
    mainProgram = "lock-indicator";
    platforms = lib.platforms.linux;
  };
}
