{ osConfig, ... }:
{
  programs.nushell = {
    enable = true;
    extraConfig = ''
      let carapace_completer = {|spans|
      carapace $spans.0 nushell $spans | from json
      }
      $env.config = {
       show_banner: false,
       completions: {
       case_sensitive: false
       quick: true    # set to false to prevent auto-selecting completions
       partial: true    # set to false to prevent partial filling of the prompt
       algorithm: "fuzzy"    # prefix or fuzzy
       external: {
       # set to false to prevent nushell looking into $env.PATH to find more suggestions
           enable: true
       # set to lower can improve completion performance at the cost of omitting some options
           max_results: 100
           completer: $carapace_completer # check "carapace_completer"
         }
       }
      }
      $env.PATH = ($env.PATH |
      split row (char esep) |
      prepend /home/myuser/.apps |
      append /usr/bin/env
      )
      # access to og ls command, built-in ls with path param, shadow ls command with custom table
      alias core-ls = ls
      def old-ls [path] {
        core-ls -la $path | select name type mode user group size modified
      }
      def ls [path?] {
        if $path == null {
          old-ls .
        } else {
          old-ls $path
        }
      }
    '';
    shellAliases = {
      nvim = "nix run github:grapeofwrath/nixvim-flake";
      n = "nvim";
      rebuild = "sudo nixos-rebuild switch --flake ~/${osConfig.networking.hostName}#${osConfig.networking.hostName}";
      update = "sudo nix flake update";
    };
  };
  programs.carapace.enable = true;
  programs.carapace.enableNushellIntegration = true;
}
