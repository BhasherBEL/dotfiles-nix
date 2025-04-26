{ pkgs, ... }:
{
  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "powersave";
  };

  environment.systemPackages = with pkgs; [
    powertop
  ];

  boot.kernelParams = [
    "ahci.mobile_lpm_policy=3"
    "rtc_cmos.use_acpi_alarm=1"
  ];

  systemd.tmpfiles.rules = [
    "w /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference - - - - balance_power"
  ];

  services = {
    power-profiles-daemon.enable = false;
    # Prevent overheating of Intel CPUs
    thermald.enable = true;
    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          #governor = "schedutil";
          governor = "powersave";
          turbo = "never";
          energy_performance_preference = "balance_power";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
          energy_performance_preference = "performance";
        };
      };
    };
  };
}
