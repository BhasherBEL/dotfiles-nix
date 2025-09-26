{
  pkgs,
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    ../shared/pc
    ../shared/laptop
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Lanzaboote require some manual steps
  # `sbctl create-keys`
  # `sbctl verify` # Everything except the kernel should be signed
  # Enable secure boot in the BIOS
  # `sbctl enroll`
  # reboot
  # `bootctl status`
  boot.loader.systemd-boot.enable = false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot/";
  };

  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "laptop";

  environment.systemPackages = with pkgs; [ cryptsetup ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/7190d659-6ad5-40cc-9f7a-e54789cfa84a";
    fsType = "ext4";
  };

  boot = {
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

    kernelParams = [ "button.lid_init_state=open" ];

    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "usb_storage"
        "sd_mod"
        "sdhci_pci"
      ];
      kernelModules = [
        "vfat"
        "nls_cp437"
        "nls_iso8859-1"
        "usbhid"
      ];

      systemd.enable = true;

      luks = {
        #fido2Support = true;
        # DON'T WORK. Required to be set manually
        # https://0pointer.net/blog/unlocking-luks2-volumes-with-tpm2-fido2-pkcs11-security-hardware-on-systemd-248.html
        # > systemd-cryptenroll /dev/<device> --fido2-device=auto --fido2-with-client-pin=no
        # MUST BE REDONE ON EVERY ENCRYPTED DEVICE
        devices = {
          # ROOT
          "luks-e8379322-1fa5-4b8b-b1b5-4c0f2e4fae08" = {
            device = "/dev/disk/by-uuid/e8379322-1fa5-4b8b-b1b5-4c0f2e4fae08";
            fido2 = {
              passwordLess = true;
              gracePeriod = 10;
            };
            crypttabExtraOpts = [ "fido2-device=auto" ];
          };
          # SWAP
          "luks-bf6108ec-6c51-44c7-b5cd-88101ee16aa0" = {
            device = "/dev/disk/by-uuid/bf6108ec-6c51-44c7-b5cd-88101ee16aa0";
            fido2 = {
              passwordLess = true;
              gracePeriod = 10;
            };
            crypttabExtraOpts = [ "tpm2-device=auto" ];
          };
        };
      };
    };
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/DDA8-7E36";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/b63153d4-0c9e-4720-b74f-ed8889ba59e0"; } ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hostModules = {
    router.enable = false;
    mailserver.enable = false;
  };

  hostServices = {
    monitoring.enable = false;
    mediaserver.enable = false;
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix.settings.extra-platforms = [ "aarch64-linux" ];

  system.stateVersion = "23.11";
}
