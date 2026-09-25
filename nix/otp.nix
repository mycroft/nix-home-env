{
  fetchFromGitHub,
  installShellFiles,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "otp";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "mycroft";
    repo = "otp";
    rev = "v${version}";
    hash = "sha256-N8D00R+n4dqczM0yiCEBLem/2VnI/VnZnxq+mE5MN30=";
  };

  cargoHash = "sha256-0jrTLRgRHqXVcH+CsFuLsqAu6o0wSGI3nkxlhMtdU0k=";

  buildFeatures = [ "tui" ];

  nativeBuildInputs = [ installShellFiles ];

  # Completion scripts are dynamic: they call back into the binary to complete
  # subcommands, flags and entry names.
  postInstall = ''
    installShellCompletion --cmd otp \
      --bash <(COMPLETE=bash $out/bin/otp) \
      --fish <(COMPLETE=fish $out/bin/otp) \
      --zsh <(COMPLETE=zsh $out/bin/otp)
  '';

  meta = {
    description = "Store MFA secrets and generate TOTP/HOTP codes from the command line";
    homepage = "https://github.com/mycroft/otp";
    license = lib.licenses.mit;
    mainProgram = "otp";
    platforms = lib.platforms.linux;
  };
}
