{ lib
, buildNpmPackage
, fetchFromGitHub
, cargo
, rustc
, rustPlatform
, runCommand
, tailwindcss
}:

buildNpmPackage rec {
  pname = "tailwindcss";
  version = "3.3.3";

  src = fetchFromGitHub {
    owner = "tailwindlabs";
    repo = "tailwindcss";
    rev = "v${version}";
    hash = "sha256-ZL44mhue7PVxYGT6yF/nkW+kVP6YgYjzg/XDJdijNUI=";
  };

  sourceRoot = "${src.name}/standalone-cli";

  npmDepsHash = "sha256-xRiKMUqxNzUt5ySj5vSmjUIp+k/MWijRMSRqZ2bmiWM=";

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${src.name}/oxide";
    hash = "sha256-LSFh7U6DXrH9EFnC7d1dZkc389XoPP3eB2rjCWSTR24=";
  };

  cargoRoot = "../oxide";

  nativeBuildInputs = [
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  passthru.tests.helptext = runCommand "tailwindcss-test-helptext" { } ''
    ${tailwindcss}/bin/tailwindcss --help > $out
  '';

  meta = with lib; {
    changelog = "https://github.com/tailwindlabs/tailwindcss/blob/${src.rev}/CHANGELOG.md";
    description = "Command-line tool for the CSS framework with composable CSS classes, standalone CLI";
    homepage = "https://tailwindcss.com/blog/standalone-cli";
    license = licenses.mit;
    maintainers = [ maintainers.adamcstephens ];
  };
}
