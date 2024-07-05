{
  config,
  lib,
  ...
}: let
  cfg = config.orion.hyprgalactic.ags;
  t = config.colorScheme.palette;
in {
  config = lib.mkIf cfg.enable {
    home.file."style.css" = {
      target = ".config/ags/style.css";
      text = ''
        window.bar {
            background-color: #${t.base00};
            color: #${t.base05};
        }
        button {
            min-width: 0;
            padding-top: 0;
            padding-bottom: 0;
            background-color: transparent;
        }
        button:active {
            background-color: #${t.base04};
        }
        button:hover {
            border-bottom: 3px solid #${t.base05};
        }
        label {
            font-weight: bold;
        }
        .workspaces button.focused {
            border-bottom: 3px solid #${t.base04};
        }
        .client-title {
            color: #${t.base04};
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
