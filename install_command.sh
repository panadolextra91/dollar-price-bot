#!/bin/bash

# Get the absolute path of the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Create a command script
cat > "$SCRIPT_DIR/usd-vnd" << 'EOF'
#!/bin/bash
# Get the absolute path of the script directory
SCRIPT_DIR="$( dirname "$( readlink -f "$0" )" )"
# Execute the show_rate.sh script
"$SCRIPT_DIR/show_rate.sh"
EOF

# Make it executable
chmod +x "$SCRIPT_DIR/usd-vnd"

# Define target directory for symlink
if [ -d "/usr/local/bin" ] && [ -w "/usr/local/bin" ]; then
    # If /usr/local/bin exists and is writable
    TARGET_DIR="/usr/local/bin"
elif [ -d "$HOME/.local/bin" ]; then
    # If $HOME/.local/bin exists (common user-level bin directory)
    TARGET_DIR="$HOME/.local/bin"
    # Make sure this directory is in the PATH
    if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc" 2>/dev/null || true
        echo "Added $HOME/.local/bin to your PATH in .bashrc and .zshrc"
    fi
else
    # Create the directory if it doesn't exist
    TARGET_DIR="$HOME/.local/bin"
    mkdir -p "$TARGET_DIR"
    # Add it to PATH
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc" 2>/dev/null || true
    echo "Created $HOME/.local/bin and added it to your PATH in .bashrc and .zshrc"
fi

# Create the symlink
ln -sf "$SCRIPT_DIR/usd-vnd" "$TARGET_DIR/usd-vnd"

echo "Command 'usd-vnd' has been installed to $TARGET_DIR"
echo "You may need to restart your terminal or run 'source ~/.bashrc' or 'source ~/.zshrc'"
echo "to use the command right away." 