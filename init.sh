#!/usr/bin/bash
# OLS init script

set -euo pipefail
IFS=$'\n\t'

# ===== Configurable installation path =====
OLS_DIR="${OLS_DIR:-$HOME/OLS}"
OLS_BIN="$OLS_DIR/bin"
OLS_LIB="$OLS_DIR/lib"
OLS_SBIN="$OLS_DIR/sbin"
LOG_FILE="$OLS_DIR/logs.log"
CONFIG_FILE="$HOME/.olsrc"
PROFILE_FILE="$HOME/.profile"
PLUGINS_DIR="$OLS_DIR/plugins"
ASSETS_DIR="$OLS_DIR/assets"

# ===== Safety prompt =====
echo -e "Warning: Installing OLS may modify your shell configuration files."
printf "Are you sure you want to continue? [y/N]: "

read -r confirm || confirm=""
confirm="${confirm:-N}"
confirm="$(printf '%s' "$confirm" | tr '[:upper:]' '[:lower:]')"

if [[ "$confirm" != "y" ]]; then
    echo "Installation cancelled."
    exit 0
fi

# ===== Prepare filesystem =====
mkdir -p "$OLS_DIR" "$OLS_BIN" "$OLS_LIB" "$OLS_SBIN" "$PLUGINS_DIR" "$ASSETS_DIR"
touch "$LOG_FILE" "$CONFIG_FILE" "$PROFILE_FILE"

chmod 644 "$LOG_FILE" "$CONFIG_FILE" 
chmod 711 "$OLS_BIN" "$OLS_SBIN" "$PLUGINS_DIR"
chmod 700 "$OLS_LIB" 
chmod 751 "$ASSETS_DIR"

# ===== Detect shell =====
if [[ -n "${BASH_VERSION-}" ]]; then
    SHELL_RC="$HOME/.bashrc"
elif [[ -n "${ZSH_VERSION-}" ]]; then
    SHELL_RC="$HOME/.zshrc"
else
    SHELL_RC="$PROFILE_FILE"
fi

# ===== Add OLS/bin to PATH =====
PATH_LINE="export PATH=\"$OLS_BIN:\$PATH\""
if ! grep -Fxq "$PATH_LINE" "$SHELL_RC" 2>/dev/null; then
    echo "$PATH_LINE" >> "$SHELL_RC"
fi

ENV_LINE="source \"\$HOME/OLS/lib/env.sh\""
if ! grep -Fxq "$ENV_LINE" "$SHELL_RC" 2>/dev/null; then
    echo "$ENV_LINE" >> "$SHELL_RC"
fi

# ===== Create config if missing =====
if [[ ! -s "$CONFIG_FILE" ]]; then
    cat > "$CONFIG_FILE" <<'EOF'
# OLS configuration (~/.olsrc)

OLS_DIR="$HOME/OLS"
OLS_BIN="$OLS_DIR/bin"

# Default editor
export EDITOR=nano
EOF
fi


# ===== Install bin commands as symlinks to core =====
for cmd in "$PWD/src/bin/"*; do
    [[ -f "$cmd" ]] || continue
    base="$(basename "$cmd")"
    cp "$cmd" "$OLS_BIN/$base"
    chmod 755 "$OLS_BIN/$base"
    echo "Installed bin: $base"    
done

# ===== Install lib files =====
for lib in "$PWD/src/lib/"*; do
    [[ -f "$lib" ]] || continue
    base="$(basename "$lib")"
    cp "$lib" "$OLS_LIB/$base"
    chmod 700 "$OLS_LIB/$base"
    echo "Installed lib: $base"
done

for docs in "$PWD/docs/"*; do
    [[ -f "$docs" ]] || continue
    base="$(basename "$docs")"
    cp "$docs" "$ASSETS_DIR/$base"
    chmod 700 "$ASSETS_DIR/$base"
    echo "Installed docs: $base"
done

# ===== Add daemon auto-start =====
DAEMON_CMD="python3 $OLS_LIB/olsd.py &"
if ! grep -Fxq "$DAEMON_CMD" "$PROFILE_FILE" 2>/dev/null; then
    echo "" >> "$PROFILE_FILE"
    echo "# Start OLS update daemon on login" >> "$PROFILE_FILE"
    echo "$DAEMON_CMD" >> "$PROFILE_FILE"
    ols_log "Added update daemon to $PROFILE_FILE"
fi

# ===== Done =====
echo
echo "OLS installation complete."
echo
echo "Install required Python packages globally:"
echo "  pip install --user requests plyer python-daemon"
echo
echo "To apply changes now, run:"
echo "  source $SHELL_RC"
echo "  source $PROFILE_FILE"
echo
echo "Or just restart your terminal."