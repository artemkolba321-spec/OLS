#!/usr/bin/env bash
# Bash version of OLS daemon

set -euo pipefail
IFS=$'\n\t'

OLS_DIR="${OLS_DIR:-$HOME/OLS}"
LOG_FILE="$OLS_DIR/logs.log"
QUEUE_FILE="/tmp/ols_daemon_queue"
INTERVAL=60
FAIL_THRESHOLD=3

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [daemon] $@" >> "$LOG_FILE"
}

network_ok() {
    ping -c1 -W1 8.8.8.8 >/dev/null 2>&1
}

run_command() {
    bash -c "$@" &
}

process_queue_file() {
    [[ ! -f "$QUEUE_FILE" ]] && return

    local remaining=()
    while IFS= read -r line; do
        if network_ok; then
            run_command "$line"
            log "[OK] executed: $line"
        else
            remaining+=("$line")
        fi
    done < "$QUEUE_FILE"

    printf "%s\n" "${remaining[@]}" > "$QUEUE_FILE"
}

log "Bash daemon started with PID $$"

while true; do
    process_queue_file
    sleep "$INTERVAL"
done
