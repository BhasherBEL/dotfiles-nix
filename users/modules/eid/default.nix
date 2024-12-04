{
  pkgs,
  lib,
  config,
  ...
}:
let
  eidcfg = config.modules.eid;
in
{
  options = {
    modules.eid.enable = lib.mkEnableOption "Enable eid";
  };

  config = lib.mkIf eidcfg.enable {
    services.pcscd = {
      enable = true;
      plugins = with pkgs; [ eid-mw ];
    };

    programs.firefox = {
      #nativeMessagingHosts.euwebid = true;
      #policies.SecurityDevices.p11-kit-proxy = "${pkgs.p11-kit}/lib/p11-kit-proxy.so";
    };

    #environment.etc."pkcs11/modules/opensc-pkcs11".text = ''
    #  module: ${pkgs.opensc}/lib/opensc-pkcs11.so
    #'';

    environment.systemPackages = with pkgs; [ eid-mw ];
  };
}
