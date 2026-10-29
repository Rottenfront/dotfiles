{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs = {
    bat.enable = true;
    eza.enable = true;
    fd.enable = true;
    fzf.enable = true;
    ripgrep.enable = true;
    jq.enable = true;

    fish = {
      loginShellInit = ''
        if not set -q TMUX; and uwsm check may-start
          exec uwsm start hyprland-uwsm.desktop
        end
      '';

      functions = {
        rename_number_dash = ''
          for file in *
              # Create new name
              set new_name (string replace -r '^([0-9]+) - ' '$1. ' -- $file)

              # Rename only if different
              if test "$file" != "$new_name"
                  mv -- "$file" "$new_name"
              end
          end
        '';
        rename_number_space = ''
          for file in *
              # Create new name
              set new_name (string replace -r '^([0-9]+) ' '$1. ' -- $file)

              # Rename only if different
              if test "$file" != "$new_name"
                  mv -- "$file" "$new_name"
              end
          end
        '';
        fish_greeting = "";
        detach = ''
          nohup $argv >/dev/null 2>&1 &
          disown
        '';

        rebuild-zenbook = "sudo nixos-rebuild switch --flake /etc/nixos#zenbook $argv";
        rebuild-aorus = "sudo nixos-rebuild switch --flake /etc/nixos#aorus $argv";
      };

      shellAliases = {
        ls = "eza -al --color=always --group-directories-first --icons=always";
        lt = "eza -aT --color=always --group-directories-first --icons=always";
        cp = "cp -r";
        scp = "sudo cp -r";
        rm = "rm -rf";
        srm = "sudo rm -rf";
        ".." = "cd ..";
        "..." = "cd ../..";
        jctl = "journalctl -p 3 -xb";
        ns = "nix-shell";
        yz = "yazi";
        v = "nvim";
        sv = "sudo nvim";
        tarnow = "tar -acf ";
        untar = "tar -zxvf ";
        wget = "wget -c ";
        psmem = "ps auxf | sort -nr -k 4";
        psmem10 = "ps auxf | sort -nr -k 4 | head -10";

        pull = "git pull";
        fetch = "git fetch";
        commit = "git commit";
        push = "git push";
      };

      shellInit = ''
        # Older sessions can inherit the Home Manager guard without OCAMLPATH.
        # Preserve library paths supplied by development shells and opam.
        if not set -q OCAMLPATH
          set -gx OCAMLPATH ${lib.escapeShellArg config.home.sessionVariables.OCAMLPATH}
        end

        # source '/home/rtfr/.opam/opam-init/init.fish'

        # format man pages
        set -x MANROFFOPT -c
        set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

        set -x PYTHONSTARTUP "$HOME/.pythonrc.py"
        set -x NODE_PATH "$HOME/.npm-packages/lib/node_modules"

        fish_add_path "$HOME/.cargo/bin/"
        fish_add_path "$HOME/.npm-packages/bin"

        fish_add_path "$HOME/.local/bin/"
        fish_add_path "$HOME/.kimi-code/bin"

        any-nix-shell fish --info-right | source
      '';
      enable = true;
    };
  };
}
