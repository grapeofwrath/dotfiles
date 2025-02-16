{
  config,
  pkgs,
  inputs,
  hostName,
  gLib,
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
    # duplicate of NixOS module but necessary for standalone HM
    age.keyFile = "/home/${config.home.username}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../../secrets.yaml;
    validateSopsFiles = false;
    secrets = let
      keyName = "${config.home.username}-${hostName}";
    in {
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
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };

    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
      '';
      loginShellInit = "Hyprland";
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
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      # enableFishIntegration = true;
      nix-direnv.enable = true;
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
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
}
