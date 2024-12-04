{
  pkgs,
  lib,
  config,
  ...
}:
let
  jscfg = config.modules.js;
in
{
  options = {
    modules.js.enable = lib.mkEnableOption "Enable js";
  };

  config = lib.mkIf jscfg.enable {
    environment.systemPackages = with pkgs; [
      nodejs_22
      #nodePackages.rollup
      tailwindcss-language-server
      nodePackages.svelte-language-server
      # Not working
      prettierd
      # As long as prettierd is not working
      nodePackages.prettier
      nodePackages.typescript-language-server
      pnpm
    ];
  };
}
