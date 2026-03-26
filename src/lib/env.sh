# ===== Paths =====
OLS_DIR="$HOME/.local/share/OLS"
LOG_FILE="$OLS_DIR/logs.log"


export OLS_VERSION=$(cat "$OLS_DIR/.version" || echo "Unknown")
export LOG_LEVEL="${LOG_LEVEL:-INFO}"

info() {
    [[ "$LOG_LEVEL" == "INFO" ]] && \
    echo "$(date '+%Y-%m-%d %H:%M:%S') [OLS][INFO] $@" >> "$LOG_FILE"
}

warn() {
    [[ "$LOG_LEVEL" == "INFO" || "$LOG_LEVEL" == "WARN" ]] && \
    echo "$(date '+%Y-%m-%d %H:%M:%S') [OLS][WARN] $@" >> "$LOG_FILE"
}

ee() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [OLS][EE] $@" >> "$LOG_FILE"
    exit 1
}

panic() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [OLS][PANIC] $@" >> "$LOG_FILE"
    exit 1
}