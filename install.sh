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
        viddy
}

install_yazi() {
    if command -v yazi >/dev/null 2>&1 && command -v ya >/dev/null 2>&1; then
        return 0
    fi

    if ! command -v make >/dev/null 2>&1; then
        echo "warning: make is missing; yazi-build may fail." >&2
    fi

    if ! command -v gcc >/dev/null 2>&1; then
        echo "warning: gcc is missing; yazi-build may fail." >&2
    fi

    "$HOME/.cargo/bin/cargo" install --force yazi-build
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
            clang-format \
            cmigemo \
            figlet \
            tree \
            tmux
        return
    fi

    if is_linux && command -v apt-get >/dev/null 2>&1; then
        if [[ "$(id -u)" == "0" ]]; then
            apt-get update -y
            apt-get install -y tmux figlet tree cmigemo migemo-dict clang-format
        elif command -v sudo >/dev/null 2>&1; then
            sudo apt-get update -y
            sudo apt-get install -y tmux figlet tree cmigemo migemo-dict clang-format
        else
            echo "warning: skipping apt packages (tmux/figlet/tree/cmigemo/migemo-dict/clang-format) because sudo is unavailable." >&2
        fi
    fi
}

install_fzf() {
    "$HOME/.local/bin/mise" install fzf@latest
    "$HOME/.local/bin/mise" use -g fzf@latest

    if ! command -v fzf-tmux >/dev/null 2>&1; then
        mkdir -p "$HOME/.local/bin"
        curl -fsSL https://raw.githubusercontent.com/junegunn/fzf/master/bin/fzf-tmux -o "$HOME/.local/bin/fzf-tmux"
        chmod +x "$HOME/.local/bin/fzf-tmux"
    fi
}

install_node() {
    "$HOME/.local/bin/mise" install node@lts
    "$HOME/.local/bin/mise" use -g node@lts
}

install_zsh_autosuggestions() {
    if [[ ! -d "$HOME/.zsh/zsh-autosuggestions" ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
    fi
}

install_spacemacs() {
    if [[ ! -d "$HOME/.emacs.d" ]]; then
        git clone https://github.com/syl20bnr/spacemacs "$HOME/.emacs.d"
    fi
}

failures=()

run_step() {
    local name="$1"
    shift

    if ! "$@"; then
        echo "warning: ${name} failed; continuing." >&2
        failures+=("$name")
    fi
}

run_step "touch_zshrc_local" touch "$HOME/.zshrc.local"
run_step "deploy_dotfiles" deploy_dotfiles
run_step "install_prezto" install_prezto
run_step "install_tpm" install_tpm
run_step "ensure_rustup" ensure_rustup
run_step "ensure_mise" ensure_mise
run_step "install_node" install_node
run_step "install_cargo_tools" install_cargo_tools
run_step "install_yazi" install_yazi
run_step "install_os_packages" install_os_packages
run_step "install_fzf" install_fzf
run_step "install_zsh_autosuggestions" install_zsh_autosuggestions
run_step "install_spacemacs" install_spacemacs

if ((${#failures[@]} > 0)); then
    printf "installation done (with failures): %s\n" "${failures[*]}" >&2
    exit 1
fi

echo "installation done"
