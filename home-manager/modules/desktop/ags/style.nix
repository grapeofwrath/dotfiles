{
  config,
  lib,
  ...
}: let
  cfg = config.desktop.ags;
  theme = config.colorScheme.palette;
in {
  config = lib.mkIf cfg.enable {
    home.file."style.css" = {
      target = ".config/ags/style.css";
      text = ''
        window.bar {
            background-color: #${theme.base00};
            color: #${theme.base05};
        }
        button {
            min-width: 0;
            padding-top: 0;
            padding-bottom: 0;
            background-color: transparent;
        }
        button:active {
            background-color: #${theme.base04};
        }
        button:hover {
            border-bottom: 3px solid #${theme.base05};
        }
        label {
            font-weight: bold;
        }
        .workspaces button.focused {
            border-bottom: 3px solid #${theme.base04};
        }
        .client-title {
            color: #${theme.base04};
        }
        .notification {
            color: yellow;
        }
        levelbar block,
        highlight {
            min-height: 10px;
        }
      '';
    };
  };
}
