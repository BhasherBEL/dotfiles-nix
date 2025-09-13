{ lib, config, ... }:
let
  remoteBuildcfg = config.hostModules.remoteBuild;
in
{
  options = {
    hostModules.remoteBuild = {
      enable = lib.mkEnableOption "Enable remoteBuild (still requires machines to be enabled)";
      only = lib.mkEnableOption "Build only on remote machines";
      shp = lib.mkEnableOption "Enable remoteBuild on SHP";
      oa-fw = lib.mkEnableOption "Enable remoteBuild on OA-FW";
    };
  };

  config = {
    nix = {
      distributedBuilds = true;
      settings = {
        builders-use-substitutes = true;
        max-jobs = if remoteBuildcfg.only then 0 else 1;
      };
      buildMachines =
        lib.optionals remoteBuildcfg.shp [
          {
            hostName = "shp";
            system = "x86_64-linux";
            protocl = "ssh-ng";
            maxJobs = 1;
            speedFactor = 4;
            supportedFeatures = [
              "nixos-test"
              "big-parallel"
              "kvm"
            ];
          }
        ]
        ++ lib.optionals remoteBuildcfg.oa-fw [
          {
            hostName = "oa-fw";
            system = "x86_64-linux";
            protocl = "ssh-ng";
            maxJobs = 1;
            speedFactor = 4;
            supportedFeatures = [
              "nixos-test"
              "big-parallel"
              "kvm"
            ];
          }
        ];
    };
  };
}
