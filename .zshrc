#
# Executes commands at the start of an interactive session.
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

setopt IGNOREEOF

# lang, english
export LANG=C

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
chpwd() { ls -all }

# delete ctrl-w
autoload -U select-word-style
select-word-style bash

# use ctrl-y
function cd-up { zle push-line && LBUFFER='builtin cd ..' && zle accept-line }
zle -N cd-up
bindkey "^Y" cd-up

setopt +o nomatch

# ailas
alias la='ls -all'
alias l='ls -all'
alias e='open /Applications/Emacs.app'
alias j='jupyter lab'
alias o='open ./'
alias gs='git status'
alias ga='git add'
alias gp='git push'
gm () {
    msg=$@
    git commit -m "$msg"
}
alias rebuild='cd ..;rm -rf build; mkdir build; cd build; cmake ..; make'
alias m='make'
alias mb='make -C build'
alias s='source ~/.zshrc'

# latex
alias lmk='latexmk --pvc'
alias latexclear='rm -rvf *.aux *.bbl *.blg *.fdb_latexmk *.fls *.loa *.lof *.log *.lot *.out *.toc'

if [ -e "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# additional commands
export PATH="$HOME/.mybin/:$PATH"

# add customer alias
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
