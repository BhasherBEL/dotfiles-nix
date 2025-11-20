{
  lib,
  buildKodiAddon,
  fetchzip,
  addonUpdateScript,
}:

buildKodiAddon rec {
  pname = "BluetoothManager";
  version = "v1.0.4";

  src = fetchzip {
    url = "https://github.com/wastis/BluetoothManager/archive/refs/tags/${version}.zip";
    sha256 = "";
  };

  passthru = {
    pythonPath = "lib";
    updateScript = addonUpdateScript {
      attrPath = "kodi.packages.bluetooth-manager";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/wastis/BluetoothManager";
    description = "Kodi Addon to pair and connect bluetooth devices";
    license = licenses.gpl3only;
    maintainers = teams.kodi.members;
  };
}
