#!/usr/bin/env bash
set -euo pipefail

echo "=== Render Build Script Starting ==="
export RAILS_ENV=production
export NODE_ENV=production
export NODE_OPTIONS="--max-old-space-size=512"

echo "=== Installing Gems ==="
bundle install --jobs 4 --retry 3

echo "=== Installing Node/Yarn Dependencies ==="
yarn install --check-files

echo "=== Precompiling Assets ==="
bundle exec rails assets:precompile

echo "=== Cleaning Old Assets ==="
bundle exec rails assets:clean

echo "=== Running Migrations ==="
bundle exec rails db:migrate

echo "=== Build Complete ==="
