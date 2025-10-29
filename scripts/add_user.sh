#!/bin/bash
# ========================================
# Script : add_user.sh
# Auteur : Riuk
# Objectif : Ajouter un nouvel utilisateur au serveur web Linux
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

#Verifier les droits d'execution
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED} Veuillez exécuter ce script en tant que root.${RESET}"
    exit 1
fi

# 👤 Demander le nom d'utilisateur
echo -e "${BLUE}=== AJOUT D'UN NOUVEL UTILISATEUR ===${RESET}"
read -p "Entrez le nom du nouvel utilisateur : " USERNAME

# ⚙️Verifier si l'utilisateur existe deja
if id "$USERNAME" &>/dev/null; then
    echo -e "${YELLOW}L'utilisateur $USERNAME existe déjà.${RESET}"
    exit 1
fi

#Ajouter l'utilisateur
useradd -m "$USERNAME"

# 🧾 Verifier si l'ajout a reussi
if [ $? -eq 0 ]; then
    echo -e "${GREEN}L'utilisateur $USERNAME a été ajouté avec succès.${RESET}"
    #Journaliser l'activité
    echo "$(date): Utilisateur $USERNAME ajouté." >> "$LOGS_PATH/users_activity.log"
else
    echo -e "${RED}Erreur lors de l'ajout de l'utilisateur $USERNAME.${RESET}"
    echo "$(date): Échec de l'ajout de l'utilisateur $USERNAME." >> "$LOGS_PATH/users_activity.log"
    exit 1
fi

mkdir -p "$USERS_PATH/$USERNAME"
chown "$USERNAME":"$USERNAME" "$USERS_PATH/$USERNAME"

# ✅ Verifier le dossier de l'utilisateur
if [ -d "$USERS_PATH/$USERNAME" ]; then
    echo -e "${GREEN}Le répertoire de l'utilisateur $USERNAME a été créé avec succès.${RESET}"
else
    echo -e "${RED}Erreur lors de la création du répertoire de l'utilisateur $USERNAME.${RESET}"
    exit 1
fi
echo -e "${BLUE}=== AJOUT DE L'UTILISATEUR TERMINÉ ===${RESET}"
exit 0