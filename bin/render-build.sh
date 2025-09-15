#!/usr/bin/env bash
set -o errexit

bundle install

# Install JS dependencies so webpacker:compile can run
yarn install --check-files

# Compile webpacker packs into public/packs
bundle exec rails webpacker:compile

# Precompile Sprockets assets
bundle exec rails assets:precompile

# Clean old assets
bundle exec rails assets:clean

# Run migrations
bundle exec rails db:migrate
