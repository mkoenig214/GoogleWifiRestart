#!/bin/bash

# Configuration
THRESHOLD=50
PLUG_IP="192.168.86.35"
VENV_PATH="/home/marox/kasa-venv"
KASA_CMD="${VENV_PATH}/bin/kasa"
LOG_FILE="/home/marox/monitor_wifi.log"

# Telegram settings
BOT_TOKEN="##########:abcdefghijklmnop"
CHAT_ID="#########"

# Logging function
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "${LOG_FILE}"
}

# Activate the virtual environment
source "${VENV_PATH}/bin/activate"

# Run speed test and extract download speed in Mbps
DOWNLOAD=$(speedtest --simple 2>/dev/null | grep "Download" | awk '{print int($2)}')

# Check if speed was successfully retrieved
if [[ "$DOWNLOAD" =~ ^[0-9]+$ ]]; then
  log "Download speed is ${DOWNLOAD} Mbps"

  if [ "$DOWNLOAD" -lt "$THRESHOLD" ]; then
    log "⚠️ Speed below ${THRESHOLD} Mbps — rebooting Nest WiFi..."

    ${KASA_CMD} --host "${PLUG_IP}" off && log "Plug turned off"
    sleep 10
    ${KASA_CMD} --host "${PLUG_IP}" on && log "Plug turned on"

    MESSAGE="🚨 Speed dropped below ${THRESHOLD} Mbps at $(date). Nest WiFi was rebooted."

    log "Sending Telegram notification"
    curl -s -X POST https://api.telegram.org/bot${BOT_TOKEN}/sendMessage \
        -d chat_id="${CHAT_ID}" \
        -d text="${MESSAGE}" >> "${LOG_FILE}" 2>&1
    log "Telegram notification sent"
  fi
else
  log "❌ Failed to retrieve download speed — skipping reboot"
fi
