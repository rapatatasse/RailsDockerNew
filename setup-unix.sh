#!/bin/bash
# Script d'installation pour Linux et macOS

set -e

echo "🚀 Configuration de l'environnement Rails pour Linux/macOS"

# Détecter l'OS
OS="$(uname -s)"
case "${OS}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    *)          MACHINE="UNKNOWN:${OS}"
esac

echo "📱 Système détecté: $MACHINE"

# Obtenir l'UID et GID de l'utilisateur actuel
USER_ID=$(id -u)
GROUP_ID=$(id -g)
USERNAME=$(whoami)

echo "👤 Configuration utilisateur:"
echo "   USER_ID: $USER_ID"
echo "   GROUP_ID: $GROUP_ID"
echo "   USERNAME: $USERNAME"

# Créer le fichier .env avec les variables d'environnement
cat > .env << EOF
DOCKER_USER_ID=$USER_ID
DOCKER_GROUP_ID=$GROUP_ID
DOCKER_USERNAME=$USERNAME
EOF

echo "✅ Fichier .env créé avec les variables d'environnement"

# Exporter les variables pour la session courante
export DOCKER_USER_ID=$USER_ID
export DOCKER_GROUP_ID=$GROUP_ID
export DOCKER_USERNAME=$USERNAME

# Vérifier que Docker est installé
if ! command -v docker &> /dev/null; then
    echo "❌ Docker n'est pas installé. Veuillez l'installer d'abord."
    echo "   Linux: https://docs.docker.com/engine/install/"
    echo "   macOS: https://docs.docker.com/desktop/mac/install/"
    exit 1
fi

# Vérifier que Docker Compose est installé
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi

# Arrêter les conteneurs existants
echo "🛑 Arrêt des conteneurs existants..."
docker-compose down 2>/dev/null || true

# Construire et démarrer les conteneurs
echo "🔨 Construction des conteneurs..."
docker-compose build --no-cache

echo "🚀 Démarrage de l'application..."
docker-compose up -d

echo "🎉 Installation terminée!"
echo "🌐 Votre application Rails est disponible sur: http://localhost:3000"
echo "📊 Pour voir les logs: docker-compose logs -f web"

# Attendre que l'application soit prête
echo "⏳ Attente du démarrage de l'application..."
sleep 10

# Vérifier si l'application répond
if curl -s http://localhost:3000 > /dev/null; then
    echo "✅ Application démarrée avec succès!"
else
    echo "⚠️  L'application met du temps à démarrer. Vérifiez les logs avec: docker-compose logs -f web"
fi
