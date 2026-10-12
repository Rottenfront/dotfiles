{ lib, pkgs, ... }:

let
  directions = [
    {
      key = "h";
      code = 104;
      direction = "L";
      target = "left";
    }
    {
      key = "j";
      code = 106;
      direction = "D";
      target = "bottom";
    }
    {
      key = "k";
      code = 107;
      direction = "U";
      target = "top";
    }
    {
      key = "l";
      code = 108;
      direction = "R";
      target = "right";
    }
  ];

  # Explicit CSI-u sequences distinguish Ctrl+Shift from Ctrl, and Ctrl+h/j
  # from Backspace/Enter. They also override Kitty's window/tab/scroll shortcuts.
  sendKey = code: modifiers: "send_text all \\x1b[${toString code};${toString modifiers}u";
  kittyPaneKeys = lib.listToAttrs (
    lib.concatMap (d: [
      {
        name = "ctrl+${d.key}";
        value = sendKey d.code 5;
      }
      {
        name = "ctrl+shift+${d.key}";
        value = sendKey d.code 6;
      }
      {
        name = "ctrl+alt+${d.key}";
        value = sendKey d.code 7;
      }
    ]) directions
  );
  kittyTabKeys = lib.listToAttrs (
    map (i: {
      name = "alt+${toString (lib.mod i 10)}";
      value = sendKey (48 + lib.mod i 10) 3;
    }) (lib.range 1 10)
  );
  # Compare pixels, since terminal cells are usually taller than they are wide.
  # Fall back to a 1:2 cell aspect ratio when the terminal supplies no pixel size.
  windowPixelHeight = "#{e|*:#{window_height},#{?window_cell_height,#{window_cell_height},2}}";
  windowPixelWidth = "#{e|*:#{window_width},#{?window_cell_width,#{window_cell_width},1}}";
in
{
  programs.kitty.keybindings =
    kittyPaneKeys
    // kittyTabKeys
    // {
      "ctrl+shift+n" = sendKey 110 6;
      "ctrl+shift+t" = sendKey 116 6;
      "ctrl+shift+i" = sendKey 105 6;
    };

  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    shell = "${pkgs.fish}/bin/fish";
    baseIndex = 1;
    keyMode = "vi";
    mouse = true;
    focusEvents = true;
    escapeTime = 10;
    historyLimit = 50000;

    extraConfig = ''
      set -g renumber-windows on
      set -g set-clipboard on
      set -g status-position top
      set -g status-left '#S | '
      set -g status-right '%H:%M'
      set -g window-status-format ' #I:#W '
      set -g window-status-current-format ' [#I:#W] '

      set -s extended-keys on
      set -s extended-keys-format csi-u
      set -as terminal-features ',xterm-kitty:RGB:extkeys'

      # Yazi's documented tmux settings. Kitty uses Unicode placeholders;
      # image-aware applications must wrap graphics commands for passthrough.
      # https://yazi-rs.github.io/docs/image-preview/#tmux-users
      set -g allow-passthrough on
      set -ag update-environment ' TERM TERM_PROGRAM KITTY_WINDOW_ID'

      # Tall window: top/bottom panes. Otherwise: side-by-side panes.
      bind -n C-S-n if-shell -F '#{e|>:${windowPixelHeight},${windowPixelWidth}}' \
        'split-window -v -c "#{pane_current_path}"' \
        'split-window -h -c "#{pane_current_path}"'
      bind -n C-S-t new-window -c '#{pane_current_path}'

      # A temporary floating command shell. Exit or Ctrl+d closes it.
      bind -n C-S-i display-popup -E -w 80% -h 70% -d '#{pane_current_path}'

      ${lib.concatMapStringsSep "\n" (d: ''
        bind -n C-${d.key} select-pane -${d.direction}
        # Swap with the adjacent pane and keep focus on the moved pane.
        bind -n C-S-${d.key} swap-pane -s '{${d.target}-of}'
        bind -n C-M-${d.key} resize-pane -${d.direction} 5
      '') directions}

      ${lib.concatMapStringsSep "\n" (i: ''
        bind -n M-${toString (lib.mod i 10)} select-window -t ':${toString i}'
      '') (lib.range 1 10)}

      # Keep the usual Ctrl+b prefix for other tmux commands.
      bind r source-file ~/.config/tmux/tmux.conf \; display-message 'tmux config reloaded'
      bind '"' split-window -v -c '#{pane_current_path}'
      bind % split-window -h -c '#{pane_current_path}'
    '';
  };
}
