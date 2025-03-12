{ ... }:
{
  home.username = "shp";
  home.homeDirectory = "/home/shp";

  home.stateVersion = "25.05";

  imports = [ ./modules ];
  
  sops = {
    defaultSopsFile = ./../secrets/bhasher.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/etc/nixos/keys/bhasher.txt";
    secrets = {
      "ssh/gitkey" = {
				path = "/run/secrets/ssh/gitkey";
        #owner = config.home.username;
      };
    };
  };
}
