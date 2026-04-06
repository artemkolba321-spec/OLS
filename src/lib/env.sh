# ===== Paths =====
OLS_DIR="$HOME/.local/share/OLS"
LOG_FILE="$OLS_DIR/logs.log"


export OLS_VERSION=$(cat "$OLS_DIR/.version" || echo "Unknown")
LOG_LEVEL="${LOG_LEVEL:-$(cat "$OLS_DIR/.loglevel" 2>/dev/null || echo INFO)}"
export LOG_LEVEL
info() {
    [[ "$LOG_LEVEL" == "INFO" ]] && \
    echo "$(date '+%Y-%m-%d %H:%M:%S') [OLS]["$(basename "$0")"][INFO] $@" >> "$LOG_FILE"
}

warn() {
    [[ "$LOG_LEVEL" == "INFO" || "$LOG_LEVEL" == "WARN" ]] && \
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
