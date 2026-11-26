#!/usr/bin/env bash
# Export the currently installed package list so it can be tracked in
# packages/ and reinstalled by bootstrap.sh on a new machine.
set -euo pipefail

PACKAGES_DIR="$HOME/packages"
mkdir -p "$PACKAGES_DIR"

case "$(uname -s)" in
    Linux)
        apt list --installed 2>/dev/null > "$PACKAGES_DIR/apt-packages.txt"
        echo "Wrote $PACKAGES_DIR/apt-packages.txt"
        ;;
    Darwin)
        if ! command -v brew >/dev/null 2>&1; then
            echo "Homebrew not found." >&2
            exit 1
        fi
        # 注意: packages/Brewfile は最小構成を手動管理する方針になっている。
        # このまま実行すると今installされている全パッケージで上書きされ、
        # 最小構成の意図が壊れるので、出力を必ずレビューしてから `dotfiles add` すること。
        brew bundle dump --force --file="$PACKAGES_DIR/Brewfile"
        echo "Wrote $PACKAGES_DIR/Brewfile (review the diff before committing - see comment above)"
        ;;
    *)
        echo "Unsupported OS: $(uname -s)" >&2
        exit 1
        ;;
esac
