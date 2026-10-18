{
  fetchFromGitHub,
  installShellFiles,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "otp";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "mycroft";
    repo = "otp";
    rev = "v${version}";
    hash = "sha256-pJISQ3X3a8SzyABYDSCFz/g5+N/+Gxc4XnZZNqBNB8s=";
  };

  cargoHash = "sha256-oBE5tUvPyYw2t9AXmBsCE44HfF/26Nvqm8L7YcqHWuU=";

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
