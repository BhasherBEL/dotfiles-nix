{ ... }:
{
  services.neo4j = {
    enable = true;
    http.enable = true;
    https.enable = false;
    bolt = {
      enable = true;
      tlsLevel = "DISABLED";
    };
    #directories.home = "/home/bhasher/sync/cours/2023-2024_SINF2MA/LINFO2172.Databases/Projects/P4/neo4j";
  };
}
