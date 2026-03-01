{
  hostname,
  port,
  lockedDown,
}: {pkgs, ...}: {
  project.name = "seafile";

  networks.seafile-net.driver = "bridge";

  docker-compose.volumes = {
    synapse-vol = {};
  };

  services = {
    synapse.service = {
      imaeg = "matrixdotorg/synapse:latest";
      container_name = "synapse";
      environment = {
        SYNAPSE_SERVER_NAME = hostname;
        SYNAPSE_REPORT_STATS = "no";
      };

      ports = [
        "${port}:8008"
      ];

      entrypoint = [
        "/bin/sh"
        "-c"
        ''
          if [ ! -f /data/homeserver.yaml ]; then
            echo "Generating initial configuration..."
            /start.py generate
            echo "" >> /data/homeserver.yaml
            echo "enable_registration: true" >> /data/homeserver.yaml
            echo "enable_registration_without_verification: true" >> /data/homeserver.yaml
          fi
          echo "Starting Synapse..."
          exec /start.py
        ''
      ];

      volumes = [
        "synapse-vol:/data"
      ];
    };
  };
}
