The Home Manager module `tmux.nix` configures tmux and the matching Kitty key
encodings. Rebuild from the repository root:

```sh
sudo nixos-rebuild switch --flake ./nixos#aorus
```

When using the Git flake reference above, add the new module to Git first
(`git add nixos/home/programs/tmux.nix`), since Nix excludes untracked files.
Alternatively, use `--flake path:$(pwd)/nixos#aorus` to include untracked files.
Open a new Kitty window, then start or reattach to the shared workspace:

```sh
tmux new-session -A -s main
```

| Shortcut | Action |
| --- | --- |
| Ctrl+Shift+N | Split top/bottom in a tall window; side-by-side otherwise |
| Ctrl+H/J/K/L | Focus the left/down/up/right pane |
| Ctrl+Shift+H/J/K/L | Swap with the adjacent pane, following the moved pane |
| Ctrl+Alt+H/J/K/L | Resize the pane by five columns/rows |
| Ctrl+Shift+T | Create a tmux window (tab) |
| Alt+1…9, Alt+0 | Select windows 1…9, 10 |
| Ctrl+Shift+I | Open an 80% × 70% floating command shell |
| Ctrl+B, D | Detach, leaving the workspace running |
| Ctrl+B, R | Reload the tmux configuration |
| Ctrl+B, Z | Zoom/unzoom the current pane |

New splits, tabs, and popups inherit the active pane's working directory.
Split orientation follows the whole tmux window's pixel proportions, using the
reported cell dimensions or a 1:2 cell aspect ratio when they are unavailable.
Tmux names top/bottom splitting `-v` and side-by-side splitting `-h`.
Tabs are numbered from one and renumbered when a tab closes. The prefix is still
Ctrl+B; these custom shortcuts do not require it. They are reserved by tmux even
when Neovim or Yazi has focus. Use ordinary Backspace and Enter in applications.
Kitty sends distinct CSI-u sequences for the requested shortcuts, including
Ctrl+H and Ctrl+J, so Backspace and Enter do not trigger pane navigation.
These Kitty mappings apply outside tmux too; use tmux for this workspace.

The floating shell is a tmux popup: it takes keyboard focus until closed and
closes with `exit` or Ctrl+D at an empty shell prompt. Closing it ends
its shell, so keep long-running commands in regular panes. Pane movement,
resizing, and tab shortcuts operate in the regular workspace; they do not
operate while a popup has focus. No plugins are needed. Stable tmux 3.7 also
has persistent floating panes (`Ctrl+B, *`), but their movement and resizing
are mouse-only in that release; see the [3.7 release notes](https://github.com/tmux/tmux/blob/3.7c/CHANGES).

Image previews use the stable tmux package already pinned by `nixos/flake.lock`
(3.7c when this configuration was written). No development build or experimental
flag is required for Kitty/Yazi previews. The module enables `allow-passthrough`
and propagates terminal detection variables according to [Yazi's tmux
instructions](https://yazi-rs.github.io/docs/image-preview/#tmux-users).
`TERM` inside panes remains `tmux-256color`; do not force it to `xterm-kitty`.

Kitty 0.28+ supports [Unicode image
placeholders](https://sw.kovidgoyal.net/kitty/graphics-protocol/#unicode-placeholders).
Yazi uses these automatically in Kitty, allowing tmux to move and redraw the
placeholder text along with the image. Check detection with `ya env` in a pane:
the image driver should be `Kgp`. Test an image preview while switching tabs,
resizing panes, and scrolling. For a standalone image:

```sh
kitten icat --passthrough=tmux --unicode-placeholder ./image.png
```

Passthrough is not native Kitty/iTerm2 image storage in tmux: applications must
support tmux passthrough themselves. Traditional Kitty placements without
Unicode placeholders do not track pane layout correctly. The same configuration
permits Yazi's iTerm2 inline image protocol when the outer terminal supports it;
it does not make Kitty an iTerm2 terminal or give arbitrary inline images
reliable redraw after layout changes. Prefer Kitty placeholders in Kitty.
Verify images in regular panes; popup rendering has different limitations.

Nixpkgs also enables SIXEL with `--enable-sixel` in its tmux package, but this
does not add SIXEL support to Kitty. The build flag is documented in upstream
[`configure.ac`](https://github.com/tmux/tmux/blob/3.7c/configure.ac).
It is not required for the Kitty graphics protocol.

Existing tmux servers need a reload for bindings and a fresh session/panes for
changed terminal/environment settings. Keep any active work intact: detach and
start a separate server with `tmux -L fresh new-session -s main` to test a fresh
configuration without terminating existing sessions.
