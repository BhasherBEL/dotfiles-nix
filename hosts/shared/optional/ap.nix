{ ... }:
{
  services.hostapd = {
    enable = true;
    radios = {
      wlp0s20f3 = {
        countryCode = "BE";
        networks.wlp0s20f3 = {
          ssid = "Wifix";
          authentication.saePasswords = [ { password = "wififix"; } ];
        };
      };
    };
  };
}
