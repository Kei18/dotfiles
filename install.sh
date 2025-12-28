#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

is_macos() {
    [[ "$(uname -s)" == "Darwin" ]]
}

is_linux() {
    [[ "$(uname -s)" == "Linux" ]]
}

deploy_dotfiles() {
    for f in .??*; do
        [[ "$f" == ".git" ]] && continue
        [[ "$f" == ".gitignore" ]] && continue
        [[ "$f" == ".gitmodules" ]] && continue
        [[ "$f" == ".DS_Store" ]] && continue
        [[ "$f" == ".config" ]] && continue
        [[ "$f" == ".local" ]] && continue

        ln -sfn "$SCRIPT_DIR/$f" "$HOME/$f"
    done

    if [[ -d "$SCRIPT_DIR/.config" ]]; then
        mkdir -p "$HOME/.config"
        for path in "$SCRIPT_DIR/.config/"*; do
            [[ -e "$path" ]] || continue
            name="$(basename "$path")"
            ln -sfn "$path" "$HOME/.config/$name"
        done
    fi

    if [[ -d "$SCRIPT_DIR/.local/bin" ]]; then
        mkdir -p "$HOME/.local/bin"
        for path in "$SCRIPT_DIR/.local/bin/"*; do
            [[ -e "$path" ]] || continue
            name="$(basename "$path")"
            ln -sfn "$path" "$HOME/.local/bin/$name"
        done
    fi
}

install_prezto() {
    if [[ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]]; then
        git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    fi
}

install_tpm() {
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    fi
}

ensure_rustup() {
    if [[ ! -x "$HOME/.cargo/bin/cargo" ]]; then
        curl https://sh.rustup.rs -sSf | sh -s -- -y
    fi
}

ensure_mise() {
    if [[ ! -x "$HOME/.local/bin/mise" ]]; then
        curl https://mise.jdx.dev/install.sh -sSf | sh
    fi
}

install_cargo_tools() {
    "$HOME/.cargo/bin/cargo" install --locked \
        zoxide \
        fd-find \
        starship \
        du-dust \
        bat \
        eza \
        git-delta \
        pueue \
        bandwhich \
        lolcat \
        dua-cli \
        ripgrep \
        ouch \
        yazi-fm \
        yazi-cli \
        htop \
        viddy
}

ensure_brew() {
    if ! command -v brew >/dev/null 2>&1; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

install_os_packages() {
    if is_macos; then
        ensure_brew
        brew install \
            ag \
            aspell \
            figlet \
            tree \
            tmux
        return
    fi

    if is_linux && command -v apt-get >/dev/null 2>&1; then
        if [[ "$(id -u)" == "0" ]]; then
            apt-get update -y
            apt-get install -y tmux figlet tree
        elif command -v sudo >/dev/null 2>&1; then
            sudo apt-get update -y
            sudo apt-get install -y tmux figlet tree
        else
            echo "warning: skipping apt packages (tmux/figlet/tree) because sudo is unavailable." >&2
        fi
    fi
}

install_fzf() {
    "$HOME/.local/bin/mise" install fzf@latest
    "$HOME/.local/bin/mise" use -g fzf@latest
}

install_zsh_autosuggestions() {
    if [[ ! -d "$HOME/.zsh/zsh-autosuggestions" ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
    fi
}

touch "$HOME/.zshrc.local"
deploy_dotfiles
install_prezto
install_tpm
ensure_rustup
ensure_mise
install_cargo_tools
install_os_packages
install_fzf
install_zsh_autosuggestions

echo "installation done"
