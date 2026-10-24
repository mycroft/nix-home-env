{
  fetchFromGitHub,
  installShellFiles,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "otp";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "mycroft";
    repo = "otp";
    rev = "v${version}";
    hash = "sha256-k0+Lu+I4RQVwOeDtZEjGAJ0Vl1p7l6JgO4cHsbHEQ18=";
  };

  cargoHash = "sha256-PJao3sJOueHUuGGCLAiHE52N+BY9JaRoKhYCXr4f128=";

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
