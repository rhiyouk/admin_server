#!/bin/bash 
#=========================================
# Script Name: monitor_system.sh
# Description: Monitors system performance and logs CPU and memory usage.
# Date: 2024-06-15
# Author: riuk
#=========================================

# 🎨 Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# 📁 Chemins
PROJECT_OWNER=$(logname)
BASE_PATH="/home/$PROJECT_OWNER/admin"
LOGS_PATH="$BASE_PATH/logs"
LOG_FILE="$LOGS_PATH/system_monitor.log"

#  📅 Date
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# 🔍 Seuils critiques
CPU_THRESHOLD=80
RAM_THRESHOLD=80
DISK_THRESHOLD=90

# ========================================
# Vérification CPU
# ========================================
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
CPU_INT=${CPU_USAGE%.*}

if [ "$CPU_INT" -gt "$CPU_THRESHOLD" ]; then
    echo -e "${RED}Alerte CPU : ${CPU_INT}% utilisé !${RESET}"
    echo "$DATE - ⚠️ CPU à ${CPU_INT}% d’utilisation" >> "$LOG_FILE"
else
    echo -e "${GREEN}CPU OK : ${CPU_INT}%${RESET}"
fi  

# ========================================
# Vérification RAM
# ========================================
RAM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
RAM_INT=${RAM_USAGE%.*}

if [ "$RAM_INT" -gt "$RAM_THRESHOLD" ]; then
    echo -e "${RED}Alerte RAM : ${RAM_INT}% utilisé !${RESET}"
    echo "$DATE - ⚠️ RAM à ${RAM_INT}% d’utilisation" >> "$LOG_FILE"
else
    echo -e "${GREEN}RAM OK : ${RAM_INT}%${RESET}"
fi

# ========================================
# Vérification Disque
# ========================================
DISK_USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//g')
if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    echo -e "${RED}Alerte Disque : ${DISK_USAGE}% utilisé !${RESET}"
    echo "$DATE - ⚠️ Disque à ${DISK_USAGE}% d’utilisation" >> "$LOG_FILE"
else
    echo -e "${GREEN}Disque OK : ${DISK_USAGE}%${RESET}"
fi  

# ========================================
# Fin du script
# ========================================
echo -e "${YELLOW}Surveillance terminée. Logs enregistrés dans $LOG_FILE${RESET}"