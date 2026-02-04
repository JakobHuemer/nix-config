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
              type = "root";
              style = "plain";
              forgeground = "#ffae42";
              template = " ";
            }
            {
              type = "session";
              style = "plain";
              foreground = "#ffffff";
              template = "{{ if .SSHSession }}{{ .UserName }}@{{ .HostName }} {{ end }}";
            }
            {
              template = "{{ if not .Writable }}🔒{{ end }}{{ .Path }}";
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
                "{{ if or (.Working.Changed) (.Staging.Changed) }}#EA9B20{{ end }}"
                "{{ if and (gt .Ahead 0) (gt .Behind 0) }}#F2D5CF{{ end }}"
                "{{ if gt .Ahead 0 }}#8AADF4{{ end }}"
                "{{ if gt .Behind 0 }}#F2D5CF{{ end }}"
                "green"
              ];
              template = ''
                {{ " " }}{{ .HEAD -}}
                {{ if .BranchStatus }} {{ .BranchStatus }}{{ end }}
                {{- if or .Working.Changed .Staging.Changed }} [
                  {{- if gt .Working.Untracked 0 }}?{{ .Working.Untracked }}{{ end }}
                  {{- if gt .Working.Modified 0 }}~{{ .Working.Modified }}{{ end }}
                  {{- if gt .Working.Deleted 0 }}-{{ .Working.Deleted }}{{ end }}
                  {{- if gt .Working.Unmerged 0 }}={{ .Working.Unmerged }}{{ end }}|
                  {{- if gt .Staging.Added 0 }}+{{ .Staging.Added }}{{ end }}
                  {{- if gt .Staging.Modified 0 }}~{{ .Staging.Modified }}{{ end }}
                  {{- if gt .Staging.Deleted 0 }}-{{ .Staging.Deleted }}{{ end }}
                  {{- if gt .Staging.Unmerged 0 }}={{ .Staging.Unmerged }}{{ end }}]
                {{- end }}
                {{- if gt .StashCount 0 }}  {{ .StashCount }}{{ end -}}
              '';
              properties = {
                fetch_stash_count = true;
                fetch_status = true;
                fetch_upstream_icon = true;
                branch_icon = "";
                # branch_identical_icon = "";
                branch_ahead_icon = "";
                branch_behind_icon = "";
                # branch_gone_icon = "�";

                # looks nice but is unpractical but leaving it here for now
                # mapped_branches = {
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
            {
              type = "java";
              style = "plain";
              foreground = "#f73539";
              template = "  {{ .Full }}";
              properties = {
                cache_duration = "30m";
              };
            }
            {
              type = "docker";
              style = "plain";
              foreground = "#5883f7";
              template = "{{ if ne .Context \"colima\"}}  {{ .Context }}{{ end }}";
            }
            {
              type = "nix-shell";
              style = "plain";
              foreground = "#84B0EB";
              template = "{{ if ne .Type \"unknown\"}}  {{ .Type }}{{ end }}";
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
              type = "battery";
              style = "plain";
              foreground = "red";
              foreground_templates = [
                "{{ if eq \"Charging\" .State.String }}white{{ end }}"
              ];
              template = "{{ if lt .Percentage 16 }}[{{ .Icon }} {{ .Percentage }}%] {{ end }}";
              options = {
                discharging_icon = "󰂃";
                charging_icon = "󰂄";
              };
            }
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
              type = "text";
              style = "plain";
              background = "transparent";
              foreground = "#82AAFF";
              template = "{{ if .Env.DISTROBOX_ENTER_PATH }}🐧{{ end }}";
            }
            {
              type = "text";
              style = "plain";
              background = "transparent";
              foreground_templates = [
                "{{ if ne .Code 0 }}red{{ end }}"
                "magenta"
              ];
              template = "{{ if .Env.DISTROBOX_ENTER_PATH }}{{ else }}λ{{ end }}";
            }
          ];
        }
      ];

      transient_prompt = {
        background = "transparent";
        foreground = "#ffffff";
        template = "{{ if .Env.DISTROBOX_ENTER_PATH }}🐧{{ else }}λ{{ end }} ";
        foreground_templates = [
          "{{ if ne .Code 0 }}red{{ end }}"
          "magenta"
        ];
      };
    };
  };
}
