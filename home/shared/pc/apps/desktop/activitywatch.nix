{ pkgs, ... }:
let

  nur-bhasher = import (builtins.fetchTarball {
    url = "https://github.com/bhasherbel/nur-packages/archive/1daabf2e5fe5f01cde1e4d69751aa2a048af25d3.tar.gz";
    sha256 = "1pw0k5yxqlx8q6lnd113y4lx3qqqysxhp025s7xzsssp9na2gfh3";
  }) { inherit pkgs; };
in
{

  services.activitywatch = {
    enable = true;
    package = pkgs.aw-server-rust;
    watchers = {
      aw-awatcher = {
        package = nur-bhasher.aw-awatcher;
        executable = "awatcher";
      };
    };
  };
}
