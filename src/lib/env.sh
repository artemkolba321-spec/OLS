# OLS global var
export OLS_VERSION="0.3.3"
 
# ===== Paths =====
OLS_DIR="$HOME/.local/share/OLS"
LOG_FILE="$OLS_DIR/logs.log"

info() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [OLS]["$(basename $0)"][INFO] $@" >> "$LOG_FILE"
}

warn() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [OLS]["$(basename $0)"][WARN] $@" >> "$LOG_FILE"
}

ee() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [OLS]["$(basename $0)"][EE] $@" >> "$LOG_FILE"
    exit 1
}

