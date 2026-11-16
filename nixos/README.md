# NixOS configuration

This flake defines `aorus` and `zenbook`, with Home Manager integrated into each
system. Rebuild from this checkout; copying files to `/etc/nixos` is unnecessary.

## Layout

- `flake.nix`: pinned inputs, shared external modules, and host construction.
- `aorus.nix`, `zenbook.nix`: host selections and differences.
- `shared.nix`: common module imports; hardware configuration remains unchanged.
- `system/base.nix`: Nix policy, boot policy, locale, user, and basic tools.
- `system/desktop.nix`: compositor, portals, audio, Bluetooth, and file management.
- `system/development.nix`: Docker, device permissions, and dynamic linking support.
- `system/gaming.nix`: Steam, GameMode, and Gamescope.
- `system/networking.nix` and `zapret.nix`: connectivity and VPN/proxy applications.
- `fonts.nix` and `sofia-sans/`: shared fonts and local assets.
- `home/default.nix`: user identity and Home Manager imports.
- `home/applications.nix`: personal applications and their configuration.
- `home/hyprland.nix`: Wayland environment, session services, and keyboard imports.
- `home/keyboard/`: plain XKB symbols and registry files.
- Other `home/*.nix` files: shell, development stacks, theme, MIME associations,
  launcher, terminal multiplexing, and system information display.

Put system integration in NixOS modules and personal settings in Home Manager.
When a module installs an application, do not also list it in a package list.
Keep simple tools in package lists when they need no module configuration.
The Haskell, C/C++, FPGA, and LaTeX stacks remain in `home/programming.nix`.

## Deploy

Run these commands from this directory on the intended machine. Choose exactly
one host; replace `aorus` with `zenbook` throughout when deploying to the laptop.
Keep the machine's existing `hardware-configuration.nix` in this directory as
you normally do. The commands deliberately use `path:$PWD` so Nix includes that
ignored local file. A Git-backed `.#host` reference would omit it.

First review and commit the changes, including new module files and keyboard
assets. The lock file is now versioned; machine-local hardware stays ignored. From this directory:

```sh
git add .gitignore flake.nix flake.lock shared.nix aorus.nix zenbook.nix fonts.nix system home README.md
git diff --cached
git commit -m "Organize NixOS and Home Manager modules"
```

Evaluate and build without activating anything:

```sh
nix eval --raw "path:$PWD#nixosConfigurations.aorus.config.system.build.toplevel.drvPath"
nixos-rebuild build --flake "path:$PWD#aorus"
```

Activate temporarily, check the desktop and services, then make it persistent:

```sh
sudo nixos-rebuild test --flake "path:$PWD#aorus"
sudo nixos-rebuild switch --flake "path:$PWD#aorus"
```

Home Manager is activated with the system; do not run a separate
`home-manager switch`. Log out and back in after the first deployment so the
cursor environment and graphical session services are refreshed. Keep
`~/wallpaper.jpg` present. If another configuration starts Hyprpaper or
EasyEffects, remove those duplicate autostart commands before the new session.
Quickshell remains installed without enabling its optional systemd autostart.
Clipboard history now starts with `graphical-session.target`, which UWSM owns;
Hyprland's separate Home Manager systemd integration stays disabled.

Useful checks after login:

```sh
systemctl --user status hyprpaper easyeffects cliphist cliphist-images hyprpolkitagent
journalctl --user -b -u hyprpaper -u easyeffects -u cliphist
```

Existing unmanaged application configuration files can block Home Manager
activation. If it reports a collision, move only the named file aside as a
backup and retry; do not delete application data directories.

For a change intended only for the next boot, use:

```sh
sudo nixos-rebuild boot --flake "path:$PWD#aorus"
```

## Roll back

```sh
sudo nixos-rebuild switch --rollback
```

You can also select an earlier generation from Limine at boot. If using
`nixos-rebuild test` before `switch`, rebooting returns to the previously saved
boot generation. System rollback does not undo application data migrations.

## Update inputs

```sh
nix flake update
nixos-rebuild build --flake "path:$PWD#aorus"
nixos-rebuild build --flake "path:$PWD#zenbook"
git diff -- flake.lock
```

Commit the lock file after validation. Use `nix flake update INPUT_NAME` to update
one direct input instead. Leave both `system.stateVersion` and
`home.stateVersion` at their existing values during routine updates.

`sync_nixos.py` remains available for the old copy workflow, but only copies
`.nix` files: it does not deploy the lock file, keyboard assets, or local fonts.
Use direct flake rebuilds for this layout.
