# Installer l'application
docker compose run --no-deps web rails new . -d=postgresql -c=tailwind --skip-bundle
docker compose run web bundle lock --add-platform x86_64-linux
docker compose build --no-cache

# Lancer l'application
docker compose up

# Arrêter l'application
docker compose down

# Finir d'installer devise (pour l'autentification)
- Action controller
docker compose run web rails generate devise:install
- Vue
docker compose run web rails generate devise:views


# Création page home non connecté
docker compose run web rails generate controller home index

- rajout régle de securite dans app/controllers/application_controller.rb
before_action :authenticate_user!

- echaper a cette régle dans app/controllers/home_controller.rb
skip_before_action :authenticate_user!


- configuration de la redirection dans les routes avec root
 get "home", to: "home#index"
root 'home#index'

