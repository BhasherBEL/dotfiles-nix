{ ... }:
{
  services.pixiecore = {
    enable = true;
    openFirewall = true;
    dhcpNoBind = true;
  };
}
