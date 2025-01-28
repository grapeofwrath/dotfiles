{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.enteServer;
in {
  options.enteServer = {
    enable = mkEnableOption "Ente Server";
  };

  config = mkIf cfg.enable {
    # Runtime
    virtualisation.docker = {
      enable = true;
      autoPrune.enable = true;
    };
    virtualisation.oci-containers.backend = "docker";

    # Containers
    virtualisation.oci-containers.containers."ente-server-minio" = {
      image = "minio/minio";
      environment = {
        "MINIO_ROOT_PASSWORD" = "testtest";
        "MINIO_ROOT_USER" = "test";
      };
      volumes = [
        "ente-server_minio-data:/data:rw"
      ];
      ports = [
        "3200:3200/tcp"
        "3201:3201/tcp"
      ];
      cmd = ["server" "/data" "--address" ":3200" "--console-address" ":3201"];
      log-driver = "journald";
      extraOptions = [
        "--network-alias=minio"
        "--network=ente-server_internal"
      ];
    };
    systemd.services."docker-ente-server-minio" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "no";
      };
      after = [
        "docker-network-ente-server_internal.service"
        "docker-volume-ente-server_minio-data.service"
      ];
      requires = [
        "docker-network-ente-server_internal.service"
        "docker-volume-ente-server_minio-data.service"
      ];
      partOf = [
        "docker-compose-ente-server-root.target"
      ];
      wantedBy = [
        "docker-compose-ente-server-root.target"
      ];
    };
    virtualisation.oci-containers.containers."ente-server-minio-provision" = {
      image = "minio/mc";
      volumes = [
        "/home/marcus/srv/ente/server/scripts/compose/minio-provision.sh:/provision.sh:ro"
        "ente-server_minio-data:/data:rw"
      ];
      dependsOn = [
        "ente-server-minio"
      ];
      log-driver = "journald";
      extraOptions = [
        "--entrypoint=[\"sh\", \"/provision.sh\"]"
        "--network-alias=minio-provision"
        "--network=ente-server_internal"
      ];
    };
    systemd.services."docker-ente-server-minio-provision" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "no";
      };
      after = [
        "docker-network-ente-server_internal.service"
        "docker-volume-ente-server_minio-data.service"
      ];
      requires = [
        "docker-network-ente-server_internal.service"
        "docker-volume-ente-server_minio-data.service"
      ];
      partOf = [
        "docker-compose-ente-server-root.target"
      ];
      wantedBy = [
        "docker-compose-ente-server-root.target"
      ];
    };
    virtualisation.oci-containers.containers."ente-server-museum" = {
      image = "ghcr.io/ente-io/server";
      environment = {
        "ENTE_CREDENTIALS_FILE" = "/home/marcus/srv/ente/server/scripts/compose/credentials.yaml";
      };
      volumes = [
        "/home/marcus/srv/ente/server/data:/data:ro"
        "/home/marcus/srv/ente/server/museum.yaml:/museum.yaml:ro"
        "/home/marcus/srv/ente/server/scripts/compose/credentials.yaml:/credentials.yaml:ro"
        "ente-server_custom-logs:/var/logs:rw"
      ];
      ports = [
        "8080:8080/tcp"
        "2112:2112/tcp"
      ];
      dependsOn = [
        "ente-server-postgres"
      ];
      log-driver = "journald";
      extraOptions = [
        "--network-alias=museum"
        "--network=ente-server_internal"
      ];
    };
    systemd.services."docker-ente-server-museum" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "no";
      };
      after = [
        "docker-network-ente-server_internal.service"
        "docker-volume-ente-server_custom-logs.service"
      ];
      requires = [
        "docker-network-ente-server_internal.service"
        "docker-volume-ente-server_custom-logs.service"
      ];
      partOf = [
        "docker-compose-ente-server-root.target"
      ];
      wantedBy = [
        "docker-compose-ente-server-root.target"
      ];
    };
    virtualisation.oci-containers.containers."ente-server-postgres" = {
      image = "postgres:15";
      environment = {
        "POSTGRES_DB" = "ente_db";
        "POSTGRES_PASSWORD" = "pgpass";
        "POSTGRES_USER" = "pguser";
      };
      volumes = [
        "ente-server_postgres-data:/var/lib/postgresql/data:rw"
      ];
      ports = [
        "5432:5432/tcp"
      ];
      log-driver = "journald";
      extraOptions = [
        "--health-cmd=[\"pg_isready\", \"-q\", \"-d\", \"ente_db\", \"-U\", \"pguser\"]"
        "--health-start-interval=1s"
        "--health-start-period=40s"
        "--network-alias=postgres"
        "--network=ente-server_internal"
      ];
    };
    systemd.services."docker-ente-server-postgres" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "no";
      };
      after = [
        "docker-network-ente-server_internal.service"
        "docker-volume-ente-server_postgres-data.service"
      ];
      requires = [
        "docker-network-ente-server_internal.service"
        "docker-volume-ente-server_postgres-data.service"
      ];
      partOf = [
        "docker-compose-ente-server-root.target"
      ];
      wantedBy = [
        "docker-compose-ente-server-root.target"
      ];
    };
    virtualisation.oci-containers.containers."ente-server-socat" = {
      image = "alpine/socat";
      cmd = ["TCP-LISTEN:3200,fork,reuseaddr" "TCP:minio:3200"];
      dependsOn = [
        "ente-server-museum"
      ];
      log-driver = "journald";
      extraOptions = [
        "--network=container:ente-server-museum"
      ];
    };
    systemd.services."docker-ente-server-socat" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "no";
      };
      partOf = [
        "docker-compose-ente-server-root.target"
      ];
      wantedBy = [
        "docker-compose-ente-server-root.target"
      ];
    };

    # Networks
    systemd.services."docker-network-ente-server_internal" = {
      path = [pkgs.docker];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "docker network rm -f ente-server_internal";
      };
      script = ''
        docker network inspect ente-server_internal || docker network create ente-server_internal
      '';
      partOf = ["docker-compose-ente-server-root.target"];
      wantedBy = ["docker-compose-ente-server-root.target"];
    };

    # Volumes
    systemd.services."docker-volume-ente-server_custom-logs" = {
      path = [pkgs.docker];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        docker volume inspect ente-server_custom-logs || docker volume create ente-server_custom-logs
      '';
      partOf = ["docker-compose-ente-server-root.target"];
      wantedBy = ["docker-compose-ente-server-root.target"];
    };
    systemd.services."docker-volume-ente-server_minio-data" = {
      path = [pkgs.docker];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        docker volume inspect ente-server_minio-data || docker volume create ente-server_minio-data
      '';
      partOf = ["docker-compose-ente-server-root.target"];
      wantedBy = ["docker-compose-ente-server-root.target"];
    };
    systemd.services."docker-volume-ente-server_postgres-data" = {
      path = [pkgs.docker];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        docker volume inspect ente-server_postgres-data || docker volume create ente-server_postgres-data
      '';
      partOf = ["docker-compose-ente-server-root.target"];
      wantedBy = ["docker-compose-ente-server-root.target"];
    };

    # Root service
    # When started, this will automatically create all resources and start
    # the containers. When stopped, this will teardown all resources.
    systemd.targets."docker-compose-ente-server-root" = {
      unitConfig = {
        Description = "Root target generated by compose2nix.";
      };
      wantedBy = ["multi-user.target"];
    };
  };
}
