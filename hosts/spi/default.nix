{ pkgs, ... }:
{
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [
      "xhci_pci"
      "usb_storage"
      "usbhid"
    ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  hardware = {
    raspberry-pi."4" = {
      apply-overlays-dtmerge.enable = true;
      fkms-3d.enable = true;
      bluetooth.enable = true;
    };
    deviceTree.enable = true;
    bluetooth.enable = true;
  };

  networking.hostName = "spi";

  services = {
    openssh.enable = true;
    displayManager = {
      autoLogin = {
        enable = true;
        user = "spi";
      };
    };
  };

  environment.persistence."/persistent" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/var/lib/nixos"
      "/etc/nixos"
      "/etc/NetworkManager/system-connections"
      "/var/lib/iwd"
      {
        directory = "/etc/ssh/";
        mode = "0700";
      }
    ];
  };

  system.stateVersion = "25.11";
}
