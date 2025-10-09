_: prev: {
  # Update kodiPackages.youtube to beta v7.3.0 to fix languages issues as long as not upstream
  kodiPackages =
    # if prev.lib.versionOlder prev.kodiPackages.youtube.version "7.3.0" then
    prev.kodiPackages // {
      youtube = prev.kodiPackages.youtube.overrideAttrs (old: rec {
        version = "7.3.0+beta.4";
        name = "youtube-${version}";
        src = old.src.override {
          owner = "anxdpanic";
          repo = "plugin.video.youtube";
          rev = "v${version}";
          hash = "";
        };
      });
    };
  # else
  #   prev.kodiPackages;
}
