import daemon
import time
import requests
from datetime import datetime
from plyer import notification
import subprocess
import os

# Repository in the format "user/repo"
REPO = "artemkolba321-spec/OLS"
CHECK_INTERVAL = 3600  # Check every hour
LOG_FILE = os.path.expanduser("~/OLS/logs.log")

def log(message: str):
    """Write a message to the log file with a timestamp"""
    with open(LOG_FILE, 'a') as f:
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        f.write(f"{timestamp} [update_daemon] {message}\n")

def get_latest_commit():
    """Get the latest commit SHA from GitHub API"""
    url = f"https://api.github.com/repos/{REPO}/commits/main"
    try:
        response = requests.get(url)
        response.raise_for_status()
        return response.json()[0]["sha"]
    except Exception as e:
        log(f"Error fetching latest commit: {e}")
        return None

def notify(message: str):
    notification.notify(
            title="OLS update",
            message=message,
            app_name="Open Linux Shell",
            timeout=15
        )

def run():
    """Main loop of the daemon"""
    log("Update daemon started")
    last_sha = None
    while True:
        latest_sha = get_latest_commit()
        if latest_sha and latest_sha != last_sha:
            if last_sha is not None:  # Do not notify on first run
                notify(f"New update available for the repository {REPO}!")
                log(f"New update detected: {latest_sha}")
            last_sha = latest_sha
        time.sleep(CHECK_INTERVAL)

with daemon.DaemonContext():
    run()
