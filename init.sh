#!/usr/bin/env bash
# OLS init script

set -euo pipefail
IFS=$'\n\t'

# ===== Paths =====
OLS_DIR="$HOME/OLS"
OLS_BIN="$OLS_DIR/bin"
OLS_LIB="$OLS_DIR/lib"
OLS_SBIN="$OLS_DIR/sbin"
LOG_FILE="$OLS_DIR/logs.log"
CONFIG_FILE="$HOME/.olsrc"
PROFILE_FILE="$HOME/.profile"
DAEMON="$OLS_LIB/daemon.sh"

# ===== Logging =====
ols_log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [OLS] $*" >> "$LOG_FILE"
}

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
mkdir -p "$OLS_DIR" "$OLS_BIN" "$OLS_LIB" "$OLS_SBIN"
touch "$LOG_FILE" "$CONFIG_FILE" "$PROFILE_FILE"

chmod 644 "$LOG_FILE" "$CONFIG_FILE"
chmod 711 "$OLS_BIN"
chmod 700 "$OLS_LIB"
chmod 700 "$OLS_SBIN"

ols_log "Installation started"

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
    ols_log "Added OLS/bin to PATH in $SHELL_RC"
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
    ols_log "Created default ~/.olsrc"
fi

# ===== Install bin commands =====
for cmd in "$PWD/src/bin/"*; do
    [[ -f "$cmd" ]] || continue
    base="$(basename "$cmd")"
    cp "$cmd" "$OLS_BIN/$base"
    chmod 755 "$OLS_BIN/$base"
    echo "Installed bin: $base"
    ols_log "Installed bin: $base"
done

# ===== Install lib files =====
for lib in "$PWD/src/lib/"*; do
    [[ -f "$lib" ]] || continue
    base="$(basename "$lib")"
    cp "$lib" "$OLS_LIB/$base"
    chmod 700 "$OLS_LIB/$base"
    echo "Installed lib: $base"
    ols_log "Installed lib: $base"
done

# ===== Install sbin binaries =====
for sbinfile in "$PWD/src/sbin/"*(N); do
    [[ -f "$sbin" ]] || continue
    base="$(basename "$sbin")"
    cp "$sbin" "$OLS_SBIN/$base"
    chmod 755 "$OLS_SBIN/$base"
    echo "Installed sbin: $base"
    ols_log "Installed sbin: $base"
done

# ===== Add daemon autostart to ~/.profile =====
if [[ -x "$DAEMON" ]]; then
    if ! grep -Fqx "# Start OLS daemon" "$PROFILE_FILE"; then
        cat <<'EOF' >> "$PROFILE_FILE"

# Start OLS daemon
if [ -x "$HOME/OLS/lib/daemon.sh" ] && ! pgrep -f "$HOME/OLS/lib/daemon.sh" >/dev/null; then
    "$HOME/OLS/lib/daemon.sh" &
fi
EOF
        ols_log "Added daemon autostart to ~/.profile"
    fi
fi

# ===== Done =====
echo
echo "OLS installation complete."
echo
echo "To apply changes now, run:"
echo "  source $SHELL_RC"
echo "  source $PROFILE_FILE"
echo
echo "Or just restart your terminal."

ols_log "Installation finished"
