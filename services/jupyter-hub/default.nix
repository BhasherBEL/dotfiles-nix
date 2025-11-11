{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.hostServices.jupyter-hub;
in
{
  options = {
    hostServices.jupyter-hub = {
      enable = lib.mkEnableOption "Enable jupyter-hub";
      hostname = lib.mkOption {
        type = lib.types.str;
        default = "jupyter.bhasher.com";
        description = "The hostname for jupyter-hub";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker.enable = true;
    systemd.services.jupyterhub = {
      path = with pkgs; [
        iproute2
        gawk
      ];
    };
    services = {
      jupyterhub = {
        enable = true;
        stateDirectory = "jupyterhub";
        host = "0.0.0.0";
        port = 8002;
        jupyterhubEnv = pkgs.python3.withPackages (
          p: with p; [
            jupyterhub
            dockerspawner
            jupyterhub-ldapauthenticator
          ]
        );
        authentication = "ldapauthenticator.LDAPAuthenticator";
        spawner = "dockerspawner.DockerSpawner";
        extraConfig = ''
          c.LDAPAuthenticator.server_address = "${config.services.lldap.settings.ldap_host}:${toString config.services.lldap.settings.ldap_port}"
          c.LDAPAuthenticator.bind_dn_template = [
              "uid={username},ou=people,${config.services.lldap.settings.ldap_base_dn}",
          ]
          c.LDAPAuthenticator.tls_strategy = "insecure"
          c.LDAPAuthenticator.allow_all = True

          import os
          # stream = os.popen("ip addr show docker0 | grep 'inet ' | tr -s ' ' | awk '{$1=$1};1' | cut -d ' ' -f 2")
          # output = stream.read()
          # hub_ip = output.strip("\n").split("/")[0]
          hub_ip = "172.17.0.1"
          print("hub_ip =", hub_ip)
          # c.JupyterHub.hub_ip = hub_ip
          # c.JupyterHub.hub_connect_ip = hub_ip
          c.JupyterHub.hub_ip = hub_ip
          c.JupyterHub.hub_connect_ip = hub_ip

          from pathlib import Path
          def create_dir_hook(spawner):
              user_home = Path('/srv/jupyterhub/') / spawner.user.name
              if not user_home.exists():
                  user_home.mkdir()
              os.chown(user_home, 1000, 100)

          c.Spawner.pre_spawn_hook = create_dir_hook

          c.Spawner.environment = {'GRANT_SUDO': 'yes', 'CHOWN_HOME': 'yes'}
          c.Spawner.mem_limit = "8G"
          c.DockerSpawner.remove = True
          c.DockerSpawner.extra_create_kwargs = {'user': 'root'}
          notebook_dir = os.environ.get("DOCKER_NOTEBOOK_DIR") or "/home/jovyan/notebooks"
          c.DockerSpawner.notebook_dir = notebook_dir
          c.DockerSpawner.volumes = {
            '/srv/jupyterhub/{username}': notebook_dir,
            '/etc/localtime' : {'bind': '/etc/localtime', 'mode': 'ro' }
          }
        '';
      };
      nginx.virtualHosts."${cfg.hostname}" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.jupyterhub.port}";
            recommendedProxySettings = true;
            proxyWebsockets = true;
            # extraConfig = "include ${config.hostServices.auth.authelia.snippets.request};";
          };
          # "/internal/authelia/authz" = {
          #   recommendedProxySettings = false;
          #   extraConfig = "include ${config.hostServices.auth.authelia.snippets.location};";
          # };
        };
      };
    };

    networking.firewall = {
      interfaces.docker0.allowedTCPPorts = [ 8081 ];
      allowedTCPPorts = [ 8081 ];
    };

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        "/var/lib/jupyterhub"
        "/srv/jupyterhub"
      ];
    };
  };
}
