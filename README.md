# Orion

Organizing my thoughts as I go.

## NixOS

For each directory in [nixos/systems/](./nixos/systems), a nixos configuration is generated in the flake.
The directory name should be the corresponding hostname.

## Home Manager

Home Manager is installed as a NixOS module (see [home.nix](./nixos/modules/home.nix) and [users.nix](./nixos/modules/users.nix)) and as a standalone configuration.
Similar to the system configs, a home-manager configuration is generated in the flake for each nix file in [home-manager/homes/](./home-manager/homes).
The directory name should be `user-hostname` in order to be imported to the correct system by the nixos home-manager module.

Home manager modules are imported via [modules/default.nix](./home-manager/modules/default.nix).

## Modules

Within `default.nix` for both nixos and home-manager, every `.nix` file is recursively imported.

Modules are put into files with their respective names; and directories are used either for grouping or for additional files needed by a module. Any module that has options is configured via `orion.$module`.

## Lib

## References

[Evertras](https://github.com/Evertras/nix-systems)

[evanjs](https://github.com/evanjs/nixos_cfg)
