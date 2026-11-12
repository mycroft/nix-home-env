{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "lock-indicator";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "mycroft";
    repo = "lock-indicator";
    rev = "v${version}";
    hash = "sha256-U6uzs5sZtgyVuxy+K/NRf0e3I6/jDyRtLBK6JlwFPs8=";
  };

  cargoHash = "sha256-XGoOKZWzxFK49v8EOzyWlSxTuGi+lz92EZAszm3G8Uo=";

  meta = {
    description = "Whether gpg keys, AWS SSO sessions, gcloud credentials, Vault tokens and Docker registry credentials are unlocked, for the CLI and for waybar";
    homepage = "https://github.com/mycroft/lock-indicator";
    license = lib.licenses.mit;
    mainProgram = "lock-indicator";
    platforms = lib.platforms.linux;
  };
}
