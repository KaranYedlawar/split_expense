#!/usr/bin/env bash
#exit on error
set -o errexit

bundle install
yarn install --check-files
bundle exec rails assets:precompile
bundle exec rails db:migrate
