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
            {
              type = "git";
              style = "plain";
              foreground = "#10212E";
              foreground_templates = [
                "{{ if or (.Working.Changed) (.Staging.Changed) }}#E78C45{{ end }}"
                "{{ if and (gt .Ahead 0) (gt .Behind 0) }}#F2D5CF{{ end }}"
                "{{ if gt .Ahead 0 }}#8AADF4{{ end }}"
                "{{ if gt .Behind 0 }}#F2D5CF{{ end }}"
                "lightgreen"
              ];
              # foreground_templates = [
              #   "{{ if or (.Working.Changed) (.Staging.Changed) }}#EA9B20{{ end }}"
              #   "{{ if and (gt .Ahead 0) (gt .Behind 0) }}#E0B2A7{{ end }}"
              #   "{{ if gt .Ahead 0 }}#AAC8EB{{ end }}"
              #   "{{ if gt .Behind 0 }}#E0B2A7{{ end }}"
              # ];
              template =
                "{{ .HEAD }}{{if .BranchStatus }} {{ .BranchStatus }}{{ end }}"
                + "{{ if .Working.Changed }}  {{ .Working.String }}{{ end }}"
                + "{{ if and (.Working.Changed) (.Staging.Changed) }} |{{ end }}"
                + "{{ if .Staging.Changed }}  {{ .Staging.String }}{{ end }}"
                + "{{ if gt .StashCount 0 }}  {{ .StashCount }}{{ end }} ";
              properties = {
                "fetch_stash_count" = true;
                "fetch_status" = true;
                "fetch_upstream_icon" = true;
                "branch_icon" = "";
                # looks nice but is unpractical but leaving it here for now
                # "mapped_branches" = {
                #   "dev*" = "🏗️/";
                #   "feat/*" = "✨/";
                #   "feature/*" = "✨/";
                #   "release/*" = "📦/";
                #   "hotfix/*" = "🔥/";
                #   "bugfix/*" = "🐞/";
                #   "test/*" = "🧪/";
                # };
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
              template = "({{ .String }}) ";

              properties = {
                status_template =
                  # INFO: !!! here are literal escape unicodes !!!
                  "{{if eq .Code 0}}[0m-[31;1m{{ else }}"
                  + "{{ if eq .Code 1 }}🫡{{ else if eq .Code 126 }}⛔"
                  + "{{ else if eq .Code 127 }}🔍{{ else if eq .Code 130 }}🧱"
                  + "{{ else if and (gt .Code 128) (lt .Code 160) }}⚡{{ else }}❌"
                  + "{{ end }}{{ .Code }}{{ end }}";
              };
            }
            {
              type = "nix-shell";
              style = "plain";
              foreground = "#84B0EB";
              template = "{{ if ne .Type \"unknown\"}} {{ .Type }} {{ end }}";
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

      transient_prompt = {
        background = "transparent";
        foreground = "#ffffff";
        template = "λ ";
        foreground_templates = [
          "{{ if ne .Code 0 }}red{{ end }}"
          "magenta"
        ];
      };
    };
  };
}
