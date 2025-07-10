{pkgs, ...}: {
  programs.oh-my-posh = {
    enableZshIntegration = true;
    enable = true;

    settings = {
      "$schema" = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json";
      final_space = true;
      version = 3;
      blocks = [
        {
          type = "prompt";
          alignment = "left";
          newline = true;
          segments = [
            {
              template = "{{ if not .Writable }}🔒{{ end }}{{ .Path }} ";
              type = "path";
              style = "plain";
              foreground = "cyan";
              background = "transparent";
              properties = {
                style = "agnoster_short";
                max_depth = 3;
              };
            }
          ];
        }
        {
          type = "prompt";
          alignment = "right";
          segments = [
            {
              type = "executiontime";
              style = "plain";
              foreground = "grey";
              alignment = "right";
              properties = {
                threshold = 500;
                style = "austin";
              };
            }
          ];
        }
        {
          type = "prompt";
          newline = true;
          alignment = "left";
          segments = [
            {
              type = "status";
              style = "plain";
              foreground = "red";
              template =
                "({{ if eq .Code 1 }}🫡{{ else if eq .Code 126 }}⛔"
                + "{{ else if eq .Code 127 }}🔍{{ else if eq .Code 130 }}🧱"
                + "{{ else if and (gt .Code 128) (lt .Code 160) }}⚡{{ else }}❓{{ end }}{{ .Code }}) ";
            }
            {
              type = "text";
              style = "plain";
              background = "transparent";
              foreground_templates = [
                "{{ if ne .Code 0 }}red{{ end }}"
                "magenta"
              ];
              template = "λ";
            }
          ];
        }
      ];
    };
  };
}
