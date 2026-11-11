# Link manually to ~/.config/fish/config.fish.
# Resolve this file's symlink so sibling files can stay in the dotfiles checkout.
set -l config_dir (path dirname (path resolve (status filename)))
source "$config_dir/toolchain.fish"
source "$config_dir/terminal.fish"
source "$config_dir/media.fish"
source "$config_dir/nix.fish"

# format man pages
set -x MANROFFOPT -c
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

any-nix-shell fish --info-right | source

if status is-login
    if not set -q TMUX; and uwsm check may-start
        exec uwsm start hyprland-uwsm.desktop
    end
end
