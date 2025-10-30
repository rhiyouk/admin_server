#!/bin/bash
#=========================================
# Script Name: system_dashboard.sh
# Author: riuk
# Description: Afficher un tableau de bord système en temps réel.
# Date: 2024-06-15
#=========================================

# 🎨 Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE="\e[34m"
RESET='\033[0m'

# ⚙️ Seuils critiques
CPU_THRESHOLD=80
RAM_THRESHOLD=80
DISK_THRESHOLD=90

# Fonction pour afficher les statistiques système
function display_stats() {
    echo -e "${BLUE}==================== SYSTEM DASHBOARD ====================${RESET}"
    echo -e "🕒 $(date '+%Y-%m-%d %H:%M:%S')"
    echo "-----------------------------------------------------------"

    # CPU Usage
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
    CPU_INT=${CPU_USAGE%.*}
    if [ "$CPU_INT" -gt "$CPU_THRESHOLD" ]; then
        echo -e "CPU Usage: ${RED}${CPU_INT}%${RESET} ⚠️"
    else
        echo -e "CPU Usage: ${GREEN}${CPU_INT}%${RESET} ✅"
    fi

    # RAM Usage
    RAM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    RAM_INT=${RAM_USAGE%.*}
    if [ "$RAM_INT" -gt "$RAM_THRESHOLD" ]; then
        echo -e "RAM Usage: ${RED}${RAM_INT}%${RESET} ⚠️"
    else
        echo -e "RAM Usage: ${GREEN}${RAM_INT}%${RESET} ✅"
    fi

    # Disk Usage
    DISK_USAGE=$(df -h | grep '/$' | awk '{print $5}' | sed 's/%//')
    if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
        echo -e "Disk Usage: ${RED}${DISK_USAGE}%${RESET} ⚠️"
    else
        echo -e "Disk Usage: ${GREEN}${DISK_USAGE}%${RESET} ✅"
    fi

    echo "-----------------------------------------------------------"
    echo -e "${YELLOW}Top 5 Processes:${RESET}"
    ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6 | awk '{printf "%-8s %-20s %-8s %-8s\n", $1, $2, $3, $4}'
    echo "-----------------------------------------------------------"
    echo -e "${BLUE}Actualisation automatique toutes les 5 secondes...${RESET}"
}

#  🔁 Boucle infinie pour actualiser le tableau de bord
while true; do
    display_stats
    sleep 5
done