# Orion

Organizing my thoughts as I go.

## NixOS

For each directory in [nixos/systems/](./nixos/systems), a nixos configuration is generated in the flake. The directory name should be the corresponding hostname. Within each system directory, there are three files: `configuration.nix`, `default.nix`, and `hardware-config.nix`. The file that is imported for each system in the flake is `default.nix`, and it has the following structure:

```nix
{
  system = "x86_64-linux";
  module = ./configuration.nix;
}
```

`system` is the system's architecture

`module` imports the main configuration file

NixOS modules are imported via [modules/default.nix](./nixos/modules/default.nix).

## Home Manager

Home Manager is currently installed as a NixOS module, see [home.nix](./nixos/modules/home.nix) and [users.nix](./nixos/modules/users.nix). Each home manager configuration is located in `./home-manager/homes/$user/$hostName.nix`. This directory structure may need to be changed to accomodate setting up a standalone home manager instance similar to [Evertras](https://github.com/Evertras/nix-systems) / how the system configurations are setup in the flake.

Home manager modules are imported via [modules/default.nix](./home-manager/modules/default.nix).

## Modules

Within `default.nix` for both nixos and home-manager, every `.nix` file is recursively imported.

```nix
{lib,...}: with lib;
let
  # Recursively constructs an attrset of a dir, value of attrs is the filetype
  getDir = dir: mapAttrs
    (file: type: if type == "directory" then getDir "${dir}/${file}" else type)
    (builtins.readDir dir);

  # Collects all files of a dir as list of paths as strs
  files = dir: collect isString (mapAttrsRecursive (path: type: concatStringsSep "/" path) (getDir dir));

  # Filters out dirs != *.nix and this file, makes the strs absolute
  validFiles = dir: map
    (file: ./. + "/${file}")
    (filter
      (file: hasSuffix ".nix" file && file != "default.nix")
      (files dir));
in { imports = validFiles ./.; }
```

At some point, I would like to add this to the [flakes lib](./lib/grapelib/default.nix), but currently I haven't bothered to get that working properly.

Modules are put into files with their respective names; and directories are used either for grouping or for additional files needed by a module. Any module that has options is configured via `orion.$module`.

## Lib

At the moment, there is only [libgrape](./lib/libgrape/default.nix) which is primarily used in [flake.nix](./flake.nix) in order to generate configs from directories. Eventually I may add a few other things such as theming here as well.

## Todo

- [ ] finish setting up Hyprland
- [x] add nushell
- [ ] setup sops-nix again
- [ ] setup steam to launch independant session [see Jovian NixOS](https://github.com/Jovian-Experiments/Jovian-NixOS)
- [ ] add configuration for grapelab (homelab server)
- [ ] setup home manager as a standalone install alongside nixos module [see Evertras' config](https://github.com/Evertras/nix-systems)

## Misc

### SOPS

When adding a new ssh key to `secrets.yaml`, don't forget to add it to the ssh agent:

- reboot with `programs.ssh.startAgent = true;`
    - This doesn't seem to work, need to find the proper way
- or `ssh-add ~/path/to/key`
- I think a systemd service is what I need to use in order to make this happen automatically

## References

[Evertras](https://github.com/Evertras/nix-systems)

[evanjs](https://github.com/evanjs/nixos_cfg)
