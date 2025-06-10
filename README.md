
# Automated Internet Speed Monitoring and Nest WiFi Reboot Script

## Project Goal

Automatically reboot Google Nest WiFi if internet speed drops below 50 Mbps, once daily at 2:00 AM,
and send a Telegram alert when a reboot occurs. All events are logged on a Raspberry Pi.

---

## Completed Setup Summary

### 1. Installed `python-kasa` in a Virtual Environment
```bash
sudo apt install python3-venv -y
python3 -m venv ~/kasa-venv
source ~/kasa-venv/bin/activate
pip install python-kasa[shell]
```

---

### 2. Discovered the Kasa Plug
Confirmed the plug was reachable:
```bash
kasa discover
```
Plug IP: `192.168.86.35`

---

### 3. Tested Plug Control
```bash
kasa --host 192.168.86.35 off
sleep 5
kasa --host 192.168.86.35 on
```

---

### 4. Created and Wrote `monitor_wifi.sh`
Features:
- Activates virtual environment
- Runs `speedtest-cli`
- Compares speed to 50 Mbps threshold
- Power-cycles the smart plug
- Sends Telegram alert
- Logs results to `~/monitor_wifi.log`

---

### 5. Added Error Handling
Handles `speedtest-cli` failures:
- Checks if result is numeric
- Avoids crash from empty values
- Logs graceful "skipped" messages

---

### 6. Created Telegram Bot
- Created via `@BotFather`
- Bot token: (secured)
- Chat ID: `#########`
- Verified message delivery

---

### 7. Scheduled Daily Cron Job
Runs the script at 2:00 AM daily:
```bash
0 2 * * * /home/marox/monitor_wifi.sh >> /home/marox/monitor_wifi.log 2>&1
```
---

## 🔧 Optional Next Enhancements

| Feature | Benefit |
|--------|---------|
| 📊 Speed trend logging | Store history in CSV or SQLite |
| 🔁 Log rotation | Avoid log bloat over time |
| 🧠 Retry logic | Re-run test if speed check fails |
| 🌍 Switch to Ookla CLI | Improve speedtest reliability |

---

## ✅ Status: Fully Operational

This setup is running on your Raspberry Pi and will automatically restart your Nest WiFi router
and notify you on Telegram if your speed drops below the threshold.
