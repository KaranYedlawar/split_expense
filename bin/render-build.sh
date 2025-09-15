#!/usr/bin/env bash
set -o errexit

bundle install
bundle exec rails webpacker:compile
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate
