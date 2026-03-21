#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

printf "If you really want to install this script, it may modify your shell files [N/y]: "
read "${confirm:-N}"

if [[ confirm == 'n' || confirm == 'N' ]]; then
    echo "canceled"
fi

REPO="artemkolba321-spec/OLS"
SHELL_NAME="$(basename "$SHELL")"
echo "[OLS] Installing..."

# ===== deps =====
for cmd in curl tar; do
    command -v "$cmd" >/dev/null || { echo "Missing $cmd"; exit 1; }
done

TMP_DIR="$(mktemp -d)"

echo "[OLS] Fetching latest LTS..."

LATEST_TAG=$(curl -s "https://api.github.com/repos/$REPO/tags" | \
    grep '"name":' | grep 'lts' | head -n1 | sed -E 's/.*"([^"]+)".*/\1/')

[[ -z "$LATEST_TAG" ]] && { echo "Failed to fetch LTS"; exit 1; }

echo "[OLS] Latest: $LATEST_TAG"

# ===== download =====
echo "[OLS] Downloading..."
wget "https://github.com/$REPO/archive/refs/tags/$LATEST_TAG.tar.gz"

# ===== extract =====
echo "[OLS] Extracting..."
tar -xzf "$ARCHIVE" -C "$TMP_DIR"

SRC_DIR="$TMP_DIR/$LATEST_TAG"
cd "$SRC_DIR"

# ===== install =====
echo "[OLS] Installing..."

if command -v make >/dev/null; then
    make reinstall
else
    echo "[OLS] make not found, fallback install"
    exit 1
fi

# ===== cleanup =====
rm -rf "$TMP_DIR"

echo "[OLS] Installed successfully!"

# ===== PATH check =====
if [[ ":$PATH:" != *":$HOME/.local/share/OLS/bin:"* ]]; then
    echo
    echo "[WARNING] ~/.local/share/OLS/bin is not in PATH"
    echo 'export PATH="$HOME/.local/share/OLS/bin:$PATH"' >> "$SHELL_NAME"
fi

echo 'source "$HOME/.local/share/OLS/lib/env.sh"' >> "$SHELL_NAME"

echo "[OLS] Done!"