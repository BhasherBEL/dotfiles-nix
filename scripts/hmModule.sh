#!/bin/sh

if [ -z "$1" ]; then
  echo "Usage: $0 <name>"
  exit 1
fi

name=$1
namecfg=$1cfg
dir=/etc/nixos/home/modules/$name

mkdir $dir

cat > $dir/default.nix <<EOF
{ lib, config, ... }:
let
  ${namecfg} = config.modules.${name};
in
{
  options = {
    modules.${name}.enable = lib.mkEnableOption "Enable ${name}";
  };

  config = lib.mkIf ${namecfg}.enable {
    # TODO
  };
}
EOF

echo "default.nix created in $dir"

nvim $dir/default.nix

