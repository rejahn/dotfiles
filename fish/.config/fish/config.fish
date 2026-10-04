set -g fish_greeting

if test -d ~/.local/bin
    fish_add_path -g ~/.local/bin
end

if test -d ~/.nix-profile/bin
    fish_add_path -g ~/.nix-profile/bin
end



set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx FZF_CTRL_R_OPTS "--with-nth 3.. --bind 'alt-t:change-with-nth(2..|1,3..|3..)'"

if test -f ~/.cargo/env.fish
    source ~/.cargo/env.fish
end

/home/renan/.local/bin/mise activate fish | source

if command -sq zoxide
    zoxide init fish | source
end

if command -sq direnv
    direnv hook fish | source
end

if command -sq fzf
    fzf --fish | source
end

# Replace ls with eza
alias ls='eza -al --color=always --group-directories-first'
alias la='eza -a --color=always --group-directories-first'
alias ll='eza -l --color=always --group-directories-first'
alias lt='eza -aT --color=always --group-directories-first'
alias l.="eza -a | grep -e '^\.'"

# Aliases
alias ..='cd ..'
alias ...='cd ../..'
alias lg='lazygit'
alias vim='nvim'
alias htop='btop'
alias bw="flatpak run --command=bw com.bitwarden.desktop"
alias oc='opencode'
alias zj='zellij'
