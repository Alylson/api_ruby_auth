# syntax = docker/dockerfile:1

# Define a versão do Ruby
ARG RUBY_VERSION=3.2.0
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Define o diretório de trabalho
WORKDIR /rails

# Define o ambiente como desenvolvimento
ENV RAILS_ENV="development" \
    BUNDLE_PATH="/usr/local/bundle"

# Instalação de pacotes para desenvolvimento
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libvips pkg-config curl libsqlite3-0 libmysqlclient-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copia o Gemfile e Gemfile.lock e instala as dependências
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copia o código da aplicação
COPY . .

# Expõe a porta padrão do Rails
EXPOSE 3000

# Comando padrão para rodar o servidor Rails
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
