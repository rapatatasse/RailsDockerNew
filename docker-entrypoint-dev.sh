#!/bin/bash
set -e

# Script d'entrée pour le développement Rails avec Docker
# Compatible avec Rails 7+ et PostgreSQL

echo "🚀 Initialisation de l'environnement Rails..."

# Attendre que PostgreSQL soit prêt
echo "⏳ Attente de PostgreSQL..."
until pg_isready -h db -p 5432 -U rails; do
  echo "PostgreSQL n'est pas encore prêt - attente..."
  sleep 2
done
echo "✅ PostgreSQL est prêt!"

# Installer les gems si nécessaire
if [ ! -f "/usr/local/bundle/gems.installed" ]; then
  echo "📦 Installation des gems..."
  bundle install
  touch /usr/local/bundle/gems.installed
  echo "✅ Gems installées!"
else
  echo "📦 Vérification des gems..."
  bundle check || bundle install
fi

# Préparer la base de données (création + migrations)
echo "🗄️  Préparation de la base de données..."
bundle exec rails db:prepare

# Installer les dépendances JavaScript si package.json existe
if [ -f "package.json" ]; then
  echo "📦 Installation des dépendances JavaScript..."
  npm install
fi

# Précompiler les assets pour Tailwind CSS en développement
echo "🎨 Préparation des assets CSS..."
bundle exec rails assets:precompile || echo "⚠️  Précompilation des assets échouée (normal si pas encore d'assets)"

# Nettoyer les fichiers temporaires
echo "🧹 Nettoyage des fichiers temporaires..."
rm -f tmp/pids/server.pid

echo "🎉 Initialisation terminée! Démarrage de l'application..."

# Exécuter la commande passée en paramètre
exec "$@"
