{
  config,
  inputs,
  lib,
  gLib,
  gVar,
  ...
}: {
  imports = gLib.scanPaths ./.;

  nix = {
    registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);
    nixPath = ["/etc/nix/path"];
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      warn-dirty = false;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  environment = {
    etc = lib.mapAttrs' (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;
    variables = {
      EDITOR = "nvim";
    };
  };

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
      };
      efi.canTouchEfiVariables = true;
    };
    kernelModules = ["v4l2loopback"];
    extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
  };

  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

  time.timeZone = lib.mkDefault "America/Chicago";

  console = let
    theme = builtins.attrValues gVar.palette;
  in {
    colors = map (v: lib.strings.removePrefix "#" v) theme;
    useXkbConfig = true;
  };

  programs = {
    fish.enable = true;
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
    xserver = {
      xkb = {
        layout = lib.mkDefault "us";
        options = "caps:escape";
      };
    };
  };

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
}
