{
  inputs,
  outputs,
  pkgs,
  osConfig,
  ...
}: {
  systemd.user.startServices = "sd-switch";
  home.packages = with pkgs; [
    git
    nushell
    kitty
    brave
    carapace
    zoxide
    starship
    (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})
    font-awesome
    direnv
    fzf
    tree
    discord
    ripgrep
    spotify
    element-desktop
  ];
  programs = {
    home-manager.enable = true;
    zoxide.enable = true;
    direnv = {
      enable = true;
      enableNushellIntegration = true;
      nix-direnv.enable = true;
    };
    fzf.enable = true;
  };
  programs.git = {
    enable = true;
    userName = "grapeofwrath";
    userEmail = "grapeofwrath@noreply.gitea.com";
    extraConfig = {
      url."ssh://git@gitea.com" = {
        insteadOf = "https://gitea.com";
      };
      init.defaultBranch = "main";
    };
  };
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
      rebuild = "sudo nixos-rebuild switch --flake ~/${osConfig.networking.hostName}#${osConfig.networking.hostName}";
      update = "sudo nix flake update";
      nvim = "nix run github:grapeofwrath/nixvim-flake";
      n = "nix run github:grapeofwrath/nixvim-flake";
    };
  };
  programs.carapace.enable = true;
  programs.carapace.enableNushellIntegration = true;

  programs.starship = {
    enable = true;
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
        format = "[$user]($style) at ";
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
        Alpaquita = " ";
        Alpine = " ";
        Amazon = " ";
        Android = " ";
        Arch = " ";
        Artix = " ";
        CentOS = " ";
        Debian = " ";
        DragonFly = " ";
        Emscripten = " ";
        EndeavourOS = " ";
        Fedora = " ";
        FreeBSD = " ";
        Garuda = "󰛓 ";
        Gentoo = " ";
        HardenedBSD = "󰞌 ";
        Illumos = "󰈸 ";
        Linux = " ";
        Mabox = " ";
        Macos = " ";
        Manjaro = " ";
        Mariner = " ";
        MidnightBSD = " ";
        Mint = " ";
        NetBSD = " ";
        NixOS = " ";
        OpenBSD = "󰈺 ";
        openSUSE = " ";
        OracleLinux = "󰌷 ";
        Pop = " ";
        Raspbian = " ";
        Redhat = " ";
        RedHatEnterprise = " ";
        Redox = "󰀘 ";
        Solus = "󰠳 ";
        SUSE = " ";
        Ubuntu = " ";
        Unknown = " ";
        Windows = "󰍲 ";
      };
    };
  };
  programs.kitty = {
    enable = true;
    font.name = "JetBrainsMono Nerd Font";
    font.size = 12;
    theme = "Rosé Pine";
    settings = {
      scrollback_lines = 2000;
      wheel_scroll_min_lines = 1;
      window_padding_width = 10;
      confirm_os_window_close = 0;
      background_opacity = "0.90";
    };
  };

  xdg.configFile."lf/icons".source = ../assets/icons;

  programs.lf = {
    enable = true;
    commands = {
      dragon-out = ''%${pkgs.xdragon}/bin/xdragon -a -x "$fx"'';
      editor-open = ''$$EDITOR $f'';
      mkdir = ''
        ''${{
          printf "Directory Name: "
          read DIR
          mkdir $DIR
        }}
      '';
    };

    keybindings = {
      "\\\"" = "";
      o = "";
      c = "mkdir";
      "." = "set hidden!";
      "`" = "mark-load";
      "\\'" = "mark-load";
      "<enter>" = "open";

      do = "dragon-out";

      "g~" = "cd";
      gh = "cd";
      "g/" = "/";

      ee = "editor-open";
      V = ''$${pkgs.bat}/bin/bat --paging=always --theme=gruvbox "$f"'';

      # ...
    };

    settings = {
      preview = true;
      hidden = true;
      drawbox = true;
      icons = true;
      ignorecase = true;
    };

    extraConfig = let
      previewer = pkgs.writeShellScriptBin "pv.sh" ''
        file=$1
        w=$2
        h=$3
        x=$4
        y=$5

        if [[ "$( ${pkgs.file}/bin/file -Lb --mime-type "$file")" =~ ^image ]]; then
            ${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
            exit 1
        fi

        ${pkgs.pistol}/bin/pistol "$file"
      '';
      cleaner = pkgs.writeShellScriptBin "clean.sh" ''
        ${pkgs.kitty}/bin/kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
      '';
    in ''
      set cleaner ${cleaner}/bin/clean.sh
      set previewer ${previewer}/bin/pv.sh
    '';
  };
}
