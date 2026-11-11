function detach
    nohup $argv >/dev/null 2>&1 &
    disown
end

function fish_greeting
end

if status is-interactive
    alias ".." "cd .."
    alias "..." "cd ../.."
    alias commit "git commit"
    alias cp "cp -r"
    alias fetch "git fetch"
    alias jctl "journalctl -p 3 -xb"
    alias ls "eza -al --color=always --group-directories-first --icons=always"
    alias lt "eza -aT --color=always --group-directories-first --icons=always"
    alias ns nix-shell
    alias psmem "ps auxf | sort -nr -k 4"
    alias psmem10 "ps auxf | sort -nr -k 4 | head -10"
    alias pull "git pull"
    alias push "git push"
    alias rm "rm -rf"
    alias scp "sudo cp -r"
    alias srm "sudo rm -rf"
    alias sv "sudo nvim"
    alias tarnow "tar -acf "
    alias untar "tar -zxvf "
    alias v nvim
    alias wget "wget -c "
    alias yz yazi
end
