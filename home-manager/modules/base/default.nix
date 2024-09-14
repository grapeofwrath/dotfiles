{
  config,
  pkgs,
  gLib,
  ...
}: {
  imports = gLib.scanPaths ./.;

  home = {
    homeDirectory = "/home/${config.home.username}";

    packages = with pkgs; [
      # cli
      (pkgs.nerdfonts.override {
        fonts = [
          "JetBrainsMono"
          "CascadiaCode"
        ];
      })
      font-awesome
      polkit
      tree
      imagemagick
    ];

    file = {
      ".config/phortune/phortunes".source = ../../../assets/phortunes;
    };

    # Believe it or not, if you change this? Straight to jail.
    stateVersion = "24.05";
  };

  systemd.user.startServices = "sd-switch";

  programs = {
    home-manager.enable = true;

    bash = {
      enable = true;
      enableCompletion = true;
      historyControl = ["ignoredups"];
      historyIgnore = [
        "ls"
        "ll"
        "cd"
        "z"
        ".."
        "exit"
      ];
      shellAliases = {
        grep = "rg";
        n = "nvim";
        ll = "ls -alF";
        tree = "tree --dirsfirst -F";
        mkdir = "mkdir -pv";
      };
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
    fzf.enable = true;
    ripgrep.enable = true;
    btop.enable = true;
  };
}
