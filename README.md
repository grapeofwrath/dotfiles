# Orion

Organizing my thoughts as I go.

## Modularity - K.I.S.S.

See [https://github.com/Misterio77/nix-config](Misterio77's config) as an in depth example/proof of concept, though possibly not as complex as I'd like to implement.

### Directory Structure

```
.
├── flake.lock
├── flake.nix
├── home-manager
│   ├── modules
│   │   ├── assets
│   │   │   └── icons
│   │   ├── cli
│   │   │   ├── default.nix
│   │   │   ├── lf
│   │   │   │   └── default.nix
│   │   │   ├── shell
│   │   │   │   └── default.nix
│   │   │   └── starship
│   │   │       └── default.nix
│   │   ├── default.nix
│   │   └── desktop
│   │       ├── default.nix
│   │       ├── hyprland
│   │       │   ├── default.nix
│   │       │   ├── swaylock.nix
│   │       │   ├── swaync.nix
│   │       │   └── waybar.nix
│   │       └── kitty
│   │           └── default.nix
│   └── users
│       └── grape
│           └── default.nix
├── nixos
│   ├── machines
│   │   ├── grapelab
│   │   │   └── default.nix
│   │   ├── grapepad
│   │   │   └── default.nix
│   │   └── grapestation
│   │       ├── default.nix
│   │       └── hardware-configuration.nix
│   └── modules
│       ├── default.nix
│       └── gaming
│           └── default.nix
└── README.md
```

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
