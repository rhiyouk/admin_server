#!/bin/bash
# ========================================
# Script : remove_user.sh
# Auteur : Riuk
# Objectif : Supprimer un utilisateur du serveur web Linux
# ========================================

#🎨 Couleurs
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

#📁 Definir les chemins
PROJECT_OWNER=$(logname)
BASE_PATH="/home/$PROJECT_OWNER/admin"
USERS_PATH="$BASE_PATH/users"
LOGS_PATH="$BASE_PATH/logs"
BACKUP_PATH="$BASE_PATH/backups"

#Verifier les droits d'execution
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED} Veuillez exécuter ce script en tant que root.${RESET}"
    exit 1
fi

# Afficher l'en-tête
echo -e "${BLUE}=== SUPPRESSION D'UN UTILISATEUR ===${RESET}"

# Demander le nom d'utilisateur à supprimer
read -p "Entrez le nom d'utilisateur à supprimer : " USERNAME

# Vérifier si l'utilisateur a fourni un nom d'utilisateur
if [ -z "$USERNAME" ]; then
    echo -e "${RED}Veuillez fournir un nom d'utilisateur à supprimer.${RESET}"
    exit 1
fi

# Supprimer l'utilisateur
userdel -r "$USERNAME"

# Vérifier si la suppression a réussi
if [ $? -eq 0 ]; then
    echo -e "${GREEN}L'utilisateur $USERNAME a été supprimé avec succès.${RESET}"
    # Journaliser l'activité
    echo "$(date): Utilisateur $USERNAME supprimé." >> "$LOGS_PATH/users_activity.log"
else
    echo -e "${RED}Erreur lors de la suppression de l'utilisateur $USERNAME.${RESET}"
    echo "$(date): Échec de la suppression de l'utilisateur $USERNAME." >> "$LOGS_PATH/users_activity.log"
    exit 1
fi

# Supprimer le répertoire de l'utilisateur s'il existe
if [ -d "$USERS_PATH/$USERNAME" ]; then

    # Archiver les données avant suppression (optionnel)
    DATE=$(date +%Y%m%d_%H%M%S)
    BACKUP_FILE="$BACKUP_PATH/${USERNAME}_backup_$DATE.tar.gz"
    tar -czf "$BACKUP_FILE" -C "$USERS_PATH" "$USERNAME"


    # Supprimer le répertoire de l'utilisateur
    rm -rf "$USERS_PATH/$USERNAME"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Le répertoire de l'utilisateur $USERNAME a été supprimé avec succès.${RESET}"
        # Journaliser l'activité
        echo "$(date): Répertoire de l'utilisateur $USERNAME supprimé." >> "$LOGS_PATH/users_activity.log"
    else
        echo -e "${RED}Erreur lors de la suppression du répertoire de l'utilisateur $USERNAME.${RESET}"
        echo "$(date): Échec de la suppression du répertoire de l'utilisateur $USERNAME." >> "$LOGS_PATH/users_activity.log"
    fi
else
    echo -e "${YELLOW}Le répertoire de l'utilisateur $USERNAME n'existe pas.${RESET}"
    # Journaliser l'activité
    echo "$(date): Le répertoire de l'utilisateur $USERNAME n'existe pas." >> "$LOGS_PATH/users_activity.log"
fi