#!/bin/bash
cd "$(dirname "$0")"

# Dependencies
sudo apt-get update
sudo apt-get install -y \
    libmcrypt-dev

# Get the latest tag
TAG=$(/opt/build/php/7.3/bin/pecl remote-info mcrypt | grep Latest | sed -e  "s/Latest \s*//g")

/opt/build/php/7.3/bin/pecl install mcrypt-${TAG}

