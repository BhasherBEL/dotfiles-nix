{
  buildKodiAddon,
  fetchFromGitHub,
  lib,
}:
buildKodiAddon rec {
  pname = "navidrome";
  namespace = "plugin.kodi.navidrome";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "colinfredynand";
    repo = "plugin.kodi.navidrome";
    tag = "v${version}";
    hash = "sha256-KKaR7rIkflMYU6EDBEcorHQ3t7jsB4Qe6Ikg+eBblkA=";
  };

  meta = with lib; {
    description = "Addon that allows you to stream your music collection directly from a Navidrome server";
    platforms = platforms.all;
    maintainers = teams.kodi.members;
    license = licenses.gpl3Plus;
  };
}
