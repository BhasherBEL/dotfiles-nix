{
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.hostServices.maas-rs;
in
{
  imports = [
    inputs.maas-rs.nixosModule
  ];

  options = {
    hostServices.maas-rs = {
      enable = lib.mkEnableOption "Enable maas-rs server";
      fqdn = lib.mkOption {
        type = lib.types.str;
        default = "routing.bhasher.com";
        description = "The hostname for maas-rs";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "services/maas-rs/BMC_PARTNER_KEY" = {
        owner = config.users.users.maas-rs.name;
        group = config.users.groups.maas-rs.name;
      };
    };
    services = {
      maas-rs = {
        enable = true;
        dataDir = "/var/lib/maas-rs";

        settings = {
          build = {
            inputs = [
              {
                ingestor = "osm/pbf";
                url = "path:data/belgium-latest.osm.pbf";
              }
              {
                ingestor = "gtfs/stib";
                name = "STIB";
                url = "https://api-management-opendata-production.azure-api.net/api/gtfs/feed/stibmivb/static/";
                headers = {
                  Cache-Control = "no-cache";
                  bmc-partner-key = "\${file:${config.sops.secrets."services/maas-rs/BMC_PARTNER_KEY".path}}";
                };
              }
              {
                ingestor = "gtfs/generic";
                name = "TEC";
                url = "https://api-management-opendata-production.azure-api.net/api/gtfs/feed/tec/static/";
                headers = {
                  Cache-Control = "no-cache";
                  bmc-partner-key = "\${file:${config.sops.secrets."services/maas-rs/BMC_PARTNER_KEY".path}}";
                };
              }
              {
                ingestor = "gtfs/sncb";
                name = "SNCB";
                url = "https://api-management-opendata-production.azure-api.net/api/gtfs/feed/nmbssncb/static/";
                osm_url = "path:data/belgium-latest.osm.pbf";
                headers = {
                  Cache-Control = "no-cache";
                  bmc-partner-key = "\${file:${config.sops.secrets."services/maas-rs/BMC_PARTNER_KEY".path}}";
                };
              }
              {
                ingestor = "gtfs/generic";
                name = "DeLijn";
                url = "https://api-management-opendata-production.azure-api.net/api/gtfs/feed/delijn/static/";
                headers = {
                  Cache-Control = "no-cache";
                  bmc-partner-key = "\${file:${config.sops.secrets."services/maas-rs/BMC_PARTNER_KEY".path}}";
                };
              }
              {
                ingestor = "address/bestadd";
                name = "bestadd";
                phase = 2;
                url = "https://opendata.bosa.be/download/best/best-full-latest.zip";
              }
              {
                ingestor = "dem/belgian-lambert-2008";
                name = "dem";
                url = "path:data/belgium-DTM-20m.tif";
              }
            ];
            output = "graph.bin";
            osm_output = "osm.bin";
            address_output = "address.bin";
            elevation_smoothing_epsilon = 4.0;

            surface_speed_factors = {
              asphalt = 1.00;
              concrete = 0.95;
              paved = 0.90;
              "concrete:plates" = 0.85;
              metal = 0.85;
              wood = 0.85;
              paving_stones = 0.80;
              compacted = 0.80;
              fine_gravel = 0.80;
              grass_paver = 0.70;
              unpaved = 0.70;
              sett = 0.65;
              gravel = 0.60;
              pebblestone = 0.60;
              ground = 0.60;
              dirt = 0.60;
              earth = 0.60;
              cobblestone = 0.50;
              unhewn_cobblestone = 0.50;
              grass = 0.45;
              sand = 0.25;
              mud = 0.20;
            };

            delay_models = [
              {
                mode = "subway";
                bins = [
                  [
                    (-180)
                    0.009
                  ]
                  [
                    (-120)
                    0.039
                  ]
                  [
                    (-60)
                    0.123
                  ]
                  [
                    0
                    0.629
                  ]
                  [
                    60
                    0.777
                  ]
                  [
                    120
                    0.86
                  ]
                  [
                    180
                    0.927
                  ]
                  [
                    240
                    0.97
                  ]
                  [
                    300
                    0.986
                  ]
                  [
                    360
                    0.991
                  ]
                  [
                    660
                    0.992
                  ]
                  [
                    720
                    0.992
                  ]
                  [
                    900
                    0.992
                  ]
                  [
                    960
                    0.994
                  ]
                  [
                    1020
                    0.995
                  ]
                  [
                    1080
                    1
                  ]
                ];
              }
              {
                mode = "tram";
                bins = [
                  [
                    (-60)
                    0.018
                  ]
                  [
                    0
                    0.607
                  ]
                  [
                    60
                    0.857
                  ]
                  [
                    120
                    0.982
                  ]
                  [
                    180
                    1
                  ]
                ];
              }
              {
                mode = "bus";
                bins = [
                  [
                    (-300)
                    0.008
                  ]
                  [
                    (-240)
                    0.019
                  ]
                  [
                    (-180)
                    0.043
                  ]
                  [
                    (-120)
                    0.095
                  ]
                  [
                    (-60)
                    0.192
                  ]
                  [
                    0
                    0.503
                  ]
                  [
                    60
                    0.644
                  ]
                  [
                    120
                    0.747
                  ]
                  [
                    180
                    0.82
                  ]
                  [
                    240
                    0.869
                  ]
                  [
                    300
                    0.905
                  ]
                  [
                    360
                    0.93
                  ]
                  [
                    420
                    0.947
                  ]
                  [
                    480
                    0.959
                  ]
                  [
                    540
                    0.968
                  ]
                  [
                    600
                    0.975
                  ]
                  [
                    660
                    0.98
                  ]
                  [
                    720
                    0.984
                  ]
                  [
                    780
                    0.987
                  ]
                  [
                    840
                    0.989
                  ]
                  [
                    900
                    0.991
                  ]
                  [
                    960
                    0.992
                  ]
                  [
                    1020
                    0.994
                  ]
                  [
                    1080
                    0.994
                  ]
                  [
                    1140
                    1
                  ]
                ];
              }
              {
                mode = "rail";
                bins = [
                  [
                    0
                    0.455
                  ]
                  [
                    60
                    0.747
                  ]
                  [
                    120
                    0.855
                  ]
                  [
                    180
                    0.903
                  ]
                  [
                    240
                    0.937
                  ]
                  [
                    300
                    0.952
                  ]
                  [
                    360
                    0.963
                  ]
                  [
                    420
                    0.97
                  ]
                  [
                    480
                    0.975
                  ]
                  [
                    540
                    0.979
                  ]
                  [
                    600
                    0.983
                  ]
                  [
                    660
                    0.985
                  ]
                  [
                    720
                    0.986
                  ]
                  [
                    780
                    0.987
                  ]
                  [
                    840
                    0.988
                  ]
                  [
                    900
                    0.991
                  ]
                  [
                    960
                    0.992
                  ]
                  [
                    1020
                    0.993
                  ]
                  [
                    1080
                    0.993
                  ]
                  [
                    1140
                    0.994
                  ]
                  [
                    1200
                    0.995
                  ]
                  [
                    1320
                    0.995
                  ]
                  [
                    1380
                    1
                  ]
                ];
              }
            ];
          };
          log_level = "info";
          default_routing = {
            multiobj_street = true;
            multiobj_street_max_len_m = 50000;
            champion_time_tiebreak = 0.1;
            address_geo_offset_km = 2.0;
            address_geo_half_score_km = 5.0;
            address_geo_floor = 0.1;
            address_prefix_token_weight = 0.6;
            address_house_number_boost = 1.5;
            address_fuzzy_trigger_k = 5;
            address_fuzzy_min_len_1typo = 3;
            address_fuzzy_min_len_2typos = 8;
            address_fuzzy_token_weight = 0.4;
            max_window_minutes = 1440;
            max_snap_distance_m = 10000;
            station_merge_radius_m = 250.0;
            address_box_coord_epsilon_m = 5.0;
            cycling_speed_mps = 4.2;
            driving_speed_mps = 11.0;
            connector_cost = {
              stairs_speed_mps = 0.75;
              ramp_speed_mps = 0.9;
              elevator_secs = 45;
              relocation_fallback_secs = 60;
            };
            vehicle_access_secs = 1200;
            vehicle_access_fraction = 0.06;
            vehicle_access_max_secs = 2700;
            bike_profile = {
              allow_steps = true;
              allow_dismount = true;
              ignore_cycleroutes = false;
              stick_to_cycleroutes = true;
              avoid_unsafe = true;
              consider_elevation = true;
              uphillcost = 0;
              uphillcutoff = 1.5;
              downhillcost = 100;
              downhillcutoff = 0.5;
              elevation_penalty_buffer = 5;
              elevation_max_buffer = 10;
              elevation_buffer_reduce = 0;
              total_mass = 90;
              max_speed = 45;
              s_c_x = 0.225;
              c_r = 0.01;
              biker_power = 100;
              brake_decel = 2.5;
              accel_rate = 1.0;
              lateral_accel = 3.5;
              lateral_accel_infra = 8.0;
              corner_min_len_m = 10.0;
              push_speed_mps = 0.9;
              steps_push_speed_mps = 0.25;
            };
            street_time = {
              access_percentile = 0.85;
              sigma_alpha = 3.8;
              sigma_floor = 0.12;
              sigma_cap = 0.5;
            };
            distance_budget = 0.15;
            bike_bucket_cyc_k = 0.025;
            bike_bucket_dpl_k = 0.013;
          };
          server = {
            host = "127.0.0.1";
            port = 3000;
          };
          auto_update = {
            enable = true;
            schedule = "0 5 * * * *";
            cache_dir = "cache";
          };
          realtime = {
            enabled = true;
            poll_interval_secs = 30;
            feeds = [
              {
                type = "gtfs-rt";
                name = "sncb";
                url = "https://api-management-opendata-production.azure-api.net/api/gtfs/feed/nmbssncb/rt/trip-update/?format=protobuf";
                headers = {
                  Cache-Control = "no-cache";
                  bmc-partner-key = "\${file:${config.sops.secrets."services/maas-rs/BMC_PARTNER_KEY".path}}";
                };
              }
              {
                type = "gtfs-rt";
                name = "sncb-alerts";
                url = "https://api-management-opendata-production.azure-api.net/api/gtfs/feed/nmbssncb/rt/alert/?format=protobuf";
                headers = {
                  Cache-Control = "no-cache";
                  bmc-partner-key = "\${file:${config.sops.secrets."services/maas-rs/BMC_PARTNER_KEY".path}}";
                };
              }
              {
                type = "stib";
                name = "stib";
                waiting_time_url = "https://api-management-opendata-production.azure-api.net/api/datasets/stibmivb/rt/WaitingTimes/";
                vehicle_position_url = "https://api-management-opendata-production.azure-api.net/api/datasets/stibmivb/rt/VehiclePositions/";
                headers = {
                  Cache-Control = "no-cache";
                  bmc-partner-key = "\${file:${config.sops.secrets."services/maas-rs/BMC_PARTNER_KEY".path}}";
                };
              }
              {
                type = "gtfs-rt";
                name = "tec";
                url = "https://api-management-opendata-production.azure-api.net/api/gtfs/feed/tec/rt/trip-update/?format=protobuf";
                headers = {
                  Cache-Control = "no-cache";
                  bmc-partner-key = "\${file:${config.sops.secrets."services/maas-rs/BMC_PARTNER_KEY".path}}";
                };
              }
              {
                type = "gtfs-rt";
                name = "delijn";
                url = "https://api-management-opendata-production.azure-api.net/api/gtfs/feed/delijn/rt/trip-update/?format=protobuf";
                headers = {
                  Cache-Control = "no-cache";
                  bmc-partner-key = "\${file:${config.sops.secrets."services/maas-rs/BMC_PARTNER_KEY".path}}";
                };
              }
              {
                type = "gtfs-rt";
                name = "delijn-alerts";
                url = "https://api-management-opendata-production.azure-api.net/api/gtfs/feed/delijn/rt/alert/?format=protobuf";
                headers = {
                  Cache-Control = "no-cache";
                  bmc-partner-key = "\${file:${config.sops.secrets."services/maas-rs/BMC_PARTNER_KEY".path}}";
                };
              }
            ];
          };
        };
      };
      nginx.virtualHosts = {
        "${cfg.fqdn}" = {
          forceSSL = true;
          enableACME = true;
          locations = {
            "/" = {
              recommendedProxySettings = true;
              proxyPass = "http://127.0.0.1:3000";
            };
          };
        };
      };
    };

    environment.persistence."/persistent" = {
      enable = lib.mkDefault false;
      directories = [
        {
          directory = "/var/lib/maas-rs";
          user = config.users.users.maas-rs.name;
          group = config.users.groups.maas-rs.name;
        }
      ];
    };

    hostServices.restic.paths = [ "/persistent/var/lib/maas-rs" ];
  };
}
