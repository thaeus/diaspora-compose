#!/bin/bash --login

set -e

cd /home/diaspora

umask 000

gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB || (
  curl -sSL https://rvm.io/mpapis.asc | gpg --import --no-tty -
  curl -sSL https://rvm.io/pkuczynski.asc | gpg --import --no-tty - 
)

curl -L https://s.diaspora.software/1t | bash

echo '[[ -s "/home/diaspora/.rvm/scripts/rvm" ]] && source "/home/diaspora/.rvm/scripts/rvm"' >> /home/diaspora/.bashrc
source "/home/diaspora/.rvm/scripts/rvm"
rvm autolibs read-fail
rvm install ${RUBY_VERSION} 

git clone --branch ${GIT_BRANCH} --single-branch ${GIT_URL}
cd diaspora

mkdir -p public/uploads/images

gem update --system ${GEM_VERSION}
gem install bundler -v 1.17.1
RAILS_ENV=production bin/bundle install --no-cache --deployment --without test development --with postgresql
rvm cleanup all

tar czf public/source.tar.gz  $(git ls-tree -r ${GIT_BRANCH} | awk '{print $4}')

cp /diaspora.yml config/
cp config/database.yml.example config/database.yml
RAILS_ENV=production bin/rake assets:precompile
rm config/diaspora.yml config/database.yml

rm -rf /home/diaspora/diaspora/tmp

ln -s /tmp /home/diaspora/.eye
ln -s /tmp /home/diaspora/diaspora/tmp
