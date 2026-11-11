function rebuild-aorus
    sudo nixos-rebuild switch --flake /etc/nixos#aorus $argv
end

function rebuild-zenbook
    sudo nixos-rebuild switch --flake /etc/nixos#zenbook $argv
end

# Delete only system generations older than the currently running system.
# This removes rollback entries; run nix-purge-orphans to reclaim store space.
function nixos-prune-generations --description "Remove NixOS generations older than the running system"
    set -l profile /nix/var/nix/profiles/system
    set -l running (command readlink -f /run/current-system)
    or return
    set -l loaded_generation
    set -l generations

    for link in $profile-*-link
        set -l generation (string match -r --groups-only 'system-([0-9]+)-link$' -- "$link")
        if test (command readlink -f -- "$link") = "$running"
            if test -z "$loaded_generation"; or test "$generation" -gt "$loaded_generation"
                set loaded_generation "$generation"
            end
        end
        set -a generations "$generation"
    end

    if test -z "$loaded_generation"
        echo "Cannot find a profile generation for the running system." >&2
        return 1
    end

    set -l older
    for generation in $generations
        if test "$generation" -lt "$loaded_generation"
            set -a older "$generation"
        end
    end

    if test (count $older) -eq 0
        echo "No NixOS generations older than $loaded_generation."
        return 0
    end

    command sudo nix-env --profile "$profile" --delete-generations $older
end

# Retain all profile generations and other GC roots.
function nix-purge-orphans --description "Collect unreferenced Nix store paths"
    command sudo nix-store --gc
end
