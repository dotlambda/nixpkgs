{ lib, python3
, extraPackages ? ps: [ ]
, enableSystemd ? true
}:

let
  python = python3.override {
    packageOverrides = self: super: {

      matrix-synapse-ldap3 = self.buildPythonPackage rec {
        pname = "matrix-synapse-ldap3";
        version = "0.1.3";

        src = self.fetchPypi {
          inherit pname version;
          sha256 = "0a0d1y9yi0abdkv6chbmxr3vk36gynnqzrjhbg26q4zg06lh9kgn";
        };

        propagatedBuildInputs = with self; [ service-identity ldap3 twisted ];

        # ldaptor is not ready for py3 yet
        doCheck = !self.isPy3k;
        checkInputs = with self; [ ldaptor mock ];
      };

      prometheus_client = super.prometheus_client.overridePythonAttrs (oldAttrs: rec {
        version = "0.3.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "093yhvz7lxl7irnmsfdnf2030lkj4gsfkg6pcmy4yr1ijk029g0p";
        };
      });

      matrix-synapse = self.buildPythonPackage rec {
        pname = "matrix-synapse";
        version = "0.99.0";

        src = self.fetchPypi {
          inherit pname version;
          sha256 = "1xsp60172zvgyjgpjmzz90rj1din8d65ffg73nzid4nd875p45kh";
        };

        propagatedBuildInputs = with self; [
          bcrypt
          bleach
          canonicaljson
          daemonize
          frozendict
          jinja2
          jsonschema
          lxml
          matrix-synapse-ldap3
          msgpack
          netaddr
          phonenumbers
          pillow
          prometheus_client
          psutil
          psycopg2
          pyasn1
          pymacaroons
          pynacl
          pyopenssl
          pysaml2
          pyyaml
          requests
          signedjson
          sortedcontainers
          treq
          twisted
          unpaddedbase64
        ] ++ extraPackages self ++ lib.optional enableSystemd systemd;

        checkInputs = with self; [ mock ];

        checkPhase = ''
          PYTHONPATH=".:$PYTHONPATH" trial tests
        '';

        passthru = {
          python = python.withPackages (ps: [ ps.matrix-synapse ]);
        };

        meta = with lib; {
          homepage = https://matrix.org;
          description = "Matrix reference homeserver";
          license = licenses.asl20;
          maintainers = with maintainers; [ ralith roblabla ekleog ];
        };
      };
    };
  };

in with python.pkgs; toPythonApplication matrix-synapse
