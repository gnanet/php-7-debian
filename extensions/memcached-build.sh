#!/bin/bash
cd "$(dirname "$0")"

# Dependencies
sudo apt-get update
sudo apt-get install -y \
    libmemcached-dev \
    libmemcached11

git clone https://github.com/php-memcached-dev/php-memcached
cd php-memcached

# Fetch the latest changes
git fetch --tags --prune

# Get the latest tag
TAG=$(git describe --tags $(git rev-list --tags --max-count=1))

git checkout -f tags/$TAG
git reset --hard

/opt/build/php/7.3/bin/phpize
./configure --with-php-config=/opt/build/php/7.3/bin/php-config

make
sudo make install
