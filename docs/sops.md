# Sops

## Adding a new host

Ensure that `~/.config/sops/age/keys.txt` exits on target host and that it matches that file on existing hosts.
Create the file via `age-keygen -o ~/.config/sops/age/keys.txt`.

Create an access key specific to the host using it public ssh key.
Use `cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age` to generate the age key.
Add it to the hosts section in `.sops.yaml`.
Run `sops updatekeys secrets.yaml` to add the key to sops.

Add the private ssh key for user-host to sops.
Generate key with `ssh-keygen -t ed25519 -f ~/.ssh/id_user-host -C user@host`.
Copy private key to `secrets.yaml` and remove private key from `.ssh` directory.
Move `id_user-host.pub` to `orion/nixos/modules/users/keys/` and add to authorized keys in `users/default.nix`.
