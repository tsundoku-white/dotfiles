set -g fish_greeting ""
alias ls="ls --color=auto"
alias ll="eza -l" # or ls -la

function nb
    cmake -S ~/Crux -B ~/Crux/build -G Ninja -DCMAKE_BUILD_TYPE=Debug >/dev/null; or return
    cmake --build ~/Crux/build -j 12 $argv 2>&1 \
        | sed -E '/^FAILED:/d; / -MD -MT /d; /^\[[0-9]+\/[0-9]+\]/d; /^ninja: build stopped/d'
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
end
