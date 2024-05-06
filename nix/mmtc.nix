{ fetchFromGitHub, installShellFiles, lib, rustPlatform }:
rustPlatform.buildRustPackage rec {
  pname = "mmtc";
  version = "0.2.13-fork";

  src = fetchFromGitHub {
    owner = "mycroft";
    repo = pname;
    rev = "00b97ae13fd3c7e5a34008fd4b498c8275041367";
    hash = "sha256-TbVQjd5bg1b9qcHSlPXUsarAfOqLGH8Zndhvc3k9L7s=";
  };

  cargoHash = "sha256-Q1uFrReg3GZoIHH34UwK42JNJzAUaP79yznj96mSPGA=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage artifacts/mmtc.1
    installShellCompletion artifacts/mmtc.{bash,fish} --zsh artifacts/_mmtc
  '';

  GEN_ARTIFACTS = "artifacts";

  meta = with lib; {
    description = "Minimal mpd terminal client that aims to be simple yet highly configurable";
    homepage = "https://github.com/mycroft/mmtc";
    changelog = "https://github.com/mycroft/mmtc/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "mmtc";
  };
}
