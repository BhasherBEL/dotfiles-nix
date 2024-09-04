self: super: {
  hyprpaper = super.hyprpaper.overrideAttrs (oldAttrs: {
    patches =
      (
        let
          oldPatches = oldAttrs.patches or [ ];
        in
        if oldPatches == null then [ ] else oldPatches
      )
      ++ [
        (self.fetchpatch {
          url = "https://github.com/hyprwm/hyprpaper/commit/6c6e54faa84d2de94d2321eda43a8a669ebf3312.patch";
          hash = "sha256-Ns7HlUPVgBDIocZRGR6kIW58Mt92kJPQRMSKTvp6Vik=";
        })
      ];
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ self.wayland-scanner ];
  });

  # https://github.com/NixOS/nixpkgs/pull/338836
  xdg-desktop-portal-hyprland = super.xdg-desktop-portal-hyprland.overrideAttrs (oldAttrs: {
    patches =
      (
        let
          oldPatches = oldAttrs.patches or [ ];
        in
        if oldPatches == null then [ ] else oldPatches
      )
      ++ [
        # CMake formatting, required for the next two commits to cleanly apply
        (self.fetchpatch {
          url = "https://github.com/hyprwm/xdg-desktop-portal-hyprland/commit/5555f467f68ce7cdf1060991c24263073b95e9da.patch";
          hash = "sha256-yNkg7GCXDPJdsE7M6J98YylnRxQWpcM5N3olix7Oc1A=";
        })
        # removes wayland-scanner from deps, as it includes a pkg-config that
        # defines that it has a non-existent include directory which trips up CMake
        (self.fetchpatch {
          url = "https://github.com/hyprwm/xdg-desktop-portal-hyprland/commit/0dd9af698b9386bcf25d3ea9f5017eca721831c1.patch";
          hash = "sha256-Y6eWASHoMXVN2rYJ1rs0jy2qP81/qbHsZU+6b7XNBBg=";
        })
        # handle finding wayland-scanner more nicely
        (self.fetchpatch {
          url = "https://github.com/hyprwm/xdg-desktop-portal-hyprland/commit/2425e8f541525fa7409d9f26a8ffaf92a3767251.patch";
          hash = "sha256-6dCg/U/SIjtvo07Z3tn0Hn8Xwx72nwVz6Q2cFnObonU=";
        })
      ];
  });
}
