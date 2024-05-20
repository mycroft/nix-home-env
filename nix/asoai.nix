{ buildGoModule
, fetchFromGitHub
,
}:
buildGoModule rec {
  pname = "asoai";
  version = "0.0.1";
  vendorHash = "sha256-CC6Yf/zNNYoFVqiv/D1TWdbEiOmWRMUuCHO9fG2n2FU=";

  src = fetchFromGitHub {
    owner = "mycroft";
    repo = "asoai";
    rev = "${version}";
    sha256 = "sha256-bh8blqIXPGQyoWv52CrP1W/xpSv2H7W9HmSYkwtMt0A=";
  };

  meta = {
    description = "Another stupid Open AI client";
    homepage = "https://github.com/mycroft/asoai";
    mainProgram = "asoai";
  };
}
