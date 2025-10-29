#!/bin/bash
# ========================================
# Script : setup_server.sh
# Auteur : Riuk
# Objectif : Automatisation et gestion multi-utilisateurs sur un serveur web Linux
# ========================================

#Definir les chemins
BASE_PATH="$HOME/admin"

#Creer des repertoires necessaires
mkdir -p "$BASE_PATH"/{users,configs,backups,logs,scripts}
#mkdir -p "$BASE_PATH"/users/{admin,guest,developer}
echo "Repertoires de base crees."

touch "$BASE_PATH"/logs/users_activity.log
touch "$BASE_PATH"/logs/server_errors.log
touch "$BASE_PATH"/scripts/{add_user.sh,remove_user.sh,backup_users.sh,monitor_users.sh}
echo "Fichiers de log et scripts crees."