#!/bin/bash --login

cd diaspora
mkdir -p tmp/pids
mkdir -p tmp/cache

export RAILS_ENV=production 

bin/rake db:migrate
script/server
