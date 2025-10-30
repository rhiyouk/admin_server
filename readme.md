🧑‍💻 Admin User Management System

Auteur : Riuk
Langage : Bash
Plateforme : Linux
Description :
Ce projet est un ensemble de scripts Bash permettant la gestion complète des utilisateurs d’un serveur web Linux.
Il offre les fonctionnalités suivantes :

➕ Ajout d’un nouvel utilisateur

💾 Sauvegarde des répertoires utilisateurs

❌ Suppression d’un utilisateur

🧠 Journalisation automatique de toutes les actions

/home/riuk/admin/
│
├── scripts/
│   ├── add_user.sh          # Ajouter un utilisateur
│   ├── backup_users.sh      # Sauvegarder les répertoires utilisateurs
│   ├── delete_user.sh       # Supprimer un utilisateur (optionnel)
│
├── users/                   # Répertoires individuels des utilisateurs
│   ├── user1/
│   ├── user2/
│
├── backups/                 # Fichiers de sauvegarde compressés (.tar.gz)
│
└── logs/
    ├── users_activity.log   # Journal des ajouts d’utilisateurs
    └── backup_activity.log  # Journal des sauvegardes

⚙️ Installation

Donner les permissions d’exécution aux scripts :

chmod +x /home/riuk/admin/scripts/*.sh


Vérifier la structure des dossiers :

mkdir -p /home/riuk/admin/{users,backups,logs}


Exécuter les scripts depuis le terminal :

Ajouter un utilisateur :

sudo /home/riuk/admin/scripts/add_user.sh


Sauvegarder tous les utilisateurs :

sudo /home/riuk/admin/scripts/backup_users.sh


Supprimer un utilisateur :

sudo /home/riuk/admin/scripts/delete_user.sh

🧰 Détails des scripts
➕ add_user.sh

Ajoute un nouvel utilisateur système et crée un dossier associé dans admin/users/.

Vérifie si l’utilisateur existe déjà

Crée le dossier /home/riuk/admin/users/<nom>

Journalise l’action dans logs/users_activity.log

💾 backup_users.sh

Crée une sauvegarde compressée (.tar.gz) de chaque dossier utilisateur.
Chaque fichier de sauvegarde contient la date et l’heure de création.

Fichiers sauvegardés dans /home/riuk/admin/backups/

Journalisation détaillée dans logs/backup_activity.log

❌ delete_user.sh (optionnel)

Supprime un utilisateur du projet.

Affiche la liste des utilisateurs existants

Supprime le dossier correspondant dans admin/users/

Journalise la suppression

🧠 Journaux (Logs)

Chaque action (ajout, suppression, sauvegarde) est enregistrée avec la date et l’heure dans le dossier logs/.
Exemple de contenu :

2025-10-27_14:42:18 - Sauvegarde réussie pour user1 : /home/riuk/admin/backups/user1_backup_20251027_144218.tar.gz
2025-10-27_14:43:05 - Utilisateur user2 ajouté.

🧾 Bonnes pratiques

Toujours exécuter les scripts avec sudo pour éviter les problèmes de permission.

Vérifier régulièrement les logs pour suivre les opérations.

Planifier les sauvegardes automatiques via cron si nécessaire :

crontab -e


Exemple : sauvegarde quotidienne à 2h du matin

0 2 * * * /home/riuk/admin/scripts/backup_users.sh

📜 Licence

Ce projet est distribué sous licence MIT — vous êtes libre de le modifier et de le réutiliser avec mention de l’auteur original.

Mise a jour 
## But
Sécuriser les dossiers sensibles du projet `/home/riuk/admin/` (logs, backups, scripts) et journaliser les actions de sécurisation.

## Emplacement
Script principal :
/home/riuk/admin/security/secure_permissions.sh

Logs :
/home/riuk/admin/logs/security.log

## Prérequis
- Sudo / accès root.
- Structure minimale existante :
  - /home/riuk/admin/scripts/
  - /home/riuk/admin/logs/
  - /home/riuk/admin/backups/

Si un dossier manque, le script le signale dans le log.

## Fonctionnalités
- Crée le fichier de log `security.log` si absent.
- Applique `chmod 700` et `chown root:root` sur :
  - /home/riuk/admin/logs
  - /home/riuk/admin/backups
- Protège les scripts Bash : `chmod 700` et `chown root:root` sur `/home/riuk/admin/scripts/*.sh`
- Écrit une entrée horodatée dans `security.log` pour chaque action.
- Affiche un retour en couleur dans la console.

## Usage
1. Rendre exécutable :
   ```bash
   sudo chmod +x /home/riuk/admin/security/secure_permissions.sh


## 🔥 Jour 2 – Pare-feu et verrouillage SSH local

### 🎯 Objectif :
Mettre en place une sécurité réseau basique avec **UFW** (pare-feu Linux) et bloquer les connexions SSH externes pour simuler un serveur isolé.

### ⚙️ Fichier :
`/home/riuk/admin/scripts/setup_firewall.sh`

### 🧠 Fonctionnalités :
- Active automatiquement le pare-feu UFW  
- Bloque toutes les connexions entrantes sauf :
  - les connexions locales (`127.0.0.1`)
  - HTTP (`80/tcp`)
  - HTTPS (`443/tcp`)
- Interdit les connexions SSH externes (`22/tcp`)
- Journalise les actions dans `logs/security_audit.log`

### 📦 Commandes utiles :
```bash
sudo ufw status verbose     # Voir les règles actives
sudo ufw reset              # Réinitialiser le pare-feu
sudo ufw disable            # Désactiver le pare-feu

## 🧠 Jour 3 – Supervision système (Monitoring CPU, RAM, disque)

### 🎯 Objectif :
Créer un outil de supervision simple pour surveiller les ressources critiques du serveur :
- CPU
- RAM
- Disque principal

### ⚙️ Script :
`/home/riuk/admin/scripts/monitor_system.sh`

### 🧠 Fonctionnement :
- Le script vérifie :
  - le **taux d’utilisation CPU** (`top`)
  - la **mémoire vive utilisée** (`free`)
  - l’**espace disque** (`df`)
- Compare les valeurs à des seuils critiques :
  - CPU > 80%
  - RAM > 85%
  - DISQUE > 90%
- Si une alerte est détectée :
  - un message rouge s’affiche dans le terminal
  - un log est enregistré dans `logs/system_monitor.log`

### 💾 Exemple de sortie :
CPU OK : 23%
RAM OK : 42%
Disque OK : 56%
Les résultats ont été enregistrés dans : /home/riuk/admin/logs/system_monitor.log