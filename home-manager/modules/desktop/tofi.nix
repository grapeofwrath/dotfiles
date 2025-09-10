{
  config,
  lib,
  campfire,
  ...
}:
with lib; let
  cfg = config.tofi;
in {
  options.tofi = {
    enable = mkEnableOption "Enable Tofi";
  };

  config = mkIf cfg.enable {
    programs.tofi = {
      enable = true;
      settings = {
        font = "Jetbrains Mono Nerd Font";
        prompt-color = campfire.fern;
        placeholder-color = campfire.fern;
        input-color = campfire.fern;
        default-result-color = campfire.fern;
        selection-color = campfire.evergreen;
        selection-match-color = campfire.text;
        selection-background-padding = "auto";
        prompt-text = ''C:\> '';
        prompt-padding = 9;
        placeholder-text = "...";
        num-results = 5;
        width = "45%";
        height = "30%";
        padding-top = 12;
        padding-bottom = 12;
        padding-left = 18;
        padding-right = 18;
        border-width = 3;
        border-color = campfire.muted;
        corner-radius = 12;
        background-color = campfire.base;
        anchor = "center";
        matching-algorithm = "fuzzy";
        terminal = "ghostty";
        drun-launch = true;
      };
    };
  };
}
