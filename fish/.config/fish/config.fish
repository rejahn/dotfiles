if status is-interactive
    # Commands to run in interactive sessions can go here
    tv init fish | source
    direnv hook fish | source
    zoxide init fish | source
end

alias vim="nvim"
alias zed="zeditor"
# alias cat="bat"
alias lg="lazygit"
