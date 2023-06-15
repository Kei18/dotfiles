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

source ~/.zshrc

# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# zoxide
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
echo 'export PATH="/root/.local/bin:$PATH"' >> $HOME/.zshrc.local

sudo apt install -y \
        tmux \
        figlet \
        lolcat \
        tree \
        ncdu \
        exa \
        htop \
        bat \
        git-delta \
        fzf