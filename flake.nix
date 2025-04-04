{
  description = "Grapeofwrath's NixOS & Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";

    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    walker.url = "github:abenz1267/walker";

    nixhusky.url = "github:grapeofwrath/nixhusky";
    no = {
      url = "github:grapeofwrath/no";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # jot.url = "github:grapeofwrath/jot";
    # phortune.url = "github:grapeofwrath/phortune";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";

    # this pkgs is specifically for standalone HM
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
      overlays = [inputs.hyprpanel.overlay];
    };

    stable = import nixpkgs-stable {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };

    gLib = {
      scanPaths = path:
        map (f: (path + "/${f}"))
        (builtins.attrNames
          (nixpkgs.lib.attrsets.filterAttrs
            (
              path: _type:
                (_type == "directory")
                || (
                  (path != "default.nix") && (nixpkgs.lib.strings.hasSuffix ".nix" path)
                )
            ) (builtins.readDir path)));
      scanFiles = path:
        map (f: (path + "/${f}")) (builtins.attrNames (builtins.readDir path));
    };

    # vars
    defaultUser = "marcus";
    systems = [
      "grapecontrol" # vps reverse proxy with caddy and tailscale
      "grapelab" # homelab
      "grapespire" # laptop
      "grapestation" # couch gaming pc
    ];
    homes = [
      {
        user = "marcus";
        host = "grapecontrol";
      }
      {
        user = "marcus";
        host = "grapelab";
      }
      {
        user = "marcus";
        host = "grapespire";
      }
      {
        user = "marcus";
        host = "grapestation";
      }
    ];
    campfire = {
      base = "#14171F";
      surface = "#2A2F3C";
      overlay = "#323848";
      muted = "#3F475A";
      subtle = "#6D7A88";
      highlight = "#97A4AF";
      moon = "#DDD7CA";
      text = "#EFC164";
      ember = "#F3835D";
      dawn = "#F35955";
      dusk = "#A885C1";
      shore = "#3A8098";
      foam = "#70ADC2";
      evergreen = "#468966";
      fern = "#67CC8E";
    };
  in {
    formatter.${system} = nixpkgs.legacyPackages.${system}.pkgs.alejandra;

    nixosConfigurations = builtins.listToAttrs (map (hostName: {
        name = hostName;
        value = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs outputs system stable;
            inherit gLib defaultUser homes hostName campfire;
          };
          modules = [
            ./nixos/${hostName}
          ];
        };
      })
      systems);

    homeConfigurations = builtins.listToAttrs (map (home: let
        hostName = home.host;
      in {
        name = "${home.user}@${home.host}";
        value = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs outputs system;
            inherit gLib hostName campfire;
          };
          modules = [
            ./home-manager/${home.host}/${home.user}.nix
            {home.username = home.user;}
          ];
        };
      })
      homes);
  };
}
