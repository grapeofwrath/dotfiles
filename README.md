# Orion

Organizing my thoughts as I go.

<details>

<summary>### Directory Structure</summary>

```
./
├── home-manager/
│   ├── homes/
│   │   └── grape/
│   │       ├── grapepad/
│   │       │   └── default.nix
│   │       └── grapestation/
│   │           └── default.nix
│   └── modules/
│       ├── cli/
│       │   ├── lf/
│       │   │   ├── default.nix
│       │   │   └── icons
│       │   └── git.nix
│       ├── desktop/
│       │   └── kitty.nix
│       ├── shell/
│       │   ├── bash.nix
│       │   ├── default.nix
│       │   └── starship.nix
│       ├── base.nix
│       └── default.nix
├── lib/
│   └── libgrape/
│       └── default.nix
├── nixos/
│   ├── modules/
│   │   ├── apps/
│   │   │   └── steam.nix
│   │   ├── desktop/
│   │   │   ├── default.nix
│   │   │   ├── hyprland.nix
│   │   │   └── plasma.nix
│   │   ├── base.nix
│   │   ├── default.nix
│   │   ├── hardware.nix
│   │   ├── home.nix
│   │   ├── services.nix
│   │   ├── system.nix
│   │   ├── tools.nix
│   │   └── users.nix
│   └── systems/
│       ├── grapepad/
│       │   ├── configuration.nix
│       │   ├── default.nix
│       │   └── hardware-config.nix
│       └── grapestation/
│           ├── configuration.nix
│           ├── default.nix
│           └── hardware-config.nix
├── flake.lock
├── flake.nix
├── README.md
└── shell.nix
```
</details>

For each directory in [`./nixos/systems/`](./nixos/systems), a nixos configuration is generated in the flake. The directory name should be the corresponding hostname. Within each system directory, there are three files: `configuration.nix`, `default.nix`, and `hardware-config.nix`. The file that is imported for each system in the flake is `default.nix`, and it has the following structure:

```nix
{
  system = "x86_64-linux";
  module = ./configuration.nix;
}
```

`system` is the system's architecture
`module` imports the main configuration file

## Misc

### SOPS

When adding a new ssh key to `secrets.yaml`, don't forget to add it to the ssh agent:

- reboot with `programs.ssh.startAgent = true;`
    - This doesn't seem to work, need to find the proper way
- or `ssh-add ~/path/to/key`
