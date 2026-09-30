#!/bin/bash

# Navigate securely into your git workspace directory
cd /home/paul/projects/centos-system-monitor || exit 1

# Define our file paths
SNAPSHOT_FILE="cpu_info.txt"
HISTORY_FILE="cpu_history.log"
TIMESTAMP="$(date +'%Y-%m-%d %H:%M:%S')"

# --- 1. COLLECT EXTENDED SYSTEM PERFORMANCE METRICS ---

# Get standard CPU statistics (Load average for 1, 5, and 15 minutes)
CPU_LOAD=$(cat /proc/loadavg | awk '{print "1-min: " $1 ", 5-min: " $2 ", 15-min: " $3}')

# Get RAM Usage info (Total, Used, Free, and % Used)
RAM_INFO=$(free -m | awk 'NR==2{printf "Total: %sMB | Used: %sMB | Free: %sMB | Usage: %.2f%%", $2, $3, $4, $3*100/$2}')

# Get Main Disk Space utilization (Looks at root partition /)
DISK_INFO=$(df -h / | awk 'NR==2{printf "Total: %s | Used: %s | Available: %s | Usage: %s", $2, $3, $4, $5}')


# --- 2. UPDATE THE SNAPSHOT FILE (For GitHub) ---
echo "==========================================" > "$SNAPSHOT_FILE"
echo "        SYSTEM PERFORMANCE SNAPSHOT       " >> "$SNAPSHOT_FILE"
echo "==========================================" >> "$SNAPSHOT_FILE"
echo "Timestamp:   $TIMESTAMP" >> "$SNAPSHOT_FILE"
echo "CPU Load:    $CPU_LOAD" >> "$SNAPSHOT_FILE"
echo "RAM Memory:  $RAM_INFO" >> "$SNAPSHOT_FILE"
echo "Disk Space:  $DISK_INFO" >> "$SNAPSHOT_FILE"
echo -e "\n--- Core Hardware Info ---" >> "$SNAPSHOT_FILE"
lscpu | grep -E "Architecture|CPU\(s\):|Model name|CPU MHz" >> "$SNAPSHOT_FILE"


# --- 3. UPDATE THE LOCAL HISTORY FILE (Appends continuously) ---
echo -e "\n[ $TIMESTAMP ] LOAD: { $CPU_LOAD } | RAM: { $RAM_INFO } | DISK: { $DISK_INFO }" >> "$HISTORY_FILE"


# --- 4. HANDLE THE AUTOMATED GIT FLOW ---
/usr/bin/git add "$SNAPSHOT_FILE"
/usr/bin/git commit -m "chore(auto): performance metrics sync $TIMESTAMP"
/usr/bin/git push origin master
