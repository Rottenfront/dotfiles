# Dotfiles

This is a repo with my configuration of Linux (to be precise, CachyOS/Arch) environment.
It is not designed to be installed. I just provide it so you can use source code for your own purpose, and also as archive of my settings.


## Standalone configuration

- Link `hypr/hyprland.lua` to `~/.config/hypr/hyprland.lua`.
- Link `fish/config.fish` to `~/.config/fish/config.fish`.

These files are maintained separately from Home Manager and are not linked automatically.
Nix still provides packages, services, session variables, and the custom XKB layouts.

Fish's `config.fish` sources sibling files for toolchain paths (`toolchain.fish`),
media functions (`media.fish`), terminal aliases (`terminal.fish`), and Nix commands
(`nix.fish`). Only `config.fish` needs linking; it resolves its symlink to find them.

Run `nixos-prune-generations` to delete system profile generations older than
the running system, then `nix-purge-orphans` to reclaim unreferenced store paths.
Pruning removes old rollback entries. Other profiles and GC roots remain intact.

## Structure

There are:
- `.config` - config files, can be linked into `~/.config` for convenience
    - `fastfetch` - can be linked as directory
    - `fish` - only `fish/config.fish` should be linked (as file)
    - `hypr` - can be linked as directory
    - `mpd` - only `mpd/mpd.conf` should be linked (as file)
    - `nvim` - can be linked as directory
    - `quickshell` - can be linked as directory
    - `rmpc` - can be linked as directory
    - `rofi` - can be linked as directory
- `Pictures/wallpapers` - wallpapers
- `scripts` - miscellaneous


## Required packages:

- hyprland - compositor
- xdg-desktop-portal-gtk, xdg-desktop-portal-hyprland, hyprpolkitagent - desktop services
- quickshell, rofi, awww - shell, launcher, wallpapers
- kitty - terminal
- mpd, mpc, rmpc - music


## Selected applications

- librewolf - browser
- thunar - file manager
- pwvucontrol - audio manager
- neovide - neovim shell

## Fonts

- ttf-paratype - main system fonts
- ttf-sofia-sans - nice cyrillic
- ttf-cascadia-code - monospace
- noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra - extra fonts
