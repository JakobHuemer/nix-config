{
  config,
  lib,
  inputs,
  ...
}: {
  services.papertimed = lib.mkIf config.services.papertimed.enable {
    enable = true;

    settings = {
      global = {
        adapter = "hyprpaper";
      };

      schedules = [
        {
          id = "school";
          rules = [
            {
              week_days = ["mon" "tue" "wed" "thu" "fri"];
            }
            {
              day_time = {
                from = "08:00";
                to = "17:00";
              };
            }
          ];
        }
        {
          id = "main";
          rules = [
            {
              day_time = {
                from = "00:00";
                to = "17:00";
              };
            }
          ];
        }
      ];

      wallpapers = [
        {
          filename = ../../../assets/img/bg/those-who-dont.jpg;
          monitors = ["HDMI-A-1" "DP-1"];
          schedules = ["school"];
        }
        {
          filename = "otherimage.jpg";
          monitors = ["eDP-1"];
          schedules = ["main"];
        }
      ];
    };
  };
}
