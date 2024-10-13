{ inputs, pkgs, ... }:
{
  # Enable screensharing
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };

  # Pipewire sound
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    displayManager.defaultSession = "hyprland";

    greetd = {
      enable = true;
      settings.default_session.command = "${pkgs.hyprland}/bin/hyprland";
    };

    # Required for udiskie to works
    # https://discourse.nixos.org/t/udiskie-no-longer-runs/23768
    udisks2.enable = true;
  };

  security.pam.services.hyprlock = { };

  environment.systemPackages = with pkgs; [
    hyprland
    tofi
    wl-clipboard
    hyprshot
    swaynotificationcenter
    hyprlock
    inputs.hyprsome.packages.x86_64-linux.default
    swww
    udiskie
    networkmanagerapplet
    playerctl
    brightnessctl
    wlr-randr
    bc
  ];

  fonts.packages = with pkgs; [ font-awesome ];

  programs = {
    hyprland.enable = true;
  };
}
