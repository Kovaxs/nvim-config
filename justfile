# Neovim config ops. Run `just` to list recipes.

# Mason binaries (stylua, luacheck, ...) are not always on PATH in a plain shell.
mason_bin := env_var_or_default('HOME', '.') + '/.local/share/nvim/mason/bin'
export PATH := mason_bin + ':' + env_var_or_default('PATH', '')

# Pinned Neovim release (config requires 0.12+ for vim.pack).
nvim_version := 'v0.12.6'

# Default: list recipes
default:
    @just --list

# Link config into ~/.config/nvim (idempotent)
setup:
    mkdir -p "$HOME/.config"
    ln -sfn "$HOME/nvim-config/nvim" "$HOME/.config/nvim"
    @echo "Config linked to $HOME/.config/nvim"

# Install pinned Neovim release
install-nvim:
    #!/bin/bash
    set -euo pipefail

    INSTALL_DIR="$HOME/.local/bin"
    MACOS_INSTALL_PATH="$HOME/.local/share/nvim-{{nvim_version}}"

    OS="$(uname -s)"
    ARCH="$(uname -m)"
    echo "Detected OS: $OS"
    echo "Detected Arch: $ARCH"

    if [ "$OS" = "Linux" ]; then
        ASSET_NAME="nvim-linux-x86_64.appimage"
        TARGET_FILE="$INSTALL_DIR/nvim"
    elif [ "$OS" = "Darwin" ]; then
        ASSET_NAME="nvim-macos-${ARCH}.tar.gz"
        TARGET_FILE="/tmp/$ASSET_NAME"
    else
        echo "Error: Unsupported operating system: $OS"
        exit 1
    fi

    DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/{{nvim_version}}/${ASSET_NAME}"
    mkdir -p "$INSTALL_DIR"
    echo "Installing Neovim {{nvim_version}}..."
    echo "Download URL: $DOWNLOAD_URL"

    if command -v curl >/dev/null 2>&1; then
        DOWNLOAD_CMD="curl -fL -o"
    elif command -v wget >/dev/null 2>&1; then
        DOWNLOAD_CMD="wget -O"
    else
        echo "Error: Neither curl nor wget was found. Please install one to continue."
        exit 1
    fi

    if [ "$OS" = "Linux" ]; then
        echo "Downloading AppImage to $TARGET_FILE..."
        $DOWNLOAD_CMD "$TARGET_FILE" "$DOWNLOAD_URL"
        chmod +x "$TARGET_FILE"
        echo "Success! Neovim installed to $TARGET_FILE"
    else
        echo "Downloading tarball..."
        $DOWNLOAD_CMD "$TARGET_FILE" "$DOWNLOAD_URL"
        echo "Extracting to $MACOS_INSTALL_PATH..."
        mkdir -p "$MACOS_INSTALL_PATH"
        # Extract stripping the first component (usually nvim-macos-<arch>/)
        tar -xzf "$TARGET_FILE" -C "$MACOS_INSTALL_PATH" --strip-components=1
        echo "Linking binary to $INSTALL_DIR/nvim..."
        ln -sf "$MACOS_INSTALL_PATH/bin/nvim" "$INSTALL_DIR/nvim"
        rm -f "$TARGET_FILE"
        echo "Success! Neovim installed."
    fi

    echo "Verifying installation..."
    "$INSTALL_DIR/nvim" --version | head -n 1

# Show installed Neovim version
version:
    nvim --version | head -n 1

# Startup smoke test
smoke:
    nvim --headless "+qa"

# Full health check
health:
    nvim --headless "+checkhealth" "+qa"

# LSP health check
lsp-health:
    nvim --headless "+checkhealth vim.lsp" "+qa"

# Update plugins (networked)
update-plugins:
    nvim --headless "+PackUpdate" "+qa"

# Format all Lua files
fmt:
    stylua nvim/**/*.lua

# Check formatting without writing
fmt-check:
    stylua --check nvim/**/*.lua

# Lint all Lua files
lint:
    luacheck nvim

# Lint a single file: just lint-file nvim/lua/config/plugins/dap.lua
lint-file FILE:
    luacheck "{{FILE}}"

# Format a single file: just fmt-file nvim/lua/config/plugins/dap.lua
fmt-file FILE:
    stylua "{{FILE}}"

# Smoke test + formatting + lint (pre-PR gate)
check: smoke fmt-check lint
