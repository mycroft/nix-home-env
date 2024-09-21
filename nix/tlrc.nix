{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "tlrc";
  version = "1.9.3-adding-branch";

  src = fetchFromGitHub {
    owner = "mycroft";
    repo = pname;
    rev = "c85b0234d0eda1b2f94903d302d0ac6ce2564dc1";
    hash = "sha256-grLUb2rG7uXpfEdRpnNJ4fijE211RWaqFtzDZG0QrN4=";
  };

  cargoHash = "sha256-PnJnszsu/cg/VbmZw2MrYIUv8hEsYt2XCWhDGyBp6Uc=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  postInstall = ''
    installManPage tldr.1
    installShellCompletion completions/{tldr.bash,_tldr,tldr.fish}
  '';

  meta = with lib; {
    description = "Official tldr client written in Rust";
    homepage = "https://github.com/tldr-pages/tlrc";
    changelog = "https://github.com/tldr-pages/tlrc/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "tldr";
    maintainers = with maintainers; [ acuteenvy ];
  };
}
