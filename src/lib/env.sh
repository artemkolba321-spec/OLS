# ===== Paths =====
OLS_DIR="$HOME/.local/share/OLS"
LOG_FILE="$OLS_DIR/logs.log"


export OLS_VERSION=$(cat "$OLS_DIR/.version" || echo "Unknown")
info() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [OLS]["$(basename "$0")"][INFO] $@" >> "$LOG_FILE"
}

warn() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [OLS]["$(basename "$0")"][WARN] $@" >> "$LOG_FILE"
}

ee() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [OLS]["$(basename "$0")"][EE] $@" >> "$LOG_FILE"
    exit 1
}

panic() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [OLS]["$(basename "$0")"][PANIC] $@" >> "$LOG_FILE"
    exit 1
}
