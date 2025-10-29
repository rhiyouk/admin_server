#!/bin/bash
#=========================================
#script : secure_permissions.sh
#Auteur : Riuk
#Objectif : Assurer la securite des repertoires et fichiers critiques sur un serveur web Linux
#=========================================

#🎨 Couleurs
ROUGE="\033[31m"
VERT="\033[32m"
JAUNE="\033[33m"
BLEU="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
BLANC="\033[37m"
RESET="\033[0m"

#📁 Definir les chemins
PROJECT_OWNER=$(logname)
BASE_PATH="/home/$PROJECT_OWNER/admin"
LOGS_PATH="$BASE_PATH/logs"
SECURITY_LOG="$LOGS_PATH/security.log"

#Verifier les droits d'execution
if [ "$EUID" -ne 0 ]; then
    echo -e "${ROUGE} Veuillez exécuter ce script en tant que root.${RESET}"
    exit 1
fi

#Afficher l'en-tete
echo -e "${BLEU}=== SECURISATION DES PERMISSIONS DES REPERTOIRES ET FICHIERS CRITIQUES ===${RESET}" 

#Creer le fichier de log de securite s'il n'existe pas
if [ ! -f "$SECURITY_LOG" ]; then
    touch "$SECURITY_LOG"
    echo -e "${VERT}Fichier de log de sécurité créé : $SECURITY_LOG${RESET}"
fi

#Fichier de log de securite
echo "====== $(date '+%Y-%m-%d %H:%M:%S') ======" >> "$SECURITY_LOG"

#Securiser les repertoires critiques
echo -e "${JAUNE}Securisation des repertoires critiques...${RESET}"
for dir in "$BASE_PATH"/users/admin "$BASE_PATH"/configs "$BASE_PATH"/backups "$LOGS_PATH"; do
    if [ -d "$dir" ]; then
        chown root:root "$dir"
        chmod 700 "$dir"
        echo -e "${VERT}Répertoire sécurisé : $dir${RESET}"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Répertoire sécurisé : $dir" >> "$SECURITY_LOG"
    else
        echo -e "${ROUGE}Répertoire non trouvé : $dir${RESET}"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Répertoire non trouvé : $dir" >> "$SECURITY_LOG"
    fi
done

#Securiser les scripts
echo -e "${JAUNE}Securisation des scripts...${RESET}"
for script in "$BASE_PATH"/scripts/*.sh; do
    if [ -f "$script" ]; then
        chown root:root "$script"
        chmod 700 "$script"
        echo -e "${VERT}Script sécurisé : $script${RESET}"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Script sécurisé : $script" >> "$SECURITY_LOG"
    else
        echo -e "${ROUGE}Script non trouvé : $script${RESET}"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Script non trouvé : $script" >> "$SECURITY_LOG"
    fi
done

echo -e "${BLEU}=== SECURISATION TERMINEE ===${RESET}"