#!/usr/bin/env bash

set -o errexit

bundle install
bin/rails webpacker:compile
bin/rails assets:precompile
bin/rails assets:clean

bin/rails db:migrate
