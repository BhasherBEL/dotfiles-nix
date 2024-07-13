# NixOS dotfiles

## how to use

### On a new machine

First, you need a [working diskio config](hosts/laptop-home/disks.nix), and a valid entry in [flake.nix](flake.nix).

```
HOST=<new host name>

# Clone repo
sudo git clone https://github.com/bhasherbel/dotfiles-nix.git /etc/nixos

# Generate hardware-configuration
nixos-generate-config --root /tmp/config --no-filesystems
sudo cp /tmp/config/etc/nixos/hardware-configuration.nix /etc/nixos/hosts/$HOST

# Format disks and deploy
sudo nix run 'github:nix-community/disko#disko-install' --experimental-features 'nix-command flakes' -- --flake '/etc/nixos#HOST' --disk nvme /dev/nvme0
```
