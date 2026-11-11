# Recover the Nix profile's OCaml paths when an older session lacks them.
# Keep paths provided by development shells and opam.
if not set -q OCAMLPATH
    for profile in /etc/profiles/per-user/$USER "$HOME/.nix-profile"
        if test -r "$profile/etc/profile.d/hm-session-vars.sh"
            set -l ocaml_path (sh -c 'unset __HM_SESS_VARS_SOURCED; . "$1"; printf "%s" "$OCAMLPATH"' sh "$profile/etc/profile.d/hm-session-vars.sh")
            if test -n "$ocaml_path"
                set -gx OCAMLPATH "$ocaml_path"
            end
            break
        end
    end
end

# source '/home/rtfr/.opam/opam-init/init.fish'

set -x NODE_PATH "$HOME/.npm-packages/lib/node_modules"

fish_add_path "$HOME/.cargo/bin"
fish_add_path "$HOME/.npm-packages/bin"

fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/.kimi-code/bin"
