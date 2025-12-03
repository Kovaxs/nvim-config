
#!/bin/bash

# Configuration
NVIM_VERSION="v0.11.5"
INSTALL_DIR="$HOME/.local/bin"
# For macOS installations, we need a place to extract the folders
MACOS_INSTALL_PATH="$HOME/.local/share/nvim-$NVIM_VERSION"

# Ensure the bin directory exists
mkdir -p "$INSTALL_DIR"

# Detect OS and Architecture
OS="$(uname -s)"
ARCH="$(uname -m)"

echo "Detected OS: $OS"
echo "Detected Arch: $ARCH"

# Determine download URL based on system
if [ "$OS" = "Linux" ]; then
    # On Linux, the AppImage is the easiest single-file install
    # It contains all necessary libraries and runtime files inside it.
    ASSET_NAME="nvim-linux-x86_64.appimage"
    # https://github.com/neovim/neovim/releases/download/v0.11.5/nvim-linux-x86_64.tar.gz
    DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/${ASSET_NAME}"
    TARGET_FILE="$INSTALL_DIR/nvim"

elif [ "$OS" = "Darwin" ]; then
    # macOS (Darwin)
    ASSET_NAME="nvim-macos-${ARCH}.tar.gz"
    # Fallback for older naming conventions if needed, but modern nvim uses structure above
    # Note: If v0.11.5 uses universal binary, this might need adjustment,
    # but strictly following current release patterns:
    DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/${ASSET_NAME}"
    TARGET_FILE="/tmp/$ASSET_NAME"
else
    echo "Error: Unsupported operating system: $OS"
    exit 1
fi

echo "Installing Neovim $NVIM_VERSION..."
echo "Download URL: $DOWNLOAD_URL"

# Check if curl or wget is available
if command -v curl >/dev/null 2>&1; then
    DOWNLOAD_CMD="curl -L -o"
elif command -v wget >/dev/null 2>&1; then
    DOWNLOAD_CMD="wget -O"
else
    echo "Error: Neither curl nor wget was found. Please install one to continue."
    exit 1
fi

# ----------------------
# LINUX INSTALLATION
# ----------------------
if [ "$OS" = "Linux" ]; then
    echo "Downloading AppImage to $TARGET_FILE..."
    $DOWNLOAD_CMD "$TARGET_FILE" "$DOWNLOAD_URL"

    if [ $? -eq 0 ]; then
        chmod +x "$TARGET_FILE"
        echo "Success! Neovim installed to $TARGET_FILE"
    else
        echo "Error downloading file. Please check the version number and your internet connection."
        rm -f "$TARGET_FILE"
        exit 1
    fi

# ----------------------
# MACOS INSTALLATION
# ----------------------
elif [ "$OS" = "Darwin" ]; then
    echo "Downloading tarball..."
    $DOWNLOAD_CMD "$TARGET_FILE" "$DOWNLOAD_URL"

    if [ $? -eq 0 ]; then
        echo "Extracting to $MACOS_INSTALL_PATH..."
        mkdir -p "$MACOS_INSTALL_PATH"
        # Extract stripping the first component (usually nvim-macos-x86_64/)
        tar -xzf "$TARGET_FILE" -C "$MACOS_INSTALL_PATH" --strip-components=1

        # Create Symlink
        echo "Linking binary to $INSTALL_DIR/nvim..."
        ln -sf "$MACOS_INSTALL_PATH/bin/nvim" "$INSTALL_DIR/nvim"

        # Cleanup
        rm "$TARGET_FILE"
        echo "Success! Neovim installed."
    else
        echo "Error downloading file."
        exit 1
    fi
fi

# Verify installation
echo "Verifying installation..."
"$INSTALL_DIR/nvim" --version | head -n 1

echo ""
echo "Make sure $INSTALL_DIR is in your PATH:"
echo "export PATH=\"$INSTALL_DIR:\$PATH\""
