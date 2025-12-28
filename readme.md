Dotfiles
---

Set zsh as your login shell:
```sh
chsh -s $(which zsh)
```

## install

```sh
git clone --recursive https://github.com/Kei18/dotfiles $HOME/dotfiles
cd dotfiles
bash ./install.sh
```

- `mise` is used to install `fzf` (and can be extended for other tools).

## ssh login

```sh
ssh-copy-id user@addr
```

## github setup

```sh
ssh-keygen -t ed25519 -C keisuke.oku18@gmail.com
eval "$(ssh-agent -s)"
cat ~/.ssh/id_ed25519.pub
```

and visit https://github.com/settings/ssh/new

```
ssh -T git@github.com
```

## often used

- zsh
- emacs
- tmux
- htop
- boost
- eigen
- pyenv
- pueue
- starship
- nvm
- juliaup
- clang-format
- https://github.com/sindresorhus/quick-look-plugins
- latex
- pyright


## pip

```sh
pip install \
    black \
    isort \
    lckr-jupyterlab-variableinspector \
    jupyterlab-code-formatter \
    jupyterlab-lsp \
    jupyter-archive
```
