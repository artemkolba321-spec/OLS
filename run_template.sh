#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'


command -v zenity >/dev/null 2>&1 || {
    if command -v pacman >/dev/null 2>&1; then sudo pacman -S --noconfirm zenity
    elif command -v apt-get >/dev/null 2>&1; then sudo apt-get update && sudo apt-get install -y zenity
    elif command -v yum >/dev/null 2>&1; then sudo yum install -y zenity
    elif command -v dnf >/dev/null 2>&1; then sudo dnf install -y zenity
    else zenity --error --text="Install Zenity manually"; exit 1
    fi
}

TMP_DIR=$(mktemp -d)
ARCHIVE_LINE=$(awk '/^__ARCHIVE_BELOW__/ {print NR+1; exit 0}' "$0")
tail -n+$ARCHIVE_LINE "$0" | tar -xz -C "$TMP_DIR"

LICENSE_FILE=$(find "$TMP_DIR" -name LICENSE | head -n1)
if [ -f "$LICENSE_FILE" ]; then
    zenity --text-info --title="GNU GPL Public License 3.0" --filename="$LICENSE_FILE" --width=700 --height=500
else
    zenity --error --text="LICENSE file not found in archive"; exit 1
fi

if ! zenity --question --text="Do you accept the GPL 3.0 license?"; then
    zenity --error --text="Installation canceled"; exit 0
fi
if ! zenity --question --text="This installer may modify your shell config and install OLS. Continue?"; then
    zenity --error --text="Installation canceled"; exit 0
fi


{
    echo "10" ; sleep 0.2
    echo "# Running install script..."
    cd "$TMP_DIR"/*/
    bash install.sh
    echo "100" ; sleep 0.2
} | zenity --progress --title="Installing OLS..." --width=500 --height=100 --auto-close --pulsate

rm -rf "$TMP_DIR"

zenity --info --text="OLS installed successfully!"
exit 0

__ARCHIVE_BELOW__