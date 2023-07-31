{ lib
, buildNpmPackage
, fetchFromGitHub
, jq
}:

buildNpmPackage rec {
  pname = "pyright";
  version = "1.1.320";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "pyright";
    rev = version;
    hash = "sha256-OxXHH67TxWQJx4NXPfP0PYSeGXNPyZldoGwd0Sw13X0=";
  };

  postPatch = ''
    ${jq}/bin/jq -s ".[0] * .[1] * .[2]" \
      package-lock.json \
      packages/pyright-internal/package-lock.json \
      packages/pyright/package-lock.json \
      > package-lock.json.tmp
    mv package-lock.json.tmp package-lock.json
  '';

  npmDepsHash = "sha256-akoqnYnN/jTXnDIa5Bz+SMGynyL30+TR39tIRSUqY9Q=";

  npmWorkspace = "packages/pyright";

  meta = with lib; {
    description = "Static Type Checker for Python";
    homepage = "https://github.com/Microsoft/pyright";
    license = licenses.mit;
    maintainers = with maintainers; [ leungbk ];
  };
}
