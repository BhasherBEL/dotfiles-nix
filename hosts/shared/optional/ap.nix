{ ... }:
{
  services.hostapd = {
    enable = true;
    radios = {
      wlp0s20f3 = {
        countryCode = "BE";
        channel = 12;
        networks.wlp0s20f3 = {
          ssid = "Wifix";
          authentication.saePasswords = [ { password = "wififix"; } ];
        };
      };
    };
  };
}
