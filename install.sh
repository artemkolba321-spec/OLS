#!/usr/bin/bash

set -euo pipefail
IFS=$'\n\t'

REPO="Tipix-dev/OLS"
AUTO_YES=false
DRY_RUN=false
if [[ "${1-}" == "-y" || ${1-} == "-yes" ]]; then
    AUTO_YES=true
fi
if [[ ${1-} == "--dry-run" ]]; then
    DRY_RUN=true
    AUTO_YES=true
fi

# ===== Confirm =====
if [ "$AUTO_YES" = true ]; then
    confirm="y"
else
    read -rp "This will modify your shell config. Continue? [y/N]: " confirm < /dev/tty
fi
if [[ "$confirm" != "y" && "$confirm" != "Y"  ]]; then

    echo
    echo "[OLS] Canceled"
    exit 0
fi

# ===== Dependencies =====
for cmd in wget tar make jq; do
    command -v "$cmd" >/dev/null || { echo "Missing $cmd"; exit 1; }
done

TMP_DIR="$(mktemp -d)"

# ===== Fetch latest LTS =====
[[ $DRY_RUN == false ]] && echo "[OLS] Fetching latest LTS..."
LATEST_TAG=$(wget -qO- "https://api.github.com/repos/$REPO/tags" \
  | jq -r '.[] | select(.name | contains("lts")) | .name' \
  | head -n1)
[[ -z "$LATEST_TAG" ]] && { echo "Failed to pull LTS"; exit 1; }

# ===== Download =====
ARCHIVE="$TMP_DIR/OLS-$LATEST_TAG.tar.gz"
if [[ $DRY_RUN == false ]]; then
    echo "[OLS] Downloading..."
    wget -O "$ARCHIVE" "https://github.com/$REPO/archive/refs/tags/$LATEST_TAG.tar.gz"
fi

# ===== Extract =====
if [[ $DRY_RUN == false ]]; then
    echo "[OLS] Extracting..."
    tar -xzf "$ARCHIVE" -C "$TMP_DIR"
    cd "$TMP_DIR"/*/ || { echo "[OLS] Failed to enter source directory"; exit 1; }
fi

# ===== Install =====
if [[ $DRY_RUN == false ]]; then
    echo "[OLS] Installing..."
    make install
fi
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

[[ $DRY_RUN == false ]] && [[ -f "$RC_FILE" ]] && cp "$RC_FILE" "$RC_FILE.bak"

# ===== PATH update =====
PATH_LINE="export PATH=\"\$HOME/.local/share/OLS/bin:\$PATH\""
if [[ $DRY_RUN == false ]]; then
    if ! grep -Fxq "$PATH_LINE" "$RC_FILE" 2>/dev/null; then
        echo "$PATH_LINE" >> "$RC_FILE"
        echo "[OLS] PATH added to $RC_FILE"
    fi
fi

# ===== env.sh =====
ENV_LINE="source \"\$HOME/.local/share/OLS/lib/env.sh\""
if [[ $DRY_RUN == false ]]; then
    if ! grep -Fxq "$ENV_LINE" "$RC_FILE" 2>/dev/null; then
        echo "$ENV_LINE" >> "$RC_FILE"
        echo "[OLS] env.sh added to $RC_FILE"
    fi
fi
if [[ "$DRY_RUN" == true ]]; then
cat <<EOF
[DRY RUN MODE]

==> Installation plan

[1/5] Download:
-> $LATEST_TAG.tar.gz

[2/5] Extract archive:
-> temporary build directory

[3/5] Install OLS:
-> ~/.local/share/OLS

[4/5] Backup shell config:
-> $RC_FILE.bak

[5/5] Modify shell config:
-> append '$PATH_LINE'
-> append '$ENV_LINE'

EOF
fi
if [[ "$DRY_RUN" == true ]]; then
    echo "[OLS] Dry run completed successfully!"
else
    echo "[OLS] Installed successfully!"
    echo "Run: source $RC_FILE or restart your shell"
fi
