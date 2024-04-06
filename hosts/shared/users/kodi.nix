{ pkgs, config, ... }:
{
  imports = [
  ];

  home-manager.users.kodi = import ../../../home/kodi.nix;

  users.users.kodi = {
    isNormalUser = true;
    initialPassword = "raspberry";
    extraGroups = [ "wheel" "audio" ] ;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOGsCS7XysWiFuLVmN01cJAAZN2ZhWVB4V6R6F5DLsuM"
	];
  };

  environment.systemPackages = with pkgs; [
    zsh-powerlevel10k
  ];
}
