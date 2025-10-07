# Script d'installation pour Windows 11
# Exécuter en tant qu'administrateur: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

Write-Host "🚀 Configuration de l'environnement Rails pour Windows 11" -ForegroundColor Green

# Définir les variables d'environnement Docker
$env:DOCKER_USER_ID = "1000"
$env:DOCKER_GROUP_ID = "1000" 
$env:DOCKER_USERNAME = "rails"

Write-Host "📝 Variables d'environnement configurées:" -ForegroundColor Yellow
Write-Host "   DOCKER_USER_ID: $env:DOCKER_USER_ID"
Write-Host "   DOCKER_GROUP_ID: $env:DOCKER_GROUP_ID"
Write-Host "   DOCKER_USERNAME: $env:DOCKER_USERNAME"

# Créer le fichier .env pour persister les variables
@"
DOCKER_USER_ID=1000
DOCKER_GROUP_ID=1000
DOCKER_USERNAME=rails
"@ | Out-File -FilePath ".env" -Encoding UTF8

Write-Host "✅ Fichier .env créé avec les variables d'environnement" -ForegroundColor Green

# Arrêter les conteneurs existants
Write-Host "🛑 Arrêt des conteneurs existants..." -ForegroundColor Yellow
docker-compose down 2>$null

# Construire et démarrer les conteneurs
Write-Host "🔨 Construction des conteneurs..." -ForegroundColor Yellow
docker-compose build --no-cache

Write-Host "🚀 Démarrage de l'application..." -ForegroundColor Yellow
docker-compose up -d

Write-Host "🎉 Installation terminée!" -ForegroundColor Green
Write-Host "🌐 Votre application Rails est disponible sur: http://localhost:3000" -ForegroundColor Cyan
Write-Host "📊 Pour voir les logs: docker-compose logs -f web" -ForegroundColor Gray
