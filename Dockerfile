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
ENV BUNDLE_BIN=/bundle/bin
ENV BUNDLE_JOBS=4
ENV BUNDLE_RETRY=3
ENV PATH="/app/bin:/bundle/bin:${PATH}"

# Préconfigure bundler pour path et bin
RUN bundle config set path "$BUNDLE_PATH" \
  && bundle config set bin "$BUNDLE_BIN"

# Copie les fichiers de dépendances Ruby
COPY Gemfile ./
COPY Gemfile.lock* ./

# Installe Bundler et les gems
RUN gem install bundler && bundle install

# Copie le reste du projet
COPY . .

# S'assure que l'entrypoint est exécutable s'il est présent
RUN if [ -f bin/docker-entrypoint ]; then chmod +x bin/docker-entrypoint; fi

# Expose le port Rails
EXPOSE 3000

# Entrypoint gère bundle/pid puis exécute la commande
ENTRYPOINT ["bin/docker-entrypoint"]

# Commande par défaut au lancement du conteneur (peut être surchargée par compose)
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]
