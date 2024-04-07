{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "krewfile";
  version = "0.1.1";
  vendorHash = "sha256-Z0H01Ts6RlBFwKgx+9YYAd9kT4BkCBL1mvJsRf2ci5I=";

  src = fetchFromGitHub {
    owner = "brumhard";
    repo = "krewfile";
    rev = "v${version}";
    sha256 = "sha256-K3ya01QkVju5njzxH8TyGm1K8orYLh3zUPdygQXG3qI=";
  };

  meta = with lib; {
    description = "Helper to declaratively manage krew plugins";
    homepage = "https://goreleaser.com";
    maintainers = with maintainers; [ brumhard ];
    license = licenses.mit;
  };
}
