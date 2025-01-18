{
  inputs,
  pkgs,
  campfire,
  ...
}: {
  home.packages = with pkgs; [
    walker
  ];
  # imports = [inputs.walker.homeManagerModules.default];
  #
  # programs.walker = {
  #   enable = true;
  #   runAsService = true;
  #
  #   config = {
  #     ui.fullscreen = true;
  #     # app_launch_prefix = "uwsm app -- ";
  #   };
  #
  #   # style = ''
  #   #
  #   # '';
  # };
}
