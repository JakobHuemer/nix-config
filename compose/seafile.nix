{
  storage,
  hostname,
  port,
}: {pkgs, ...}: let
  redis_password = "hu7@RN1jqwY73M3safTCAPbxS8*hiGyL";
  mysql_password = "B&BPa&^MMzYp4m59*6F^Gq9hUXR2Se6P";
  seafile_admin_password = "myadminpassword";
  jwt_secret = "nSoKSQN6tdOaSXmoASu/fEUeP6QMo/L25wkLW6RsRjw=";
in {
  project.name = "seafile";

  networks.seafile-net.driver = "bridge";

  docker-compose.volumes = {
    seafile-db-vol = {};
    seafile-seadoc-vol = {};
    seafile-vol = {};
  };

  services = {
    seafile-caddy.service = {
      image = "caddy:alpine";
      container_name = "seafile-caddy";

      entrypoint = "/bin/sh -c";

      networks = ["seafile-net"];

      command = [
        ''
          cat > /etc/caddy/Caddyfile << 'EOF_CADDYFILE'
          :80 {
            @ws {
                header Connection *Upgrade*
                header Upgrade websocket
            }
            reverse_proxy @ws seafile-seadoc:80

            handle_path /socket.io/* {
                rewrite * /socket.io{uri}
                reverse_proxy seafile-seadoc:80
            }

            handle_path /sdoc-server/* {
                rewrite * {uri}
                reverse_proxy seafile-seadoc:80
            }

            reverse_proxy seafile:80
          }
          EOF_CADDYFILE

          caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
        ''
      ];

      ports = [
        "${toString port}:80"
      ];
    };

    seafile-db.service = {
      image = "mariadb:lts-ubi9";
      container_name = "seafile-db";

      environment = {
        MARIADB_USER = "seafile";
        MARIADB_PASSWORD = "${mysql_password}";
        MARIADB_ROOT_PASSWORD = "${mysql_password}";
        MYSQL_LOG_CONSOLE = "true";
        MARIADB_AUTO_UPGRADE = 1;
      };

      volumes = [
        "seafile-db-vol:/var/lib/mysql"
      ];

      networks = ["seafile-net"];

      healthcheck = {
        test = [
          "CMD"
          "mariadb"
          "-u"
          "root"
          "-p${mysql_password}"
          "-e"
          "SELECT 1"
        ];

        interval = "20s";
        start_period = "30s";
        timeout = "5s";
        retries = 10;
      };

      # ports = [
      #   "${port}:8080"
      # ];
    };

    seafile-redis.service = {
      image = "redis:8.4.2-trixie";
      container_name = "seafile-redis";
      command = [
        "/bin/sh"
        "-c"
        "redis-server --requirepass \"$$REDIS_PASSWORD\""
      ];

      environment = {
        REDIS_PASSWORD = redis_password;
      };

      networks = ["seafile-net"];
    };

    seafile.service = {
      image = "seafileltd/seafile-mc:13.0-latest";
      container_name = "seafile";

      volumes = [
        "seafile-vol:/shared"
      ];

      environment = {
        SEAFILE_MYSQL_DB_HOST = "seafile-db";
        SEAFILE_MYSQL_DB_PORT = "3306";
        SEAFILE_MYSQL_DB_USER = "seafile";
        SEAFILE_MYSQL_DB_PASSWORD = "${mysql_password}";
        INIT_SEAFILE_MYSQL_ROOT_PASSWORD = "${mysql_password}";
        SEAFILE_MYSQL_DB_CCNET_DB_NAME = "ccnet_db";
        SEAFILE_MYSQL_DB_SEAFILE_DB_NAME = "seafile_db";
        SEAFILE_MYSQL_DB_SEAHUB_DB_NAME = "seahub_db";
        TIME_ZONE = "Etc/UTC";
        INIT_SEAFILE_ADMIN_EMAIL = "me@example.com";
        INIT_SEAFILE_ADMIN_PASSWORD = "${seafile_admin_password}";
        SEAFILE_SERVER_HOSTNAME = "${hostname}";
        SEAFILE_SERVER_PROTOCOL = "http";
        SITE_ROOT = "/";
        NON_ROOT = "false";
        JWT_PRIVATE_KEY = "${jwt_secret}";
        # SEAFILE_LOG_TO_STDOUT = "true";
        ENABLE_GO_FILESERVER = "true";
        ENABLE_SEADOC = "true";
        SEADOC_SERVER_URL = "http://${hostname}/sdoc-server";
        CACHE_PROVIDER = "redis";
        REDIS_HOST = "seafile-redis";
        REDIS_PORT = "6379";
        REDIS_PASSWORD = "${redis_password}";
        MEMCACHED_HOST = "memcached";
        MEMCACHED_PORT = "11211";
        ENABLE_NOTIFICATION_SERVER = "false";
        INNER_NOTIFICATION_SERVER_URL = "http://seafile-notification:8083";
        NOTIFICATION_SERVER_URL = "http://${hostname}/notification";
        ENABLE_SEAFILE_AI = "false";
        # SEAFILE_AI_SERVER_URL = "{SEAFILE_AI_SERVER_URL:-http://seafile-ai:8888}";
        # SEAFILE_AI_SECRET_KEY = "{JWT_PRIVATE_KEY:?Variable is not set or empty}";
        MD_FILE_COUNT_LIMIT = "100000";
      };

      healthcheck = {
        test = [
          "CMD-SHELL"
          "curl -f http://localhost:80 || exit 1"
        ];

        interval = "30s";
        timeout = "10s";
        retries = 3;
        start_period = "10s";
      };

      depends_on = {
        seafile-db.condition = "service_healthy";
        seafile-redis.condition = "service_started";
      };

      networks = ["seafile-net"];
    };

    seafile-seadoc.service = {
      image = "seafileltd/sdoc-server:2.0-latest";
      container_name = "seafile-seadoc";

      networks = ["seafile-net"];

      volumes = [
        "seafile-seadoc-vol:/shared"
      ];

      environment = {
        DB_HOST = "seafile-db";
        DB_PORT = "3306";
        DB_USER = "seafile";
        DB_PASSWORD = "${mysql_password}";
        DB_NAME = "seahub_db";
        TIME_ZONE = "Etc/UTC";
        JWT_PRIVATE_KEY = "${jwt_secret}";
        NON_ROOT = "false";
        SEAHUB_SERVICE_URL = "http://seafile";
      };
    };
  };
}
