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

if [ "$(uname)" == 'Darwin' ]; then
    # homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # install emacs
    brew tap d12frosted/emacs-plus
    brew install emacs-plus@28 --with-spacemacs-icon
    brew link emacs-plus
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    # linuxbrew
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    test -d ~/.linuxbrew && echo "export PATH=$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH" >> ~/.zshrc.local
    test -d /home/linuxbrew/.linuxbrew && echo "export PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH" >> ~/zshrc.local
    # install emacs
    brew install emacs
fi

# brew install, common
brew install \
     tmux \
     htop \
     ag \
     aspell \
     cmigemo \
     figlet \
     lolcat
