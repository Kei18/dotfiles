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

# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# cargo
curl https://sh.rustup.rs -sSf | sh

# zoxide
cargo install --locked \
      zoxide \
      fd-find \
      starship \
      du-dust \
      bat \
      eza \
      git-delta \
      pueue \
      bandwhich \
      lolcat

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# sudo apt install -y \
#      fonts-firacode \
#      figlet \
#      lolcat \
#      tree

source ~/.zshrc
