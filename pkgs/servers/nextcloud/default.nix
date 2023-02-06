{ lib, stdenv, fetchurl, nixosTests, jq, moreutils }:

let
  generic = {
    version, sha256,
    eol ? false, extraVulnerabilities ? []
  }: let
    major = lib.versions.major version;
  in stdenv.mkDerivation rec {
    pname = "nextcloud";
    inherit version;

    src = fetchurl {
      url = "https://download.nextcloud.com/server/releases/${pname}-${version}.tar.bz2";
      inherit sha256;
    };

    patches = [ (./patches + "/v${major}/0001-Setup-remove-custom-dbuser-creation-behavior.patch") ];

    nativeBuildInputs = [
      jq
      moreutils
    ];

    postPatch = ''
      # correct hashes of the patched files
      mysql_hash=$(sha512sum lib/private/Setup/MySQL.php | head -c 128)
      jq --arg mysql_hash $mysql_hash \
        '.hashes."lib\/private\/Setup\/MySQL.php" = $mysql_hash' \
        core/signature.json | sponge core/signature.json
      postgresql_hash=$(sha512sum lib/private/Setup/PostgreSQL.php | head -c 128)
      jq --arg postgresql_hash $postgresql_hash \
        '.hashes."lib\/private\/Setup\/PostgreSQL.php" = $postgresql_hash' \
        core/signature.json | sponge core/signature.json
    '';

    passthru.tests = nixosTests.nextcloud;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/
      cp -R . $out/
      runHook postInstall
    '';

    meta = with lib; {
      description = "Sharing solution for files, calendars, contacts and more";
      homepage = "https://nextcloud.com";
      maintainers = with maintainers; [ schneefux bachp globin ma27 ];
      license = licenses.agpl3Plus;
      platforms = with platforms; unix;
      knownVulnerabilities = extraVulnerabilities
        ++ (optional eol "Nextcloud version ${version} is EOL");
    };
  };
in {
  nextcloud23 = throw ''
    Nextcloud v23 has been removed from `nixpkgs` as the support for is dropped
    by upstream in 2022-12. Please upgrade to at least Nextcloud v24 by declaring

        services.nextcloud.package = pkgs.nextcloud24;

    in your NixOS config.

    WARNING: if you were on Nextcloud 22 on NixOS 22.05 you have to upgrade to Nextcloud 23
    first on 22.05 because Nextcloud doesn't support upgrades across multiple major versions!
  '';

  nextcloud24 = generic {
    version = "24.0.9";
    sha256 = "580a3384c9c09aefb8e9b41553d21a6e20001799549dbd25b31dea211d97dd1e";
  };

  nextcloud25 = generic {
    version = "25.0.3";
    sha256 = "4b2b1423736ef92469096fe24f61c24cad87a34e07c1c7a81b385d3ea25c00ec";
  };

  # tip: get the sha with:
  # curl 'https://download.nextcloud.com/server/releases/nextcloud-${version}.tar.bz2.sha256'
}
