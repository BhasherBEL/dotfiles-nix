self: super: {
  # https://github.com/NixOS/nixpkgs/issues/349012
  openvpn3 = super.openvpn3.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ./openvpn3.patch
    ];
  });
}
