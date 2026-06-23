# Dotfiles

This is a repo with my configuration of Linux (to be precise, CachyOS/Arch) environment.
It is not designed to be installed. I just provide it so you can use source code for your own purpose, and also as archive of my settings.


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
- easyeffects - audio mixer
- neovide - neovim shell
