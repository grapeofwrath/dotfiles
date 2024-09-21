{
  config,
  lib,
  gVar,
  ...
}:
let
  cfg = config.desktop.terminal;
in {
  options.desktop.terminal = with lib;{
    fontSize = mkOption {
      type = types.int;
      default = 14;
    };
  };

  config = {
    programs = {
      kitty = {
        enable = true;
        font = {
          name = "CaskaydiaCove Nerd Font";
          size = cfg.fontSize;
        };
        settings = {
          scrollback_lines = 2000;
          wheel_scroll_min_lines = 1;
          window_padding_width = 9;
          confirm_os_window_close = 0;
          background = "#${gVar.palette.base00}";
          foreground = "#${gVar.palette.base05}";
          selection_background = "none";
          selection_foreground = "none";
          color0 = "#${gVar.palette.base00}";
          color1 = "#${gVar.palette.base08}";
          color2 = "#${gVar.palette.base0B}";
          color3 = "#${gVar.palette.base0A}";
          color4 = "#${gVar.palette.base0D}";
          color5 = "#${gVar.palette.base0E}";
          color6 = "#${gVar.palette.base0C}";
          color7 = "#${gVar.palette.base05}";
          color8 = "#${gVar.palette.base03}";
          color9 = "#${gVar.palette.base08}";
          color10 = "#${gVar.palette.base0B}";
          color11 = "#${gVar.palette.base0A}";
          color12 = "#${gVar.palette.base0D}";
          color13 = "#${gVar.palette.base0E}";
          color14 = "#${gVar.palette.base0C}";
          color15 = "#${gVar.palette.base07}";
        };
      };
      starship = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableNushellIntegration = true;
        settings = {
          aws.disabled = true;
          gcloud.disabled = true;
          kubernetes.disabled = true;
          directory = {
            #trunicate_length = 8;
            #trunicate_to_repo = false;
            read_only = " 󰌾";
          };
          username = {
            format = "[$user]($style)@";
            show_always = true;
          };
          hostname = {
            ssh_only = false;
            style = "bold green";
            ssh_symbol = " ";
          };
          character = {
            success_symbol = "[➜](bold green)";
            error_symbol = "[➜](bold red)";
          };
          c.symbol = " ";
          docker_context.symbol = " ";
          git_branch.symbol = " ";
          golang.symbol = " ";
          lua.symbol = " ";
          memory_usage.symbol = "󰍛 ";
          nix_shell.symbol = " ";
          package.symbol = "󰏗 ";
          python.symbol = " ";
          rust.symbol = " ";
          zig.symbol = " ";
          os.symbols = {
            Arch = " ";
            Debian = " ";
            EndeavourOS = " ";
            Fedora = " ";
            Garuda = "󰛓 ";
            Linux = " ";
            Macos = " ";
            NixOS = " ";
            Pop = " ";
            Raspbian = " ";
            Ubuntu = " ";
            Unknown = " ";
            Windows = "󰍲 ";
          };
        };
      };
    };
  };
}
