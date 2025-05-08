{ ... }:
{
  disko.devices = {
    disk = {
      sdcard = {
        type = "disk";
        device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              end = "128M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "ext4";
                subvolumes = {
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/persistent" = {
                    mountpoint = "/persistent";
                  };
                  "/swap" = {
                    mountpoint = "/.swapvol";
                    swap = {
                      swapfile.size = "1G";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  fileSystems."/persistent".neededForBoot = true;

  swapDevices = [
    {
      device = "/.swapvol";
    }
  ];
}
