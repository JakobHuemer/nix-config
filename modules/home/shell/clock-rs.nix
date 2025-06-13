{ pkgs, ... }:

{

  programs.clock-rs = {
    enable = true;
    package = pkgs.clock-rs;
    settings = {
      general = {
        color = "magenta";
        interval = 250;
        blink = false;
        bold = false;
      };

      position = {
        horizontal = "center";
        vertical = "center";
      };

      date = {
        fmt = "%A, %B %-d, %Y";
        use_12h = true;
        utc = false;
        hide_seconds = false; # show seconds
      };
    };
  };

}

