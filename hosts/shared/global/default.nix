{ pkgs, inputs, ... }: {
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  time.timeZone = "Europe/Paris";

  # Internationalisation settings
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "fr";

  networking.networkmanager.enable = true;

  users.defaultUserShell = pkgs.zsh;

  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [
        {
          command = "${pkgs.systemd}/bin/systemctl suspend";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${pkgs.systemd}/bin/reboot";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${pkgs.systemd}/bin/poweroff";
          options = [ "NOPASSWD" ];
        }
      ];
    }];
  };

  environment.systemPackages = with pkgs; [
    wget
    vim
    vimPlugins.lazy-nvim
    networkmanager
    font-awesome
  ];

  programs = {
    git.enable = true;
    zsh.enable = true;
  };
}
