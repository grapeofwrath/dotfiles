# Notes

Organizing my thoughts as I go.

## Modularity - K.I.S.S.

See https://github.com/Misterio77/nix-config[Misterio77's config] as an in depth example/proof of concept, though possibly not as complex as I'd like to implement.

### Directory Structure

```
.
├── assets
│   └── icons
├── flake.lock
├── flake.nix
├── home
│   ├── $user
│   │   └── $hostname.nix
│   ├── home.nix
├── hosts
│   ├── configuration.nix
│   ├── $hostname
│   │   ├── default.nix
│   │   └── hardware-configuration.nix
│   └── users
│       ├── $user.nix
└── secrets
    └── secrets.yaml
```

There are three main files upon which each system depends (unless there are multiple users):

- **flake.nix:** For each host, it imports `./hosts/$hostname`
- **hosts/$hostname/default.nix:** Imports `./hardware-configuration.nix`, `./../configuration,nix` for shared system settings, and `./../users/$user.nix` for each user
- **hosts/users/$user.nix:** Imports the home-manager config for the corresponding system via `./../../home/$user/$hostname.nix` as well as some shared settings through `./../../home/home.nix`

## Misc

### SOPS

When adding a new ssh key to `secrets.yaml`, don't forget to add it to the ssh agent:

- reboot with `programs.ssh.startAgent = true;`
- or `ssh-add ~/path/to/key`
