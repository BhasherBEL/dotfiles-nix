{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [ rustdesk ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      # Rustdesk require this unfree package to work
      "libsciter"
    ];
}
