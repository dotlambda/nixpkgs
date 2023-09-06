{ lib
, buildNpmPackage
, fetchFromGitHub
, fetchurl
, testers
, mongosh
}:

let
  source = lib.importJSON ./source.json;
  github = fetchFromGitHub {
    owner = "mongodb-js";
    repo = "mongosh";
    rev = "v${source.version}";
    hash = "sha256-LKXhUAC08qzzLkKQatMEqZvrS6yCOVUdnSowlxaPbZI=";
  };
in
buildNpmPackage {
  pname = "mongosh";
  inherit (source) version;

  src = fetchurl {
    url = "https://registry.npmjs.org/mongosh/-/${source.filename}";
    hash = source.integrity;
  };

  postPatch = ''
    cp ${github}/package-lock.json .
  '';

  npmDepsHash = source.deps;

  makeCacheWritable = true;
  dontNpmBuild = true;
  npmFlags = [ "--omit=optional" ];

  passthru = {
    tests.version = testers.testVersion {
      package = mongosh;
    };
    updateScript = ./update.sh;
  };

  meta = with lib; {
    homepage = "https://www.mongodb.com/try/download/shell";
    description = "The MongoDB Shell";
    maintainers = with maintainers; [ aaronjheng ];
    license = licenses.asl20;
    mainProgram = "mongosh";
  };
}
