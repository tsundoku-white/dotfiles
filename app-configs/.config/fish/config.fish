set -g fish_greeting ""
alias ls="ls --color=auto"
alias ll="eza -l" # or ls -la


if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
end
