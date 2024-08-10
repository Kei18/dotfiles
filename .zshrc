#
# Executes commands at the start of an interactive session.
#

alias l='ls -all -l'

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

setopt IGNOREEOF

# lang, english
export LANG=en_US.UTF-8

# auto complete
autoload -Uz compinit
compinit

# command correction
setopt correct

# emacs
bindkey -e

# no beep
setopt nobeep

# omit cd
setopt auto_cd

# history
HISTFILE=$HOME/.zsh_history # file
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt share_history
setopt hist_no_store
setopt hist_reduce_blanks
setopt hist_verify

# after cd then ls -all
chpwd() { eza -a  -l }

# delete ctrl-w
autoload -U select-word-style
select-word-style bash

# use ctrl-y
function cd-up { zle push-line && LBUFFER='builtin cd ..' && zle accept-line }
zle -N cd-up
bindkey "^Y" cd-up

setopt +o nomatch

# ailas
alias l='eza -a -l'
case ${OSTYPE} in
  # macOS
    darwin*)
        alias cat='bat'
        ;;
    linux*)
        alias cat='bat'
        ;;
esac
alias e='emacs -nw'
alias j='jupyter lab'
alias o='open ./'
alias gs='git status'
alias ga='git add'
alias gp='git push'
alias gu='git git restore --staged'
gm () {
    msg=$@
    git commit -m "$msg"
}
alias gd='git diff'
alias rebuild='cd ..;rm -rf build; mkdir build; cd build; cmake ..; make'
alias m='make'
alias mb='make -C build'
alias s='source ~/.zshrc'

alias q='pueue'
alias qa='pueue add --'
alias qfl='pueue follow'
alias qcl='pueue clean'

export FZF_TMUX=1
alias fp="fzf-tmux -p 60%"
# fbr - checkout git branch (including remote branches)
fbr() {
    local branches branch
    branches=$(git branch --all | grep -v HEAD) &&
        branch=$(echo "$branches" |
                     fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
        git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fh - repeat history
fh() {
    eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

# flog - git commit browser
# ref: https://qiita.com/kamykn/items/aa9920f07487559c0c7e
flog() {
    git log --graph --color=always \
        --format="%C(auto)%h%d %s %C(#C0C0C0)%C(bold)%cr" "$@" |
        fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
            --bind "ctrl-m:execute:
              (grep -o '[a-f0-9]\{7\}' | head -1 |
              xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
              {}
              FZF-EOF
             "
}

alias gb='fbr'
alias gl='flog'
alias h='fh'
alias gd="git diff"
alias pc="pre-commit"

# yazi
function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
    echo -ne "\e[4 q"
}
echo -ne "\e[4 q"  # not sure this is correct...

# latex
alias lmk='latexmk --pvc'
alias latexclear='rm -rvf *.aux *.bbl *.blg *.fdb_latexmk *.fls *.loa *.lof *.log *.lot *.out *.toc'

if [ -e "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# additional commands
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.mybin/:$PATH"

eval "$(zoxide init zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# starship
export STARSHIP_CONFIG=~/.starship.toml
eval "$(starship init zsh)"

# auto suggestion
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# add customer alias
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
