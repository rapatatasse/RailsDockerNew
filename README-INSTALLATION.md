# 🚀 Installation Rails avec Docker - Guide Étudiant

Ce guide vous permet d'installer et de déployer une application Rails avec Docker sur **Windows 11**, **Linux** et **macOS**.

## 📋 Prérequis

### Pour tous les systèmes :
- **Docker Desktop** installé et fonctionnel
- **Git** pour cloner le projet
- Un éditeur de code (VS Code recommandé)

### Installation Docker :
- **Windows 11** : [Docker Desktop pour Windows](https://docs.docker.com/desktop/windows/install/)
- **macOS** : [Docker Desktop pour Mac](https://docs.docker.com/desktop/mac/install/)
- **Linux** : [Docker Engine](https://docs.docker.com/engine/install/) + [Docker Compose](https://docs.docker.com/compose/install/)

## 🎯 Installation Rapide

### Windows 11 (PowerShell)

```powershell
# 1. Cloner le projet
git clone <votre-repo>
cd <nom-du-projet>

# 2. Exécuter le script d'installation
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\setup-windows.ps1
```

### Linux / macOS (Terminal)

```bash
# 1. Cloner le projet
git clone <votre-repo>
cd <nom-du-projet>

# 2. Rendre le script exécutable et l'exécuter
chmod +x setup-unix.sh
./setup-unix.sh
```

## 🔧 Installation Manuelle

Si les scripts automatiques ne fonctionnent pas, suivez ces étapes :

### 1. Configuration des variables d'environnement

#### Windows (PowerShell) :
```powershell
$env:DOCKER_USER_ID = "1000"
$env:DOCKER_GROUP_ID = "1000"
$env:DOCKER_USERNAME = "rails"
```

#### Linux/macOS (Terminal) :
```bash
export DOCKER_USER_ID=$(id -u)
export DOCKER_GROUP_ID=$(id -g)
export DOCKER_USERNAME=$(whoami)
```

### 2. Créer le fichier .env

Créez un fichier `.env` à la racine du projet :

```env
DOCKER_USER_ID=1000
DOCKER_GROUP_ID=1000
DOCKER_USERNAME=rails
```

**Note** : Sur Linux/macOS, remplacez `1000` par votre vrai UID/GID (obtenus avec `id -u` et `id -g`)

### 3. Construire et démarrer l'application

```bash
# Arrêter les conteneurs existants
docker-compose down

# Construire les images
docker-compose build --no-cache

# Démarrer l'application
docker-compose up -d
```

## 🌐 Accès à l'application

Une fois l'installation terminée :

- **Application Rails** : http://localhost:3000
- **Base de données PostgreSQL** : localhost:5432
  - Utilisateur : `rails`
  - Mot de passe : `password`
  - Base : `rails_development`

## 📊 Commandes utiles

```bash
# Voir les logs de l'application
docker-compose logs -f web

# Accéder au conteneur Rails
docker-compose exec web bash

# Redémarrer l'application
docker-compose restart web

# Arrêter complètement
docker-compose down

# Supprimer tout (attention : perte de données)
docker-compose down -v
docker system prune -a
```

## 🛠️ Développement

### Modifier les fichiers

Tous les fichiers du projet sont synchronisés avec le conteneur. Vous pouvez :
- Modifier les fichiers directement sur votre machine
- Les changements sont automatiquement reflétés dans le conteneur
- Pas besoin de redémarrer pour les modifications de code

### Ajouter des gems

```bash
# 1. Modifier le Gemfile sur votre machine
# 2. Reconstruire le conteneur
docker-compose build web
docker-compose up -d
```

### Commandes Rails

```bash
# Générer un contrôleur
docker-compose exec web rails generate controller Pages home

# Créer une migration
docker-compose exec web rails generate migration CreateUsers name:string email:string

# Exécuter les migrations
docker-compose exec web rails db:migrate

# Console Rails
docker-compose exec web rails console

# Tests
docker-compose exec web rails test
```

## 🐛 Résolution de problèmes

### Problème de permissions (Linux/macOS)

Si vous ne pouvez pas modifier les fichiers :

```bash
# Corriger les permissions
sudo chown -R $(id -u):$(id -g) .

# Ou utiliser Docker
docker-compose exec web chown -R $(id -u):$(id -g) /app
```

### L'application ne démarre pas

```bash
# Vérifier les logs
docker-compose logs web

# Reconstruire complètement
docker-compose down
docker-compose build --no-cache
docker-compose up
```

### Port 3000 déjà utilisé

```bash
# Trouver le processus qui utilise le port
# Windows
netstat -ano | findstr :3000

# Linux/macOS  
lsof -i :3000

# Ou changer le port dans docker-compose.yml
ports:
  - "3001:3000"  # Utiliser le port 3001 à la place
```

### Base de données non accessible

```bash
# Vérifier que PostgreSQL fonctionne
docker-compose logs db

# Recréer la base de données
docker-compose exec web rails db:drop db:create db:migrate
```

## 📚 Structure du projet

```
votre-projet/
├── Dockerfile.dev              # Image Docker pour le développement
├── docker-compose.yml          # Configuration des services
├── docker-entrypoint-dev.sh    # Script d'initialisation
├── setup-windows.ps1           # Installation automatique Windows
├── setup-unix.sh               # Installation automatique Linux/macOS
├── .env                        # Variables d'environnement (à créer)
├── Gemfile                     # Dépendances Ruby
└── config/
    └── database.yml            # Configuration base de données
```

## 🎓 Pour aller plus loin

- [Documentation Rails](https://guides.rubyonrails.org/)
- [Documentation Docker](https://docs.docker.com/)
- [PostgreSQL avec Rails](https://guides.rubyonrails.org/configuring.html#configuring-a-database)

## 💡 Conseils

1. **Toujours utiliser les scripts d'installation** pour éviter les erreurs
2. **Vérifier que Docker fonctionne** avant de commencer
3. **Sauvegarder vos données** avant de faire `docker-compose down -v`
4. **Utiliser les logs** pour diagnostiquer les problèmes
5. **Ne pas modifier les fichiers Docker** sans comprendre leur rôle

---

**Besoin d'aide ?** Consultez les logs avec `docker-compose logs -f web` ou demandez à votre formateur ! 🚀
