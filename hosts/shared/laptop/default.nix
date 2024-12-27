{ ... }:
{
  powerManagement.enable = true;

  services = {
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
