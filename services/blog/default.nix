{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.hostServices.blog;
in
{
  options.hostServices.blog = {
    enable = lib.mkEnableOption "Enable Blog";
    hostname = lib.mkOption {
      type = lib.types.str;
      default = "blog.bhasher.com";
      description = "The hostname for the blog";
    };
  };
  config = lib.mkIf cfg.enable {
    services.nginx.virtualHosts."${cfg.hostname}" = {
      forceSSL = true;
      enableACME = true;
      root = "${inputs.blog.packages.${pkgs.system}.default}";
      locations = {
        "/" = {
          tryFiles = "$uri $uri/ =404";
        };
      };
    };
  };
}
