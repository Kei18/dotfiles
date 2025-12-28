#
# Executes commands at login post-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Execute code that does not affect the current session in the background.
{
    # Compile the completion dump to increase startup speed.
    zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
    if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
        zcompile "$zcompdump"
    fi
} &!

# Print a random, hopefully interesting, adage.
if (( $+commands[fortune] )); then
    if [[ -t 0 || -t 1 ]]; then
        fortune -s
        print
    fi
fi

welcome_msg="This is $(whoami) @ $(hostname)"
if command -v figlet >/dev/null 2>&1; then
    echo -e "\e[36m$(figlet "${welcome_msg}")\e[0m"
else
    echo "${welcome_msg}"
fi
