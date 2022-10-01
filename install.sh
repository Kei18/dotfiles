#!/bin/bash
set -u
SCRIPT_DIR=$(cd $(dirname $0); pwd)

# deploy
for f in .??*
do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".gitignore" ]] && continue
    [[ "$f" == ".gitmodules" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue

    ln -s $SCRIPT_DIR/$f $HOME/$f
done

# zsh
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
touch $HOME/.zshrc.local
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if [ "$(uname)" == 'Darwin' ]; then
    echo setup Darwin
    brew install pbcopy
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    echo setup Linux
    test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
    echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/zshrc.local
    source $HOME/zshrc
fi

# brew install, common
brew install \
     tmux \
     pueue \
     ag \
     aspell \
     cmigemo \
     figlet \
     lolcat \
     tree
