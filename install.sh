#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

REPO="artemkolba321-spec/OLS"
echo "[OLS] Installing..."

# ===== Confirm =====
printf "This will modify your shell config. Continue? [y/N]: "
read confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo
    echo "[OLS] Canceled"
    exit 0
fi

# ===== Dependencies =====
for cmd in wget tar make; do
    command -v "$cmd" >/dev/null || { echo "Missing $cmd"; exit 1; }
done

TMP_DIR="$(mktemp -d)"

# ===== Fetch latest LTS =====
echo "[OLS] Fetching latest LTS..."
LATEST_TAG=$(wget -qO- "https://api.github.com/repos/$REPO/tags" | \
    grep '"name":' | grep 'lts' | head -n1 | sed -E 's/.*"([^"]+)".*/\1/')
[[ -z "$LATEST_TAG" ]] && { echo "Failed to fetch LTS"; exit 1; }
echo "[OLS] Latest: $LATEST_TAG"

# ===== Download =====
ARCHIVE="$TMP_DIR/OLS-$LATEST_TAG.tar.gz"
echo "[OLS] Downloading..."
wget -O "$ARCHIVE" "https://github.com/$REPO/archive/refs/tags/$LATEST_TAG.tar.gz"

# ===== Extract =====
echo "[OLS] Extracting..."
tar -xzf "$ARCHIVE" -C "$TMP_DIR"
cd "$TMP_DIR"/*/ || { echo "[OLS] Failed to enter source directory"; exit 1; }

# ===== Install =====
echo "[OLS] Installing..."
make reinstall 

# ===== RC detection =====
detect_rc_file() {
    case "$(basename "$SHELL")" in
        bash) echo "$HOME/.bashrc" ;;
        zsh) echo "$HOME/.zshrc" ;;
        fish) echo "$HOME/.config/fish/config.fish" ;;
        *) echo "$HOME/.profile" ;;
    esac
}
RC_FILE="$(detect_rc_file)"

# ===== PATH update =====
LINE="export PATH=\"\$HOME/.local/share/OLS/bin:\$PATH\""
if ! grep -Fxq "$LINE" "$RC_FILE" 2>/dev/null; then
    echo "$LINE" >> "$RC_FILE"
    echo "[OLS] PATH added to $RC_FILE"
fi

# ===== env.sh =====
ENV_LINE="source \"\$HOME/.local/share/OLS/lib/env.sh\""
if ! grep -Fxq "$ENV_LINE" "$RC_FILE" 2>/dev/null; then
    echo "$ENV_LINE" >> "$RC_FILE"
    echo "[OLS] env.sh added to $RC_FILE"
fi

# ===== Cleanup =====
rm -rf "$TMP_DIR"

echo
echo "[OLS] Installed successfully!"
echo "Run: source $RC_FILE or restart your shell"