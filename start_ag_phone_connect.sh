#!/bin/bash

# Antigravity Phone Connect - Mac/Linux Launcher
echo "==================================================="
echo "  Antigravity Phone Connect Launcher"
echo "==================================================="

# 1. Check for Node.js
if ! command -v node &> /dev/null
then
    echo "[ERROR] Node.js is not installed."
    echo "Please install it from https://nodejs.org/"
    exit 1
fi

# 2. Install dependencies if node_modules missing
if [ ! -d "node_modules" ]; then
    echo "[INFO] Installing dependencies..."
    npm install
fi

# 3. Get Local IP Address
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    MYIP=$(ipconfig getifaddr en0 || ipconfig getifaddr en1)
else
    # Linux
    MYIP=$(hostname -I | awk '{print $1}')
fi

echo ""
echo "[READY] Server will be available at:"
echo "      http://$MYIP:3000"
echo ""

# 4. Context Menu (Linux only - Nautilus)
# REASON: Unlike Windows (Registry), Unix-like systems use different Desktop Environments.
# macOS requires Automator (see README for manual steps). This targets Nautilus/GNOME.
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    NAUTILUS_PATH="$HOME/.local/share/nautilus/scripts"
    if [ -d "$NAUTILUS_PATH" ]; then
        echo "[CONTEXT MENU] Add 'Open with Antigravity (Debug)' to Right-Click?"
        echo "Press 'y' within 4 seconds to install, or wait to skip..."
        read -t 4 -n 1 choice
        echo ""
        if [[ "$choice" == "y" ]]; then
            SCRIPT_FILE="$NAUTILUS_PATH/Open with Antigravity (Debug)"
            echo "#!/bin/bash" > "$SCRIPT_FILE"
            echo "# Context menu script for Linux (Nautilus)" >> "$SCRIPT_FILE"
            echo "antigravity . --remote-debugging-port=9000" >> "$SCRIPT_FILE"
            chmod +x "$SCRIPT_FILE"
            echo "[SUCCESS] Installed! Right-click any folder > Scripts > Open with Antigravity (Debug)"
        fi
    fi
fi

# 5. macOS Alias Tip
# REASON: macOS 'Services/Quick Actions' require Automator. See README for step-by-step guide.
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "[TIP] For Right-Click on macOS, see README.md for Automator Quick Action setup."
    echo "[TIP] Or create a fast alias by running:"
    echo "echo \"alias ag-debug='antigravity . --remote-debugging-port=9000'\" >> ~/.zshrc && source ~/.zshrc"
    echo ""
fi

echo "[STARTING] Launching monitor server..."
node server.js
