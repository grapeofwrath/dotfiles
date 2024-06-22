{...}: {
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
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
}
