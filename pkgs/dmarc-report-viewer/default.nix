{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "dmarc-report-viewer";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "cry-inc";
    repo = "dmarc-report-viewer";
    rev = version;
    hash = "sha256-Wt8/vCeTQ7owLI3Qbn/G/7LDW5pYkSqfvnrnIs07ABg=";
  };

  cargoHash = "sha256-+FtoF4rZuNiCLiLhca1XRTDrSzI4AB8V5DmfkaklJJs=";

  meta = {
    description = "Lightweight standalone DMARC and SMTP TLS report viewer with IMAP client";
    homepage = "https://github.com/cry-inc/dmarc-report-viewer";
    license = lib.licenses.mit;
    mainProgram = "dmarc-report-viewer";
  };
}
