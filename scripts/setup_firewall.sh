#!/bin/bash
# ========================================
# Script : setup_firewall.sh
# Auteur : Riuk
# Objectif : Installation et configuration d'un pare-feu basique et verrouiller l’accès SSH local sur un serveur Linux
# ========================================
# Mettre a jour les paquets et installer UFW
#sudo apt update && sudo apt install ufw -y  

# 🎨 Couleurs
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m"

# 📁 Définir les chemins
PROJECT_OWNER=$(logname)
BASE_PATH="/home/$PROJECT_OWNER/admin"
LOGS_PATH="$BASE_PATH/logs"

# 📜 Vérification des privilèges
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Veuillez exécuter ce script en tant que root.${RESET}"
    exit 1
fi

#  🚀 Activer UFW 
echo -e "${YELLOW}Activation du pare-feu UFW...${RESET}"
ufw enable

#  🔧 Règles de base
ufw default deny incoming
ufw default allow outgoing

#  🔒 Autoriser seulement le trafic local et HTTP/HTTPS simulé
ufw allow from 127.0.0.1 
ufw allow 80/tcp
ufw allow 443/tcp

#  🔒 Bloquer l’accès SSH distant
ufw deny 22/tcp

#  📜 Journalisation
ufw logging on

#  📜 Logger les actions
echo -e "${GREEN}Configuration du pare-feu terminée avec succès.${RESET}"
echo "$(date '+%Y-%m-%d %H:%M:%S') - Pare-feu UFW configuré et activé." >> "$LOGS_PATH/firewall_setup.log"

echo -e "${GREEN}Pare-feu configuré avec succès !${RESET}"
ufw status verbose