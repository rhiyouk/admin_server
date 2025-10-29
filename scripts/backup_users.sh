#!/bin/bash
# ========================================
# Script : backup_users.sh
# Auteur : Riuk
# Objectif : Sauvegarder les répertoires des utilisateurs sur un serveur web Linux
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
BACKUP_PATH="$BASE_PATH/backups"
LOGS_PATH="$BASE_PATH/logs"

#Definir la date pour le nom de la sauvegarde
DATE=$(date +%Y%m%d_%H%M%S)

# 🗂️ Créer une sauvegarde des répertoires des utilisateurs
for user in "$USERS_PATH"/*; do
    if [ -d "$user" ]; then
        USERNAME=$(basename "$user")
        BACKUP_FILE="$BACKUP_PATH/${USERNAME}_backup_$DATE.tar.gz"
        tar -czf "$BACKUP_FILE" -C "$USERS_PATH" "$USERNAME"
        # ✅ Vérifier si la sauvegarde a réussi
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Sauvegarde de l'utilisateur $USERNAME réussie : $BACKUP_FILE${RESET}"
            #Journaliser l'activité
            echo "$(date +%Y-%m-%d_%H:%M:%S) - Sauvegarde réussie pour $USERNAME : $BACKUP_FILE" >> "$LOGS_PATH/backup_activity.log"
        else
            echo -e "${RED}Erreur lors de la sauvegarde de l'utilisateur $USERNAME.${RESET}"
            echo "$(date +%Y-%m-%d_%H:%M:%S) - Échec de la sauvegarde pour $USERNAME." >> "$LOGS_PATH/backup_activity.log"
        fi
    fi
done

echo -e "${BLUE}Sauvegarde des utilisateurs terminée.${RESET}"

# Suppression des anciennes sauvegardes de plus de 7 jours (optionnel)
find "$BACKUP_PATH" -type f -name "*.tar.gz" -mtime +7 -exec rm {} \;
echo -e "${YELLOW}Anciennes sauvegardes de plus de 7 jours supprimées.${RESET}"
echo "$(date +%Y-%m-%d_%H:%M:%S) - Anciennes sauvegardes supprimées." >> "$LOGS_PATH/backup_activity.log"
# Fin du script