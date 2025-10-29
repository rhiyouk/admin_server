#!/bin/bash
# ========================================
# Script : monitor_users.sh
# Auteur : Riuk
# Objectif : Surveiller l'activité des utilisateurs sur un serveur web Linux
# ========================================
# 🎨 Couleurs
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"
# 📁 Definir les chemins
PROJECT_OWNER=$(logname)
BASE_PATH="/home/$PROJECT_OWNER/admin"
USERS_PATH="$BASE_PATH/users"
LOGS_PATH="$BASE_PATH/logs"
BACKUP_PATH="$BASE_PATH/backups"
# Verifier les droits d'execution
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED} Veuillez exécuter ce script en tant que root.${RESET}"
    exit 1
fi
# Afficher l'en-tête
echo -e "${BLUE}=== SURVEILLANCE DE L'ACTIVITÉ DES UTILISATEURS ===${RESET}"
#Liste des connexions recentes
echo -e "${YELLOW}Connexions récentes des utilisateurs :${RESET}"
lastlog | grep -v "Never logged in" | awk '{print $1, $4, $5, $6, $7, $8}'
echo ""
#Afficher les fichiers recemment modifies dans les repertoires utilisateurs
echo -e "${YELLOW}Fichiers récemment modifiés dans les répertoires des utilisateurs :${RESET}"
for user_dir in "$USERS_PATH"/*; do
    if [ -d "$user_dir" ]; then
        USERNAME=$(basename "$user_dir")
        echo -e "${BLUE}Modifications récentes pour l'utilisateur $USERNAME :${RESET}"
        find "$user_dir" -type f -printf '%TY-%Tm-%Td %TH:%TM %p\n' | sort -r | head -n 5
        echo ""
    fi
done
# 🕵️‍♂️ Surveiller l'activité des utilisateurs
tail -f "$LOGS_PATH/users_activity.log" | while read LINE; do
    echo -e "${YELLOW}Activité utilisateur détectée : ${RESET}$LINE"
    # Vous pouvez ajouter des actions supplémentaires ici, comme envoyer une notification par e-mail
    # Exemple : echo "$LINE" | mail -s "Alerte d'activité utilisateur" admin@example.com
done