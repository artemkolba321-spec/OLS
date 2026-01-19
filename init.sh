#!/usr/bin/env bash
# OLS init script

set -euo pipefail
IFS=$'\n\t'

# ===== Directories =====
OLS_DIR="$HOME/OLS"
OLS_BIN="$OLS_DIR/bin"
OLS_PACKAGES="$OLS_DIR/packages"
LOG_FILE="$OLS_DIR/logs.log"
CONFIG_FILE="$HOME/.olsrc"
PROJECT_FILE="$PWD/.olsproject"

mkdir -p "$OLS_DIR"
touch "$LOG_FILE"
chmod 644 "$LOG_FILE"

ols_log() {
    local msg="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [OLS] $msg" >> "$LOG_FILE"
}

ols_log "Install started"

# ===== Create directories =====
mkdir -p "$OLS_BIN" "$OLS_PACKAGES"

# ===== Set permissions =====
# bin: user can read/write/execute, others can only execute (can't list files)
chmod 711 "$OLS_BIN"

# ===== Detect user shell =====
if [[ -n "${BASH_VERSION-}" ]]; then
    SHELL_RC="$HOME/.bashrc"
elif [[ -n "${ZSH_VERSION-}" ]]; then
    SHELL_RC="$HOME/.zshrc"
else
    SHELL_RC="$HOME/.profile"
fi

# ===== Add OLS/bin to PATH =====
PATH_LINE="export PATH=\"$OLS_BIN:\$PATH\""
if ! grep -Fxq "$PATH_LINE" "$SHELL_RC"; then
    echo "$PATH_LINE" >> "$SHELL_RC"
    echo "OLS: added $OLS_BIN to PATH in $SHELL_RC"

    ols_log "added $OLS_BIN to PATH"
fi

# ===== Create config if missing =====
if [[ ! -f "$CONFIG_FILE" ]]; then
    touch "$CONFIG_FILE"
    cat > "$CONFIG_FILE" <<'EOF'
# OLS configuration (~/.olsrc)

OLS_DIR="$HOME/OLS"
OLS_BIN="$OLS_DIR/bin"

# uedit
export EDITOR=nano
EOF
    chmod 644 "$CONFIG_FILE"
    echo "Created OLS config at $CONFIG_FILE"
    ols_log "Created config"
fi

if [[ ! -f "$PROJECT_FILE" ]]; then
    cat > "$PROJECT_FILE" <<'EOF'
# OLS project configuration

NAME="OLS"
VERSION="0.1.0"
AUTHOR="Artem"
EOF
    echo "Created .olsproject"
    ols_log "Created .olsproject in project root"
    chmod 644 "$PROJECT_FILE"
fi

# ===== Install Bash commands =====
for cmd in "$PWD/src/bin/"*; do
    base=$(basename "$cmd")
    if [[ -f "$cmd" ]]; then
        
        cp "$cmd" "$OLS_BIN/$base"
        chmod 755 "$OLS_BIN/$base"
        echo "Installed $base → $OLS_BIN/$base"
    else
        ols_log "Command installation failed: $base"
    fi
done
ols_log "Installed commands"

echo "OLS initialization complete!"
echo "Run 'source $SHELL_RC' or restart your terminal to use OLS commands."

ols_log "initialization complete"