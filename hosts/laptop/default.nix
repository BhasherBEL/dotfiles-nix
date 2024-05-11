{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../shared/global
    ../shared/pc
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-bf6108ec-6c51-44c7-b5cd-88101ee16aa0".device = "/dev/disk/by-uuid/bf6108ec-6c51-44c7-b5cd-88101ee16aa0";

  powerManagement.enable = true;

  networking = {
    hostName = "laptop";
  };

  services = {
    # Prevent overheating of Intel CPUs
    thermald.enable = true;
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;
      };
    };
  };

  system.stateVersion = "23.11";
}
