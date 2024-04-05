# Orion

Organizing my thoughts as I go.

## Modularity - K.I.S.S.

See [Misterio77's config](https://github.com/Misterio77/nix-config) as an in depth example/proof of concept, though possibly not as complex as I'd like to implement.

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
│       ├── base/
│       │   └── default.nix
│       ├── cli/
│       │   ├── git/
│       │   │   └── default.nix
│       │   ├── lf/
│       │   │   ├── default.nix
│       │   │   └── icons
│       │   └── default.nix
│       ├── desktop/
│       │   ├── kitty/
│       │   │   └── default.nix
│       │   └── default.nix
│       ├── shell/
│       │   ├── bash/
│       │   │   └── default.nix
│       │   ├── starship/
│       │   │   └── default.nix
│       │   └── default.nix
│       └── default.nix
├── lib/
│   └── libgrape/
│       └── default.nix
├── nixos/
│   ├── modules/
│   │   ├── apps/
│   │   │   ├── steam/
│   │   │   │   └── default.nix
│   │   │   └── default.nix
│   │   ├── base/
│   │   │   └── default.nix
│   │   ├── desktop/
│   │   │   ├── hyprland/
│   │   │   │   └── default.nix
│   │   │   ├── plasma/
│   │   │   │   └── default.nix
│   │   │   └── default.nix
│   │   ├── hardware/
│   │   │   └── default.nix
│   │   ├── services/
│   │   │   └── default.nix
│   │   ├── system/
│   │   │   └── default.nix
│   │   ├── tools/
│   │   │   └── default.nix
│   │   ├── users/
│   │   │   └── default.nix
│   │   └── default.nix
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

**NEEDS UPDATING** There are three main files upon which each system depends (unless there are multiple users):

- **flake.nix:** For each host, it imports `./hosts/$hostname`
- **hosts/$hostname/default.nix:** Imports `./hardware-configuration.nix`, `./../configuration,nix` for shared system settings, and `./../users/$user.nix` for each user
- **hosts/users/$user.nix:** Imports the home-manager config for the corresponding system via `./../../home/$user/$hostname.nix` as well as some shared settings through `./../../home/home.nix`

## Misc

### SOPS

When adding a new ssh key to `secrets.yaml`, don't forget to add it to the ssh agent:

- reboot with `programs.ssh.startAgent = true;`
    - This doesn't seem to work, need to find the proper way
- or `ssh-add ~/path/to/key`
