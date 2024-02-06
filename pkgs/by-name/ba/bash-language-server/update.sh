#! /usr/bin/env nix-shell
#! nix-shell -i bash -p common-updater-scripts curl gnused nodejs prefetch-npm-deps wget

set -euo pipefail

api_url="https://api.github.com/repos/bash-lsp/bash-language-server/tags?per_page=1000"
version=$(curl -s "$api_url" | jq -r '.[].name | select(test("^server")) | sub("^server-"; "")' | sort --version-sort | tail -1)

if [[ "$UPDATE_NIX_OLD_VERSION" == "$version" ]]; then
    echo "Already up to date!"
    exit 0
fi

update-source-version bash-language-server "$version"

pushd "$(dirname "${BASH_SOURCE[0]}")"
rm -f package-lock.json package.json
wget "https://github.com/bash-lsp/bash-language-server/raw/server-$version/package.json"
npm i --package-lock-only --ignore-scripts
npm_hash=$(prefetch-npm-deps package-lock.json)
sed -i 's#npmDepsHash = "[^"]*"#npmDepsHash = "'"$npm_hash"'"#' package.nix
rm -f package.json
popd
