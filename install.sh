#!/bin/bash
set -u

# deploy
for f in .??*
do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".gitignore" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue

    ln -s "$f" $HOME/$f
done

# zsh
git clone --recursive https://github.com/sorin-ionescu/prezto.git "{ZDOTDIR:-$HOME}/.zprezto"

# emacs
git clone https://github.com/Kei18/spacemacs $HOME/.emacs.d

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
    test -d ~/.linuxbrew && PATH="$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH"
    test -d /home/linuxbrew/.linuxbrew && PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
    test -r ~/.zsh_profile && echo "export PATH='$(brew --prefix)/bin:$(brew --prefix)/sbin'":'"$PATH"' >>~/.zsh_profile
    echo "export PATH='$(brew --prefix)/bin:$(brew --prefix)/sbin'":'"$PATH"' >>~/.profile

    # install emacs
    brew install emacs
fi

# brew install
brew install \
     tmux \
     ag \
     aspell \
     cmigemo
