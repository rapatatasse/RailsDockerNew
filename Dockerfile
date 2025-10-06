# Utilise une image Ruby stable
FROM ruby:3.3.9

# Installe toutes les dépendances nécessaires pour Rails, SQLite et compilation de gems natives
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  nodejs \
  sqlite3 \
  libyaml-dev \
  libvips \
  curl \
  git \
  pkg-config

# Crée le dossier de travail
WORKDIR /app

# Configure Bundler pour installer les gems dans un dossier dédié (monté en volume)
ENV BUNDLE_PATH=/bundle
ENV BUNDLE_JOBS=4
ENV BUNDLE_RETRY=3

# Copie les fichiers de dépendances Ruby
COPY Gemfile ./
COPY Gemfile.lock* ./

# Installe Bundler et les gems
RUN gem install bundler && bundle install

# Copie le reste du projet
COPY . .

# Expose le port Rails
EXPOSE 3000

# Commande par défaut au lancement du conteneur
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
