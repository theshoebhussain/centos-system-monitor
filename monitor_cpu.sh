#!/bin/bash

# Navigate securely into your git workspace directory
cd /home/paul/projects/centos-system-monitor || exit 1

# Define our file paths
SNAPSHOT_FILE="cpu_info.txt"
HISTORY_FILE="cpu_history.log"
TIMESTAMP="$(date +'%Y-%m-%d %H:%M:%S')"

# 1. Update the snapshot file (Overwrites with latest data for GitHub)
echo "=== System Monitoring Metrics ===" > "$SNAPSHOT_FILE"
echo "Timestamp: $TIMESTAMP" >> "$SNAPSHOT_FILE"
lscpu >> "$SNAPSHOT_FILE"

# 2. Update the local log file (Appends data continuously, stays local)
echo -e "\n--- CPU Metrics Snapshot: $TIMESTAMP ---" >> "$HISTORY_FILE"
lscpu | grep -E "Architecture|CPU\(s\):|Model name|CPU MHz" >> "$HISTORY_FILE"

# 3. Handle the Git automated push flow for the snapshot file only
/usr/bin/git add "$SNAPSHOT_FILE"
/usr/bin/git commit -m "chore(auto): automated cpu metrics update $TIMESTAMP"
/usr/bin/git push origin master
