{ fetchFromGitHub, installShellFiles, lib, rustPlatform }:
rustPlatform.buildRustPackage rec {
  pname = "mmtc";
  version = "0.2.13-fork";

  src = fetchFromGitHub {
    owner = "mycroft";
    repo = pname;
    rev = "e8661564cc2beeaed0866e119f59e02399f14cf4";
    hash = "sha256-qpQs+/i/TWC7EG68dOh0qHJJDFA47rUgF1nHFHusjb8=";
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
