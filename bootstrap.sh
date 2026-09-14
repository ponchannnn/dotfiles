#!/usr/bin/env bash
# Bootstrap a new machine from this dotfiles bare repository.
#
#   curl -fsSL https://raw.githubusercontent.com/<user>/dotfiles/main/bootstrap.sh | bash
#
set -euo pipefail

REPO_URL="${DOTFILES_REPO_URL:-https://github.com/ponchannnn/dotfiles.git}"
DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

dotfiles() {
    /usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"
}

log()  { printf '\033[1;32m[bootstrap]\033[0m %s\n' "$1"; }
warn() { printf '\033[1;33m[bootstrap]\033[0m %s\n' "$1"; }
err()  { printf '\033[1;31m[bootstrap]\033[0m %s\n' "$1" >&2; }

detect_os() {
    case "$(uname -s)" in
        Darwin) echo "mac" ;;
        Linux)  echo "linux" ;;
        *) err "Unsupported OS: $(uname -s)"; exit 1 ;;
    esac
}

install_packages() {
    local os="$1"
    log "Installing base packages for $os..."
    if [ "$os" = "linux" ]; then
        sudo apt update
        sudo apt install -y zsh vim tmux git curl
    elif [ "$os" = "mac" ]; then
        if ! command -v brew >/dev/null 2>&1; then
            log "Homebrew not found, installing..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install zsh vim tmux git
    fi
}

clone_dotfiles() {
    if [ -d "$DOTFILES_DIR" ]; then
        log "Dotfiles bare repo already present at $DOTFILES_DIR, skipping clone."
        return
    fi
    log "Cloning dotfiles bare repo from $REPO_URL..."
    git clone --bare "$REPO_URL" "$DOTFILES_DIR"
}

backup_conflicts() {
    log "Checking for files that would be overwritten by checkout..."
    local conflicts
    conflicts="$(dotfiles checkout 2>&1 | grep -E '^[[:space:]]+[^[:space:]]' | sed 's/^[[:space:]]*//' || true)"

    if [ -z "$conflicts" ]; then
        return
    fi

    warn "The following existing files conflict with tracked dotfiles and will be backed up to $BACKUP_DIR:"
    echo "$conflicts" | sed 's/^/  /'

    read -r -p "Proceed with backup and checkout? [y/N] " reply
    case "$reply" in
        [yY]|[yY][eE][sS]) ;;
        *) err "Aborted by user."; exit 1 ;;
    esac

    mkdir -p "$BACKUP_DIR"
    echo "$conflicts" | while IFS= read -r file; do
        [ -z "$file" ] && continue
        mkdir -p "$BACKUP_DIR/$(dirname "$file")"
        mv "$HOME/$file" "$BACKUP_DIR/$file"
    done
}

do_checkout() {
    if dotfiles checkout 2>/dev/null; then
        log "Checkout succeeded."
    else
        backup_conflicts
        dotfiles checkout
        log "Checkout succeeded after backing up conflicts to $BACKUP_DIR."
    fi
    dotfiles config --local status.showUntrackedFiles no
}

set_default_shell_to_zsh() {
    local zsh_path
    zsh_path="$(command -v zsh)"

    if [ "$SHELL" = "$zsh_path" ]; then
        log "Default shell is already zsh."
        return
    fi

    if ! grep -qx "$zsh_path" /etc/shells 2>/dev/null; then
        log "Adding $zsh_path to /etc/shells..."
        echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
    fi

    log "Changing default shell to zsh (you may be prompted for your password)..."
    chsh -s "$zsh_path" || warn "Failed to change default shell automatically; run 'chsh -s $zsh_path' manually."
}

install_from_package_list() {
    local os="$1"
    if [ "$os" = "linux" ] && [ -f "$HOME/packages/apt-packages.txt" ]; then
        log "Installing extra packages from packages/apt-packages.txt..."
        awk 'NR>1 {print $1}' "$HOME/packages/apt-packages.txt" | cut -d/ -f1 | xargs -r sudo apt install -y || \
            warn "Some packages from apt-packages.txt failed to install."
    elif [ "$os" = "mac" ] && [ -f "$HOME/packages/Brewfile" ]; then
        log "Installing extra packages from packages/Brewfile..."
        brew bundle --file="$HOME/packages/Brewfile" || warn "Some packages from Brewfile failed to install."
    else
        log "No package list found under packages/, skipping."
    fi
}

main() {
    local os
    os="$(detect_os)"
    log "Detected OS: $os"

    install_packages "$os"
    clone_dotfiles
    do_checkout
    install_from_package_list "$os"
    set_default_shell_to_zsh

    log "Done. Open a new shell (or 'exec zsh') to pick up the restored dotfiles."
}

main "$@"
