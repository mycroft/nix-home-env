{
  fetchFromGitHub,
  installShellFiles,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "otp";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "mycroft";
    repo = "otp";
    rev = "v${version}";
    hash = "sha256-RDVNeNi3aZBZz9zVcrY/aLxAHCwCIYsdfCXgRNsPkM8=";
  };

  cargoHash = "sha256-x9V/IybSi5CQftG4L3JtdbZRROfpn29bVqV6Gv6MkkA=";

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
