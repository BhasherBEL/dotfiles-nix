#!/bin/sh

if [ -z "$1" ]; then
  echo "Usage: $0 <name>"
  exit 1
fi

name=$1
dir=/etc/nixos/services/$name

mkdir $dir

cat > $dir/default.nix <<EOF
{ lib, config, ... }:
let
  cfg = config.hostServices.${name};
in
{
  options = {
    hostServices.${name}= {
			enable = lib.mkEnableOption "Enable ${name}";
			hostname = lib.mkOption {
				type = lib.types.str;
				default = "${name}.bhasher.com";
				description = "The hostname for ${name}";
			};
		};
  };

  config = lib.mkIf cfg.enable {
		services = {
			${name} = {
				enable = true;
			};
      nginx.virtualHosts."\${cfg.hostname}" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:\${toString config.services.${name}}";
            recommendedProxySettings = true;
            extraConfig = "include \${config.hostServices.auth.authelia.snippets.request};";
					};
          "/internal/authelia/authz" = {
            recommendedProxySettings = false;
            extraConfig = "include \${config.hostServices.auth.authelia.snippets.location};";
          };
				};
			};
		};

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        "/var/lib/${name}"
      ];
    };
  };
}
EOF

echo "default.nix created in $dir"

nvim $dir/default.nix

