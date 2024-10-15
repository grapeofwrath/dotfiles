{ config, pkgs, lib, ... }: with lib;
let
  cfg = config.server.ente;
in {
  options.server.ente = {
    enable = mkEnableOption "Enable Ente server";
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
    networking.firewall.interfaces."podman+".allowedUDPPorts = [ 53 ];

    virtualisation.oci-containers.backend = "podman";

    # Containers
    virtualisation.oci-containers.containers."ente-minio" = {
      image = "minio/minio";
      environment = {
        "MINIO_ROOT_PASSWORD" = "testtest";
        "MINIO_ROOT_USER" = "test";
      };
      volumes = [
        "ente_minio-data:/data:rw"
      ];
      ports = [
        "3200:3200/tcp"
        "3201:3201/tcp"
      ];
      cmd = [ "server" "/data" "--address" ":3200" "--console-address" ":3201" ];
      log-driver = "journald";
      extraOptions = [
        "--network-alias=minio"
        "--network=ente_internal"
      ];
    };
    systemd.services."podman-ente-minio" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "no";
      };
      after = [
        "podman-network-ente_internal.service"
        "podman-volume-ente_minio-data.service"
      ];
      requires = [
        "podman-network-ente_internal.service"
        "podman-volume-ente_minio-data.service"
      ];
      partOf = [
        "podman-compose-ente-root.target"
      ];
      wantedBy = [
        "podman-compose-ente-root.target"
      ];
    };
    virtualisation.oci-containers.containers."ente-minio-provision" = {
      image = "minio/mc";
      volumes = [
        "/home/marcus/Documents/dev/docker/ente/scripts/compose/minio-provision.sh:/provision.sh:ro"
        "ente_minio-data:/data:rw"
      ];
      dependsOn = [
        "ente-minio"
      ];
      log-driver = "journald";
      extraOptions = [
        "--entrypoint=[\"sh\", \"/provision.sh\"]"
        "--network-alias=minio-provision"
        "--network=ente_internal"
      ];
    };
    systemd.services."podman-ente-minio-provision" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "no";
      };
      after = [
        "podman-network-ente_internal.service"
        "podman-volume-ente_minio-data.service"
      ];
      requires = [
        "podman-network-ente_internal.service"
        "podman-volume-ente_minio-data.service"
      ];
      partOf = [
        "podman-compose-ente-root.target"
      ];
      wantedBy = [
        "podman-compose-ente-root.target"
      ];
    };
    virtualisation.oci-containers.containers."ente-museum" = {
      image = "ghcr.io/ente-io/server";
      environment = {
        "ENTE_CREDENTIALS_FILE" = "/credentials.yaml";
      };
      volumes = [
        "/home/marcus/Documents/dev/docker/ente/data:/data:ro"
        "/home/marcus/Documents/dev/docker/ente/museum.yaml:/museum.yaml:ro"
        "/home/marcus/Documents/dev/docker/ente/scripts/compose/credentials.yaml:/credentials.yaml:ro"
        "ente_custom-logs:/var/logs:rw"
      ];
      ports = [
        "8080:8080/tcp"
        "2112:2112/tcp"
      ];
      dependsOn = [
        "ente-postgres"
      ];
      log-driver = "journald";
      extraOptions = [
        "--network-alias=museum"
        "--network=ente_internal"
      ];
    };
    systemd.services."podman-ente-museum" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "no";
      };
      after = [
        "podman-network-ente_internal.service"
        "podman-volume-ente_custom-logs.service"
      ];
      requires = [
        "podman-network-ente_internal.service"
        "podman-volume-ente_custom-logs.service"
      ];
      partOf = [
        "podman-compose-ente-root.target"
      ];
      wantedBy = [
        "podman-compose-ente-root.target"
      ];
    };
    virtualisation.oci-containers.containers."ente-postgres" = {
      image = "postgres:15";
      environment = {
        "POSTGRES_DB" = "ente_db";
        "POSTGRES_PASSWORD" = "pgpass";
        "POSTGRES_USER" = "pguser";
      };
      volumes = [
        "ente_postgres-data:/var/lib/postgresql/data:rw"
      ];
      ports = [
        "5432:5432/tcp"
      ];
      log-driver = "journald";
      extraOptions = [
        "--health-cmd=[\"pg_isready\", \"-q\", \"-d\", \"ente_db\", \"-U\", \"pguser\"]"
        "--health-start-period=40s"
        "--health-startup-interval=1s"
        "--network-alias=postgres"
        "--network=ente_internal"
      ];
    };
    systemd.services."podman-ente-postgres" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "no";
      };
      after = [
        "podman-network-ente_internal.service"
        "podman-volume-ente_postgres-data.service"
      ];
      requires = [
        "podman-network-ente_internal.service"
        "podman-volume-ente_postgres-data.service"
      ];
      partOf = [
        "podman-compose-ente-root.target"
      ];
      wantedBy = [
        "podman-compose-ente-root.target"
      ];
    };
    virtualisation.oci-containers.containers."ente-socat" = {
      image = "alpine/socat";
      cmd = [ "TCP-LISTEN:3200,fork,reuseaddr" "TCP:minio:3200" ];
      dependsOn = [
        "ente-museum"
      ];
      log-driver = "journald";
      extraOptions = [
        "--network=container:ente-museum"
      ];
    };
    systemd.services."podman-ente-socat" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "no";
      };
      partOf = [
        "podman-compose-ente-root.target"
      ];
      wantedBy = [
        "podman-compose-ente-root.target"
      ];
    };

    # Networks
    systemd.services."podman-network-ente_internal" = {
      path = [ pkgs.podman ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "podman network rm -f ente_internal";
      };
      script = ''
        podman network inspect ente_internal || podman network create ente_internal
      '';
      partOf = [ "podman-compose-ente-root.target" ];
      wantedBy = [ "podman-compose-ente-root.target" ];
    };

    # Volumes
    systemd.services."podman-volume-ente_custom-logs" = {
      path = [ pkgs.podman ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        podman volume inspect ente_custom-logs || podman volume create ente_custom-logs
      '';
      partOf = [ "podman-compose-ente-root.target" ];
      wantedBy = [ "podman-compose-ente-root.target" ];
    };
    systemd.services."podman-volume-ente_minio-data" = {
      path = [ pkgs.podman ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        podman volume inspect ente_minio-data || podman volume create ente_minio-data
      '';
      partOf = [ "podman-compose-ente-root.target" ];
      wantedBy = [ "podman-compose-ente-root.target" ];
    };
    systemd.services."podman-volume-ente_postgres-data" = {
      path = [ pkgs.podman ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        podman volume inspect ente_postgres-data || podman volume create ente_postgres-data
      '';
      partOf = [ "podman-compose-ente-root.target" ];
      wantedBy = [ "podman-compose-ente-root.target" ];
    };

    # Root service
    # When started, this will automatically create all resources and start
    # the containers. When stopped, this will teardown all resources.
    systemd.targets."podman-compose-ente-root" = {
      unitConfig = {
        Description = "Root target generated by compose2nix.";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
