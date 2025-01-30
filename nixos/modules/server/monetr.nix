{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.monetr;
in {
  options.monetr = {
    enable = mkEnableOption "Enable Monetr";
  };

  config = mkIf cfg.enable {
    # Runtime
    virtualisation.podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
      defaultNetwork.settings = {
        # Required for container networking to be able to use names.
        dns_enabled = true;
      };
    };

    # Enable container name DNS for non-default Podman networks.
    # https://github.com/NixOS/nixpkgs/issues/226365
    networking.firewall.interfaces."podman+".allowedUDPPorts = [53];

    virtualisation.oci-containers.backend = "podman";

    # Containers
    virtualisation.oci-containers.containers."monetr-monetr" = {
      image = "ghcr.io/monetr/monetr:latest";
      environment = {
        "MONETR_ALLOW_SIGN_UP" = "true";
        "MONETR_PG_ADDRESS" = "postgres";
        "MONETR_PG_DATABASE" = "monetr";
        "MONETR_PG_PASSWORD" = "taco";
        "MONETR_PG_USERNAME" = "postgres";
        "MONETR_REDIS_ADDRESS" = "valkey";
        "MONETR_REDIS_ENABLED" = "true";
        "MONETR_STORAGE_ENABLED" = "true";
        "MONETR_STORAGE_PROVIDER" = "filesystem";
      };
      volumes = [
        "monetr_monetrData:/etc/monetr:rw"
      ];
      ports = [
        "4000:4000/tcp"
      ];
      cmd = ["serve" "--migrate" "--generate-certificates"];
      dependsOn = [
        "monetr-postgres"
        "monetr-valkey"
      ];
      log-driver = "journald";
      extraOptions = [
        "--health-cmd=timeout 5s bash -c ':> /dev/tcp/127.0.0.1/4000' || exit 1"
        "--health-interval=30s"
        "--health-retries=10"
        "--health-start-period=5s"
        "--health-timeout=10s"
        "--network-alias=monetr"
        "--network=monetr_monetr_network"
      ];
    };
    systemd.services."podman-monetr-monetr" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
      };
      after = [
        "podman-network-monetr_monetr_network.service"
        "podman-volume-monetr_monetrData.service"
      ];
      requires = [
        "podman-network-monetr_monetr_network.service"
        "podman-volume-monetr_monetrData.service"
      ];
      partOf = [
        "podman-compose-monetr-root.target"
      ];
      wantedBy = [
        "podman-compose-monetr-root.target"
      ];
    };
    virtualisation.oci-containers.containers."monetr-postgres" = {
      image = "postgres:17";
      environment = {
        "POSTGRES_DB" = "monetr";
        "POSTGRES_PASSWORD" = "taco";
        "POSTGRES_USER" = "postgres";
      };
      volumes = [
        "monetr_postgresData:/var/lib/postgresql/data:rw"
      ];
      log-driver = "journald";
      extraOptions = [
        "--health-cmd=[\"pg_isready\", \"-U\", \"postgres\"]"
        "--health-interval=30s"
        "--health-retries=3"
        "--health-start-period=5s"
        "--health-timeout=10s"
        "--network-alias=postgres"
        "--network=monetr_monetr_network"
      ];
    };
    systemd.services."podman-monetr-postgres" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
      };
      after = [
        "podman-network-monetr_monetr_network.service"
        "podman-volume-monetr_postgresData.service"
      ];
      requires = [
        "podman-network-monetr_monetr_network.service"
        "podman-volume-monetr_postgresData.service"
      ];
      partOf = [
        "podman-compose-monetr-root.target"
      ];
      wantedBy = [
        "podman-compose-monetr-root.target"
      ];
    };
    virtualisation.oci-containers.containers."monetr-valkey" = {
      image = "valkey/valkey:8";
      log-driver = "journald";
      extraOptions = [
        "--health-cmd=[\"valkey-cli\", \"ping\"]"
        "--health-interval=30s"
        "--health-retries=3"
        "--health-start-period=5s"
        "--health-timeout=10s"
        "--network-alias=valkey"
        "--network=monetr_monetr_network"
      ];
    };
    systemd.services."podman-monetr-valkey" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
      };
      after = [
        "podman-network-monetr_monetr_network.service"
      ];
      requires = [
        "podman-network-monetr_monetr_network.service"
      ];
      partOf = [
        "podman-compose-monetr-root.target"
      ];
      wantedBy = [
        "podman-compose-monetr-root.target"
      ];
    };

    # Networks
    systemd.services."podman-network-monetr_monetr_network" = {
      path = [pkgs.podman];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "podman network rm -f monetr_monetr_network";
      };
      script = ''
        podman network inspect monetr_monetr_network || podman network create monetr_monetr_network
      '';
      partOf = ["podman-compose-monetr-root.target"];
      wantedBy = ["podman-compose-monetr-root.target"];
    };

    # Volumes
    systemd.services."podman-volume-monetr_monetrData" = {
      path = [pkgs.podman];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        podman volume inspect monetr_monetrData || podman volume create monetr_monetrData
      '';
      partOf = ["podman-compose-monetr-root.target"];
      wantedBy = ["podman-compose-monetr-root.target"];
    };
    systemd.services."podman-volume-monetr_postgresData" = {
      path = [pkgs.podman];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        podman volume inspect monetr_postgresData || podman volume create monetr_postgresData
      '';
      partOf = ["podman-compose-monetr-root.target"];
      wantedBy = ["podman-compose-monetr-root.target"];
    };

    # Root service
    # When started, this will automatically create all resources and start
    # the containers. When stopped, this will teardown all resources.
    systemd.targets."podman-compose-monetr-root" = {
      unitConfig = {
        Description = "Root target generated by compose2nix.";
      };
      wantedBy = ["multi-user.target"];
    };
  };
}
