#!/usr/bin/env bash
# OLS network helpers

OLS_DIR="$HOME/OLS"
STATE_FILE="$OLS_DIR/lib/network.state"

ols_network_online() {
    [[ -f "$STATE_FILE" ]] && [[ "$(cat "$STATE_FILE")" == "online" ]]
}
