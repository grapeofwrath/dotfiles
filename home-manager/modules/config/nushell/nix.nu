# Define the main command with subcommands and help text
def nx [
    subcommand?: string@nx-completions  # Optional subcommand with custom completion
    --help(-h)
] {
    let sub = $subcommand

    # Show help if requested or no subcommand provided
    if $help or ($sub | is-empty) {
        print "\nNixOS management commands:"
        print "  nx config   - Edit NixOS configuration"
        print "  nx deploy   - Deploy current NixOS configuration"
        print "  nx rebuild  - Rebuild current NixOS configuration"
        print "  nx up       - Update NixOS flake"
        print "  nx clean    - Remove old generations"
        print "  nx gc       - Run garbage collection"
        print "  nx doctor   - Run maintenance tasks\n"
        print "  nx pull     - Pull latest github version\n"
        return
    }

    match $sub {
    "config" => { nx-config }
    "deploy" => { nx-deploy }
    "rebuild" => { nx-rebuild }
    "up" => { nx-up }
    "clean" => { nx-clean }
    "gc" => { nx-gc }
    "doctor" => { nx-doctor }
    "pull" => { nx-pull }
    _ => { print $"Unknown subcommand: ($sub)" }
}
}

# Completion function for nx subcommands
def nx-completions [] {
    [
        "config",  # Edit NixOS configuration
        "deploy",  # Deploy current NixOS configuration
        "rebuild", # Rebuild current NixOS configuration
        "up",      # Update NixOS flake
        "clean",   # Remove old generations
        "gc",      # Run garbage collection
        "doctor"   # Run maintenance tasks
        "pull"     # Pull latest github version
    ]
}

def nx-config [] {
    let original_dir = $env.PWD
    cd /home/marcus/dotfiles
    nvim
    cd $original_dir
}

def nx-deploy [] {
    let current_hostname = (hostname | str trim)
    let original_dir = $env.PWD
    cd /home/marcus/dotfiles
    git diff -U0 **.nix
    print "\n-> NixOS Rebuilding..."

    if (sudo nixos-rebuild switch --flake $"./#($current_hostname)" err> nixos-switch.log | complete).exit_code != 0 {
        grep --color=always error nixos-switch.log
        return 1
    }

    let gen = (nixos-rebuild list-generations | lines | find current | first)
    git commit -am $gen
    cd $original_dir
    print "\n-> NixOS rebuild completed successfully."
}

def nx-rebuild [] {
    let current_hostname = (hostname | str trim)
    let original_dir = $env.PWD
    cd /home/marcus/dotfiles
    let view_diff = ([ Yes No ] | input list "Show changes?")
    if $view_diff == 0 {
        git diff -U0 **.nix
    }
    print $"\n-> Rebuilding NixOS for ($current_hostname)..."

    sudo nixos-rebuild switch --flake $"./#($current_hostname)"

    cd $original_dir
    print "\n-> NixOS rebuild completed successfully."
}

def nx-up [] {
    print "\n-> Updating nix..."
    let current_hostname = (hostname | str trim)
    sudo nix flake update --flake $"/home/marcus/dotfiles"
    sudo nixos-rebuild switch --flake $"/home/marcus/dotfiles#($current_hostname)"
}

def nx-clean [] {
    print "\n-> Wiping old history ..."
    sudo nix-collect-garbage -d
}

def nx-gc [] {
    print "\n-> Initiating Garbage Collection ..."
    sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d
}

def nx-doctor [] {
    nx-up
    nx-gc
    nx-clean
}

def nx-pull [] {
    let original_dir = $env.PWD
    cd /home/marcus/dotfiles
    git pull
    cd $original_dir
}
