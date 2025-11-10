#!/bin/bash

# ==============================
# System Health Monitoring Script for EC2
# ==============================
# Author: Swarup Meshram
# Description: Checks CPU, Memory, Disk usage, and Running Processes.
# Logs alerts if thresholds are exceeded.

LOG_FILE="/var/log/system_health.log"
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# CPU Usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
CPU_USAGE=${CPU_USAGE%.*}

# Memory Usage
MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
MEM_USAGE=${MEM_USAGE%.*}

# Disk Usage
DISK_USAGE=$(df -h / | grep '/' | awk '{print $5}' | sed 's/%//')

# Process Count
PROC_COUNT=$(ps -e --no-headers | wc -l)

log_message "Checking System Health on EC2 Instance..."
log_message "CPU Usage: $CPU_USAGE%"
log_message "Memory Usage: $MEM_USAGE%"
log_message "Disk Usage: $DISK_USAGE%"
log_message "Running Processes: $PROC_COUNT"

# Threshold checks
if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
    log_message "⚠️ ALERT: CPU usage exceeded $CPU_THRESHOLD% (Current: $CPU_USAGE%)"
fi

if [ "$MEM_USAGE" -gt "$MEM_THRESHOLD" ]; then
    log_message "⚠️ ALERT: Memory usage exceeded $MEM_THRESHOLD% (Current: $MEM_USAGE%)"
fi

if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    log_message "⚠️ ALERT: Disk usage exceeded $DISK_THRESHOLD% (Current: $DISK_USAGE%)"
fi

log_message "✅ System health check completed successfully."
