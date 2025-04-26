{ lib, modulesPath, ... }:
{

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./disk-config.nix
    ./hardware-configuration.nix
  ];

  boot.loader.grub = {
    devices = [ "nodev" ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  users.users.nixos = {
    isNormalUser = true;
    initialPassword = "nixos";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOGsCS7XysWiFuLVmN01cJAAZN2ZhWVB4V6R6F5DLsuM"
    ];
  };

  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };
  };

  networking = {
    useDHCP = lib.mkForce false;
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
  };

  services.cloud-init = {
    enable = true;
    network.enable = true;
    settings = {
      datasource_list = [ "ConfigDrive" ];
      datasource.ConfigDrive = { };
    };
  };

  environment.persistence."/persistent" = {
    enable = true;
    hideMounts = true;
    directories = [
      #Mandatory https://github.com/NixOS/nixpkgs/pull/273384
      "/var/lib/nixos"
      "/etc/nixos"

      "/var/mailserver"
    ];
  };

  system.stateVersion = "24.11";
}
