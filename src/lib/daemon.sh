#!/usr/bin/env bash
# OLS Bash daemon
# Purpose: monitor network state and write it to OLS/lib/network.state

set -euo pipefail
IFS=$'\n\t'

# ===== Paths =====
OLS_DIR="$HOME/OLS"
LIB_DIR="$OLS_DIR/lib"
LOG_FILE="$OLS_DIR/logs.log"
STATE_FILE="$LIB_DIR/network.state"
PID_FILE="$LIB_DIR/daemon.pid"

CHECK_INTERVAL=60   # seconds

# ===== Logging =====
ols_log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [OLS][daemon] $@" >> "$LOG_FILE"
}

# ===== Single instance guard =====
if [[ -f "$PID_FILE" ]]; then
    OLD_PID="$(cat "$PID_FILE" 2>/dev/null || true)"
    if [[ -n "${OLD_PID:-}" ]] && kill -0 "$OLD_PID" 2>/dev/null; then
        # already running
        exit 0
    fi
fi

echo "$$" > "$PID_FILE"
trap 'rm -f "$PID_FILE"; exit 0' INT TERM EXIT

touch "$STATE_FILE"

ols_log "daemon started (pid=$$)"

# ===== Main loop =====
while true; do
    if network_ok; then
        if [[ "$(cat "$STATE_FILE" 2>/dev/null)" != "online" ]]; then
            echo "online" > "$STATE_FILE"
            ols_log "network: online"
        fi
    else
        if [[ "$(cat "$STATE_FILE" 2>/dev/null)" != "offline" ]]; then
            echo "offline" > "$STATE_FILE"
            ols_log "network: offline"
        fi
    fi

    sleep "$CHECK_INTERVAL"
done
