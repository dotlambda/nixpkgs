{ lib
, buildNpmPackage
, fetchFromGitHub
, shellcheck
}:

buildNpmPackage rec {
  pname = "bash-language-server";
  version = "5.1.2";

  src = fetchFromGitHub {
    owner = "bash-lsp";
    repo = "bash-language-server";
    rev = "server-${version}";
    hash = "sha256-5+KXiiFcVOWSQ9JSI89B2uxl5HvEYq66kQtOKgl1ZkI=";
  };

  npmDepsHash = "sha256-/CBwrL64bVwQdfXnXNwur5Pk/obnrGAykYuBucPr6Xc=";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  npmFlags = [ "--ignore-scripts" ];

  npmBuildScript = "compile";

  postInstall = ''
    wrapProgram "$out/bin/bash-language-server" \
      --prefix PATH : ${lib.makeBinPath [ shellcheck ]}
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "A language server for Bash";
    homepage = "https://github.com/bash-lsp/bash-language-server";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "bash-language-server";
    platforms = platforms.all;
  };
}
