{
  config,
  pkgs,
  inputs,
  hostName,
  gLib,
  campfire,
  ...
}: let
  keyName = "${config.home.username}-${hostName}";
in {
  imports = (gLib.scanPaths ./.) ++ [inputs.sops-nix.homeManagerModules.sops];

  home = {
    homeDirectory = "/home/${config.home.username}";

    shellAliases = {
      n = "nvim";
      ".." = "cd ..";
    };

    # Believe it or not, if you change this? Straight to jail.
    stateVersion = "24.05";
  };

  systemd.user.startServices = "sd-switch";

  sops = {
    age.keyFile = "/home/${config.home.username}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../../secrets.yaml;
    validateSopsFiles = false;
    secrets = {
      "private_keys/${keyName}" = {
        path = "/home/${config.home.username}/.ssh/id_${keyName}";
      };
    };
  };

  services.ssh-agent.enable = true;

  programs = {
    btop.enable = true;
    fzf.enable = true;
    home-manager.enable = true;
    ripgrep.enable = true;

    bash = {
      enable = true;
      initExtra = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "nu" && -z ''${BASH_EXECUTION_STRING} ]]
            then
                shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
                exec ${pkgs.nushell}/bin/nu $LOGIN_OPTION
                fi
      '';
    };

    nushell = {
      enable = true;
      configFile.source = ./../config/nushell/config.nu;
      shellAliases = {
        n = "nvim";
        ".." = "cd ..";
      };
      extraLogin = ''
         # uwsm start hyprland-uwsm.desktop
        Hyprland
      '';
    };

    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };

    git = {
      enable = true;
      userName = "grapeofwrath";
      userEmail = "69535018+grapeofwrath@users.noreply.github.com";
      extraConfig = {
        url."ssh://git@github.com" = {
          insteadOf = "https://github.com";
        };
        init.defaultBranch = "main";
      };
    };

    keychain = {
      enable = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      keys = ["id_${keyName}"];
      extraFlags = ["--quiet"];
    };

    ssh = {
      enable = true;
      addKeysToAgent = "yes";
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      nix-direnv.enable = true;
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

    zellij = {
      enable = true;
      settings = {
        pane_frames = false;
        theme = "campfire";
        themes.campfire = let
          c = campfire;
        in {
          fg = c.text;
          bg = c.base;
          black = c.surface;
          red = c.dusk;
          green = c.evergreen;
          yellow = c.ember;
          blue = c.foam;
          magenta = c.fern;
          cyan = c.shore;
          white = c.moon;
          orange = c.dawn;
        };
      };
    };
  };
}
