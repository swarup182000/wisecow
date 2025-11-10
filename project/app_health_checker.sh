#!/bin/bash

# Application Health Check Script
# This script checks whether an application is running and responding or not.
# It logs the result in a log file with a timestamp.

APP_URL="http://localhost:8080"   # Apni application ka URL yaha daalna
LOG_FILE="/var/log/app_health.log"

# Current timestamp
TIME=$(date "+%Y-%m-%d %H:%M:%S")

# Curl se HTTP status code check karna
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" $APP_URL)

# Agar log file exist nahi karti to create kar
if [ ! -f "$LOG_FILE" ]; then
    touch "$LOG_FILE"
fi

echo "$TIME - Checking application health at $APP_URL" >> "$LOG_FILE"

# Condition check
if [ "$STATUS_CODE" -eq 200 ]; then
    echo "$TIME - Application is UP (Status Code: $STATUS_CODE)" >> "$LOG_FILE"
elif [ "$STATUS_CODE" -ge 400 ] && [ "$STATUS_CODE" -lt 500 ]; then
    echo "$TIME - Application reachable but returned Client Error (Status Code: $STATUS_CODE)" >> "$LOG_FILE"
elif [ "$STATUS_CODE" -ge 500 ]; then
    echo "$TIME - Application DOWN (Server Error, Status Code: $STATUS_CODE)" >> "$LOG_FILE"
else
    echo "$TIME - Application not responding properly (Status Code: $STATUS_CODE)" >> "$LOG_FILE"
fi

echo "$TIME - Health check completed" >> "$LOG_FILE"
echo "--------------------------------------------------------" >> "$LOG_FILE"
