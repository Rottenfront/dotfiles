{ config, lib, pkgs, ... }:

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
        if uwsm check may-start
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
        tarnow="tar -acf ";
        untar="tar -zxvf ";
        wget="wget -c ";
        psmem="ps auxf | sort -nr -k 4";
        psmem10="ps auxf | sort -nr -k 4 | head -10";

        rebuild = "sudo nixos-rebuild switch";
      };

      shellInit = ''
        # Older sessions can inherit the Home Manager guard without OCAMLPATH.
        # Preserve library paths supplied by development shells and opam.
        if not set -q OCAMLPATH
          set -gx OCAMLPATH ${lib.escapeShellArg config.home.sessionVariables.OCAMLPATH}
        end

        # format man pages
        set -x MANROFFOPT -c
        set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

        set -x PYTHONSTARTUP "$HOME/.pythonrc.py"

        fish_add_path "$HOME/.cargo/bin/"
        fish_add_path "$HOME/.local/bin/"

        test -r '/home/rtfr/.opam/opam-init/init.fish' && source '/home/rtfr/.opam/opam-init/init.fish' >/dev/null 2>/dev/null; or true

        any-nix-shell fish --info-right | source

      '';
      enable = true;
    };
  };
}
