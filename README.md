<h1 align="center">dotfiles</h1>

_<p align="center">Keep It Simple Stupid</p>_

![Hyprland with HyprPanel](./assets/preview-hyprpanel.jpg)

> _Hyprland with HyprPanel_

### NixOS

Each system added to the flake has a corresponding directory in
[nixos/](./nixos/) that contains the main configuration file as well as the
hardware configuration. The directory is titled the hostname of its system. The
hostname and primary username are passed to the configuration through the
**hostName** and **defaultUser** in **specialArgs**.

NixOS modules are located in [nixos/modules/](./nixos/modules/). They are sorted
between base, desktop, server, and users. Options are assigned to these
directories if they are meant to be used across multiple configurations. Modules
are separated into files if they are opt-in or they have different custom
options to choose from for each configuration.

```nix
...

let
  systems = [
    "grapecontrol"
    "grapelab"
    "grapespire"
    "grapestation"
  ];
in {
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
};

...
```

### Home Manager

Home Manager is installed as a NixOS module (see
[users/default.nix](./nixos/modules/users/default.nix)) and as standalone
configurations in the flake. Each configuration added to the **homes** list in
the flake has a file located in [home-manager/](./home-manager/) within its
respective hosts directory. Inside the flake, the **hostName** is passed through
**extraSpecialArgs** to the configurations.

Home manager modules are located in
[home-manager/modules/](./home-manager/modules/). They are sorted between base,
desktop, and server. Similar to the NixOS modules, options are assigned to these
directories if they are meant to be used across multiple configurations. Modules
are also separated into files if they are opt-in or they have different custom
options to choose from for each configuration.

```nix
# flake.nix
...

let
  homes = [
    { user = "marcus"; host = "grapecontrol"; }
    { user = "marcus"; host = "grapelab"; }
    { user = "marcus"; host = "grapespire"; }
    { user = "marcus"; host = "grapestation"; }
  ];
in {

  ...

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

# nixos/modules/users/default.nix
...

home-manager = {
  useUserPackages = true;
  useGlobalPkgs = true;
  extraSpecialArgs = {
    inherit inputs outputs system gLib hostName campfire;
  };
  users = builtins.listToAttrs (map (home: {
    name = home.user;
    value = import ./../../../home-manager/${hostName}/${home.user}.nix {
      home.username = home.user;
    };
  })
  homes);
};
```

### Users

I can add more users to a system via the default **users.users** options. If the
user will also include a Home Manager setup, that needs to be added to the
**homes** list in the flake. The corresponding configuration file must also be
correctly named (user.nix) and placed in it hosts directory in
[home-manager/](.home-manager/).

### gLib

This contains two helper functions: **scanPaths** and **scanFIles**.

**scanPaths** is used to import all nix files _(excluding default.nix)_ in a
directory.

```nix
{ inputs, gLib, ...} {
    imports = gLib.scanPaths ./.;

    # you can also append additional imports, ie modules from other flakes
    imports = (gLib.scanPaths ./.) ++ [inputs.bigChungus.nixosModules.carrots];
}
```

**scanFiles** is used to generate a list of all files in a directory. The only
spot I use this currently is as a helper for generating
**openssh.authorizedKeys**.

```nix
# nixos/modules/users/default.nix

{ gLib,... }: let
    keyScan = gLib.scanFiles ./keys;
in {
    ...
    openssh.authorizedKeys.keys = map (builtins.readFile) keyScan;
    ...
```

---

![Hyprlock](./assets/preview-hyprlock.jpg)

![Windows preview](./assets/preview-windows.jpg)

---

### TODO

- setup devenv
- find a more centralized solution for installed packages (system and user)
- finalize Hyprpanel settings/theme and add to HM module instead?
- setup a more vanilla style neovim config
- setup obsidian

## Adding a new system

Use nix-shell with git in order to clone this repo. Then enter the directory and
use [shell.nix](./shell.nix) provided for the rest of the process.

```sh
nix-shell -p git --command "git clone https://github.com/grapeofwrath/dotfiles.git"
cd dotfiles
nix-shell
```

Ensure that **~/.config/sops/age/keys.txt** exists on target system and that it
matches that file on existing hosts.

```sh
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
```

Create an access key specific to the system using its public ssh key. Add it to
the hosts section in [.sops.yaml](./.sops.yaml). Update
[secrets.yaml](./secrets.yaml) with sops.

```sh
cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age
vim .sops.yaml
sops updatekeys secrets.yaml
```

Generate an ssh key for the user and add it to [secrets.yaml](./secrets.yaml),
removing the file afterwards. Move the public key to
[nixos/modules/users/keys/](./nixos/modules/users/keys/) and don't forget to
upload it to github. Add any NixOS/Home-Manager files to [nixos/](./nixos/) and
[home-manager/](./home-manager/) and add the new hostName to the **systems**
list in the flake. Rebuild the system with the new configuration.

```sh
ssh-keygen -t ed25519 -f id_<user>-<host> -C <user>@<host>
cat id_<user>-<host>
sops secrets.yaml
rm id_<user>-<host>
mv id_<user>-<host>.pub nixos/modules/users/keys/
```

---

<h2 align="center">:snowflake: Special Thanks :snowflake:</h2>

_<p align="center">I've stumbled upon many great resources that have helped me
in one way or another. I don't remember them all, but here are a few.</p>_

<h3 align="center"><a href="https://github.com/Evertras/nix-systems">Evertras</a> | <a href="https://github.com/Misterio77/nix-starter-configs">Misterio77</a> | <a href="https://github.com/EmergentMind/nix-config">EmergentMind</a> | <a href="https://www.youtube.com/@vimjoyer">Vimjoyer</a> | <a href="https://www.youtube.com/@IogaMaster">IogaMaster</a> | <a href="https://nixos-and-flakes.thiscute.world/">NixOS & Flakes Book</a> | <a href="https://www.youtube.com/@ZaneyOG">Zaney</a> | <a href="https://www.youtube.com/@mylinuxforwork">MLFW</a></h3>
