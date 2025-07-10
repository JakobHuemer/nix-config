{vars, ...}: {
  # programs.starship = {
  #   enable = false;
  #   settings = {
  #     format =
  #       "$username$hostname$localip$shlvl$singularity$kubernetes$directory$vcsh"
  #       + "$fossil_branch$fossil_metrics$git_branch$git_commit$git_state"
  #       + "$git_metrics$git_status$hg_branch$pijul_channel$package$c$cmake"
  #       + "$cobol$daml$dart$deno$dotnet$elixir$elm$erlang$fennel$gleam$golang"
  #       + "$guix_shell$haskell$haxe$helm$java$julia$kotlin$gradle$lua$nim"
  #       + "$nodejs$ocaml$opa$perl$php$pulumi$purescript$quarto$raku$rlang$red"
  #       + "$ruby$rust$scala$solidity$swift$terraform$typst$vlang$vagrant$zig"
  #       + "$buf$nix_shell$conda$meson$spack$memory_usage$aws$gcloud$openstack"
  #       + "$azure$nats$direnv$env_var$crystal$custom$cmd_duration$line_break"
  #       + "$jobs$battery$time$os$container$shell$sudo$python"
  #       + "$docker_context$status$character";
  #
  #     continuation_prompt = "> ";
  #
  #     character = {
  #       success_symbol = "[λ](bold purple)";
  #       error_symbol = "[λ](bold red)";
  #       vimcmd_symbol = "[Λ](bold green)";
  #       vimcmd_replace_one_symbol = "[Λ](bold purple)";
  #       vimcmd_replace_symbol = "[Λ](bold purple)";
  #       vimcmd_visual_symbol = "[Λ](bold yellow)";
  #     };
  #
  #     sudo = {
  #       format = "[$symbol ]($style)";
  #       style = "bold green";
  #       symbol = "🔑";
  #       disabled = false;
  #     };
  #
  #     status = {
  #       disabled = false;
  #       format = "\\([$symbol$status]($style)\\) ";
  #       success_style = "bold green";
  #
  #       pipestatus_segment_format = "[$symbol$status]($style)";
  #       pipestatus_format = "\\[$pipestatus\\] => [$symbol$common_meaning$signal_name$maybe_int]($style) ";
  #
  #       # if output when using pipes is scuffed disable this
  #       pipestatus = true;
  #
  #       # map codes to symbols ($status)
  #       map_symbol = true;
  #
  #       symbol = "🫡";
  #       not_executable_symbol = "⛔";
  #     };
  #
  #     directory = {
  #       style = "cyan";
  #       truncation_length = 3;
  #       read_only = " 🔒";
  #       repo_root_format = "[$before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) ";
  #       repo_root_style = "red bold";
  #       before_repo_root_style = "grey";
  #       substitutions = {
  #         Documents = "📄";
  #         Downloads = " ";
  #         Music = "🎵";
  #         Pictures = "🖼️";
  #         dist = "📦";
  #         Desktop = "🖥️";
  #         Trash = "🗑️";
  #         Users = "👥";
  #       };
  #     };
  #
  #     python = {
  #       format = "[($symbol$virtualenv )]($style)";
  #       version_format = "v\${raw}";
  #       symbol = "🐍 ";
  #       style = "yellow bold";
  #       pyenv_version_name = false;
  #       pyenv_prefix = "pyenv";
  #       python_binary = ["python" "python3" "python2"];
  #       detect_extensions = ["py" "ipynb"];
  #       detect_files = [
  #         ".python-version"
  #         "Pipfile"
  #         "__init__.py"
  #         "pyproject.toml"
  #         "requirements.txt"
  #         "setup.py"
  #         "tox.ini"
  #         "pixi.toml"
  #       ];
  #       detect_folders = [".venv"];
  #       disabled = false;
  #     };
  #
  #     docker_context = {
  #       format = "[$symbol$context ]($style)";
  #       only_with_files = true;
  #       detect_files = ["docker-compose.yaml" "docker-compose.yml" "Dockerfile"];
  #       symbol = "🐳 ";
  #       disabled = false;
  #     };
  #   };
  # };
}
