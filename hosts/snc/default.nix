{
  config,
  ...
}:
{

  imports = [
    ./hardware.nix
    ./services.nix
  ];

  networking = {
    hostName = "snc";
    dhcpcd.enable = false;
    useDHCP = false;

    defaultGateway = {
      address = "37.120.188.1";
      interface = "ens3";
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens3";
    };
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    interfaces.ens3 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "37.120.190.20";
          prefixLength = 22;
        }
      ];
      ipv6.addresses = [
        {
          address = "2a03:4000:6:b7cb::10";
          prefixLength = 64;
        }
      ];
    };
  };

  services = {
    openssh = {
      enable = true;
      openFirewall = true;
      passwordAuthentication = false;
      kbdInteractiveAuthentication = false;
    };
    qemuGuest.enable = true;
    displayManager = {
      autoLogin = {
        enable = true;
        user = "snc";
      };
    };
  };

  system.stateVersion = "25.11";

  swapDevices = [ ];

  nix.settings.trusted-users = [ "snc" ];

  sops = {
    defaultSopsFile = ../../secrets/bhasher.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/etc/nixos/keys/bhasher.txt";
    secrets = {
      "ssh/gitkey" = {
        owner = config.users.users.snc.name;
      };
    };
  };

  users = {
    mutableUsers = false;
    users."snc" = {
      isNormalUser = true;
      hashedPassword = "$y$j9T$yp6CJlapZ.FhH.veUQ0ux.$O0gwigqlWRPGn15gN0mzdGf/hzuBdUkiwsabmvtZdw3";
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOGsCS7XysWiFuLVmN01cJAAZN2ZhWVB4V6R6F5DLsuM"
      ];
    };
  };

  home-manager.users.snc.imports = [ ../../home/snc.nix ];
}
