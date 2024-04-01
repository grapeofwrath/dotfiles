{options,config,pkgs,lib,...}: with lib; with lib.orion;
let cfg = config.orion.hardware.audio; in {
  options.orion.network.audio = with types; {
    enable = mkBoolOpt false "Enable audio configuration module";
  };
  config = mkIf cfg.enable {
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
