# Commande Rails pour migrer/ creer contoller / view ...

Ce guide résume les commandes Rails les plus utiles et comment les exécuter avec Docker (service `web` défini dans `docker-compose.yml`).

## Exécuter les commandes

- **Local (si Ruby/rails installés en hôte)**
```bash
bin/rails <commande>
```
- **Avec Docker (recommandé ici)**
```bash
# Lancer l'app
docker compose up

# Exécuter une commande ponctuelle (sans attacher le serveur)
docker compose run --rm web bin/rails <commande>

# Exécuter dans le conteneur déjà lancé
docker compose exec web bin/rails <commande>
```
## Générateurs (generate)

- **Controller simple**
```bash
bin/rails generate controller Welcome index
# Docker: docker compose run --rm web bin/rails generate controller Welcome index
```
- **Model (avec migration)**
```bash
bin/rails generate model Article title:string body:text published:boolean
# Docker: docker compose run --rm web bin/rails generate model Article title:string body:text published:boolean
```
- **Migration seule**
```bash
bin/rails generate migration AddPublishedToArticles published:boolean
```
- **Scaffold (CRUD complet: model + controller + vues + routes)**
```bash
bin/rails generate scaffold Post title:string content:text
```
## Migrations & base de données

- **Appliquer les migrations**
```bash
bin/rails db:migrate
```
- **Créer la base (si nécessaire)**
```bash
bin/rails db:create
```
- **Annuler la dernière migration**
```bash
bin/rails db:rollback
# ou à une étape précise
bin/rails db:rollback STEP=2
```
- **Réinitialiser (attention: destructive en dev/test)**
```bash
bin/rails db:reset   # db:drop + db:create + db:migrate
```
- **Charger les seeds**
```bash
bin/rails db:seed
```
## Développement quotidien

- **Lister les routes**
```bash
bin/rails routes
```
- **Console Rails**
```bash
bin/rails console
```
- **Journal en temps réel**
```bash
bin/rails log:clear  # pour vider
# Avec Docker, voir aussi les logs du service
docker compose logs -f web
```
## Exemples de workflow

- **Créer une ressource avec Scaffold**
```bash
docker compose run --rm web bin/rails generate scaffold Task title:string done:boolean
docker compose run --rm web bin/rails db:migrate
docker compose up
```
- **Ajouter un champ via migration puis rollback**
```bash
docker compose run --rm web bin/rails generate migration AddDueDateToTasks due_date:date
docker compose run --rm web bin/rails db:migrate
# Oups ? rollback
docker compose run --rm web bin/rails db:rollback
```
- **Générer uniquement un controller et des vues**
```bash
docker compose run --rm web bin/rails generate controller Welcome index about contact
```
## Raccourcis utiles

- **Préfixer toutes les commandes Rails par Docker**: remplacer `bin/rails` par `docker compose exec web bin/rails` quand le conteneur est lancé, ou `docker compose run --rm web bin/rails` sinon.
- **Fichiers à consulter**: `docker-compose.yml` (service `web`), `Gemfile`, `db/migrate/` pour l’historique des migrations.

## Notes

- Ce projet utilise Rails 7 et SQLite (voir `Gemfile`).
- La commande de démarrage dans `docker-compose.yml` migre automatiquement la base au boot: `bin/rails db:migrate`.


# Pour aide au migration :

https://sites.google.com/view/tpass-bibli/g%C3%A9n%C3%A9rateur-de-code-ruby-on-rails