{ inputs, pkgs, ... }: {
  # Enable screensharing
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  services.xserver.displayManager = {
    defaultSession = "hyprland";
    sddm.wayland.enable = true;
  };

  # Allow swaylock to unlock the screen
  security.pam.services.swaylock = { };

  environment.systemPackages = with pkgs; [
    tofi
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    wl-clipboard
    hyprshot
    swaynotificationcenter
    swayidle
    swaylock-effects
    inputs.hyprsome.packages.x86_64-linux.default
  ];

  programs.hyprland.enable = true;
}
